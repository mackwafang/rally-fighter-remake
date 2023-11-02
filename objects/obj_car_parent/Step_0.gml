
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
		var road = find_nearest_road(x + lengthdir_x(128, image_angle), y  + lengthdir_y(128, image_angle));
		var angle_diff = angle_difference(road.direction, image_angle);
		var angle_threshold = 0.5;
		
		engine_power = road.get_ideal_throttle();
		
		if (!on_road) {
			// off road, trying to get back on it
			// find the nearest road
			var side = sign(angle_difference(point_direction(road.x,road.y, x, y), image_angle));
			
			angle_diff = -side * 10;
			engine_power = 1;
			gear_shift_down();
			gear_shift_down();
			gear_shift_down();
			gear_shift_down();
		}
		
		turn_rate += (angle_diff / 150);
		braking = (velocity > (300000 / road.get_length()));
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
	
	if (is_player) {
		var engine_sound = audio_play_sound(snd_car, 10, false);
		audio_sound_pitch(engine_sound, (engine_rpm / engine_rpm_max)+0.3);
	}
}