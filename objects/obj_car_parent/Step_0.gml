
// player moving
if (is_player) {
	accelerating = keyboard_check(global.player_input.accelerate);
	braking = keyboard_check(global.player_input.brake);
	boosting = keyboard_check(global.player_input.boost);
	
	turning = (keyboard_check(global.player_input.turn.right) << 1) | (keyboard_check(global.player_input.turn.left));
}
else {
	// non-player car control
	accelerating = true;
}

if (accelerating) {
	if (is_player) {
		engine_power += 0.1;
	}
	else {
		on_road_index = find_nearest_road(x, y);
		var next_road = find_nearest_road(x, y, 1);
		var angle_diff = angle_difference(on_road_index.direction, image_angle);
		
		assert(on_road_index.get_id() != next_road.get_id());
		if (ai_behavior.desired_lane > on_road_index.get_lanes_right()) {
			// desired lane doesn't exists, pick a new one
			alarm[1] = 1;
		}
		
		engine_power = on_road_index.get_ideal_throttle() * 0.9;
		var d = point_to_line(
			new vec2(on_road_index.x, on_road_index.y),
			new vec2(next_road.x, next_road.y),
			new vec2(x, y)
		);
		d.x += lengthdir_x(((-ai_behavior.desired_lane + 0.5) * on_road_index.lane_width), on_road_index.direction+90);
		d.y += lengthdir_y(((-ai_behavior.desired_lane + 0.5) * on_road_index.lane_width), on_road_index.direction+90);
		var side = -(angle_difference(image_angle, point_direction(x, y, d.x, d.y)));
		
		if (!on_road) {
			// off road, trying to get back on it
			// find the nearest road
			//var side = angle_difference(image_angle, point_direction(x,y,road.x,road.y));
			turn_rate += side / 600;
			engine_power = 1;
			gear_shift_down();
		}
		else {
			var tr = (angle_diff / 50) + (sign(side) / 40);
			turn_rate += clamp(tr, -2, 2);
			braking = abs(tr) > 2;
		}
		
		// checking other cars
		var look_ahead_threshold = 16;
		var car_look_ahead = collision_line(x, y, x+lengthdir_x(look_ahead_threshold, image_angle), y+lengthdir_y(look_ahead_threshold, image_angle), obj_car, false, true);
		var car_look_left = collision_line(x+lengthdir_x(4, image_angle+45), y+lengthdir_x(4, image_angle+45), x+lengthdir_x(look_ahead_threshold, image_angle+45), y+lengthdir_y(look_ahead_threshold, image_angle+45), obj_car, false, true);
		var car_look_right = collision_line(x+lengthdir_x(4, image_angle-45), y+lengthdir_x(4, image_angle-45), x+lengthdir_x(look_ahead_threshold, image_angle-45), y+lengthdir_y(look_ahead_threshold, image_angle-45), obj_car, false, true);
		var is_off_road_left = !is_on_road(x+lengthdir_x(look_ahead_threshold, image_angle+90), y+lengthdir_y(look_ahead_threshold, image_angle+90), last_road_index) ? 1 : 0;
		var is_off_road_right = !is_on_road(x+lengthdir_x(look_ahead_threshold, image_angle-90), y+lengthdir_y(look_ahead_threshold, image_angle-90), last_road_index) ? 1 : 0;

		turn_rate += -(is_off_road_left / 6) + (is_off_road_right / 6);
		if (!is_player) {
			if (car_look_ahead) {
				if (car_look_left) {turn_rate += 0.2;}
				else if (car_look_right) {turn_rate -= 0.2;}
				else {
					engine_power = 0;
				}
			}
		}
	}
}
else {
	engine_power -= 0.1;
}

if (turning != 0) {
	// checking turning
	if (turning & 1 == 0) {
		// checking left turn
		turn_rate -= 0.1;
	}
	else if (turning & 2 == 0) {
		// checking right turn
		turn_rate += 0.1;
	}
}

if (keyboard_check_pressed(vk_up)) {gear_shift_up();}
if (keyboard_check_pressed(vk_down)) {gear_shift_down();}

// moving car
if (can_move) {
	
	// surface friction	
	// first, location of cached index
	if (!is_on_road(x, y, last_road_index)) {
		// probably not on that segment anymore, recheck
		set_on_road();
	}
	// calculate engine stuff for acceleration
	var engine_to_wheel_ratio = gear_ratio[gear-1] * diff_ratio;
	var engine_torque_max = torque_lookup(engine_rpm);//5252 * horsepower / engine_rpm_max;
	
	var engine_torque = engine_torque_max * engine_power;
	var drive_torque = engine_torque * gear_ratio[gear-1] * diff_ratio * transfer_eff;
	
	var f_drag = -c_drag * velocity;
	var f_rr = -c_rr * velocity;
	var f_surface = -mass * 9.8 * ((on_road) ? 0.6 : 2);
	var f_brake = (braking) ? -abs(drive_torque / wheel_radius) * braking_power : 0;
	if (velocity <= 0) {
		f_brake = 0;
		f_surface = 0;
	}
	
	var wheel_rotation_rate = velocity * 100 / 3600 / wheel_radius;
	engine_rpm = (wheel_rotation_rate * engine_to_wheel_ratio * 60 / (2 * pi)) + 1000;
	
	var drive_force = (drive_torque / wheel_radius) + f_drag + f_rr + f_brake + f_surface;
	
	drive_torque = drive_force * wheel_radius;
	
	acceleration = (drive_torque / inertia);
	velocity += acceleration * (delta_time / 1000000);// * gear_ratio[gear-1];
	if (velocity <= 0) {
		velocity = 0;
	}
	
	// move car in direction
	turn_rate += -turn_rate * 0.1;
	turn_rate = clamp(turn_rate, -2, 2);
	
	direction += turn_rate;
	x += cos(degtorad(direction)) * velocity / 100;
	y -= sin(degtorad(direction)) * velocity / 100;
	image_angle = direction;
	
	gear_shift(); // auto gear shift
	engine_rpm = clamp(engine_rpm, 1000, engine_rpm_max);
	engine_power = clamp(engine_power, 0, 1);
	
	var engine_sound_pitch = (engine_rpm / engine_rpm_max)+0.3;
	if (is_player) {
		var engine_sound = audio_play_sound(snd_car, 10, false);
		audio_sound_pitch(engine_sound, engine_sound_pitch);
		
		audio_listener_position(x, y, 0);
	}
	else {
		audio_emitter_pitch(engine_sound_emitter, engine_sound_pitch);
		audio_play_sound_on(engine_sound_emitter, snd_car, false, 1);
		audio_emitter_position(engine_sound_emitter, x, y, 0);
	}
	
	gear_shift_wait = clamp(gear_shift_wait - 1, 0, 60);
}