
// player moving
if (is_player) {
	accelerating = keyboard_check(global.player_input.accelerate);
	braking = keyboard_check(global.player_input.brake);
	boosting = keyboard_check(global.player_input.boost);
	
	turning = (keyboard_check(global.player_input.turn.right) << 1) | (keyboard_check(global.player_input.turn.left));
}

if (accelerating) {
	engine_power += 0.1;
}
else {
	engine_power -= 0.1;
}

if (turning != 0) {
	// checking turning
	if (turning & 1 == 0) {
		// checking left turn
		turn_rate += 0.1;
	}
	else if (turning & 2 == 0) {
		// checking right turn
		turn_rate -= 0.1;
	}
}

if (keyboard_check_pressed(vk_up)) {gear_shift_up();}
if (keyboard_check_pressed(vk_down)) {gear_shift_down();}

// moving car
if (can_move) {
	// surface friction
	for (var rpi = 0; rpi < array_length(obj_road_generator.road_points); rpi+=4) {
		//check end of side
		if (!camera_in_view(obj_road_generator.road_points[rpi][0].x, obj_road_generator.road_points[rpi][0].y, 256)) {continue;}
		var p_x = [];
		var p_y = [];
		var lookup_index = [0,1,3,2]; // this is to line up the polygon correctly
		for (var i = 0; i < 4; i++) {
			p_x[array_length(p_x)] = obj_road_generator.road_points[rpi+lookup_index[i]][0].x;
			p_y[array_length(p_y)] = obj_road_generator.road_points[rpi+lookup_index[i]][0].y;
		}
		
		// on road collision
		on_road = pnpoly(4, p_x, p_y, x, y);
		if (on_road) {break;}
	}
	
	var engine_to_wheel_ratio = gear_ratio[gear-1] * diff_ratio;
	var engine_torque_max = torque_lookup(engine_rpm);//5252 * horsepower / engine_rpm_max;
	
	var engine_torque = engine_torque_max * engine_power;
	var drive_torque = engine_torque * gear_ratio[gear-1] * diff_ratio * transfer_eff;
	
	var inertia = mass * (wheel_radius * wheel_radius) / 2;
	var c_drag = 0.5 * 0.3 * 2.2 * AIR_DENSITY;
	var c_rr = 20 * c_drag;
	var f_drag = -c_drag * velocity;
	var f_rr = -c_rr * velocity;
	var f_surface = -mass * 9.8 * ((on_road) ? 0.6 : 2);
	var f_brake = (braking) ? (drive_torque / wheel_radius) * 100 : 0;
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
	direction += turn_rate;
	x += cos(degtorad(direction)) * velocity / 100;
	y += sin(degtorad(direction)) * velocity / 100;
	image_angle = -direction;
	
	gear_shift(); // auto gear shift
	engine_rpm = clamp(engine_rpm, 1000, engine_rpm_max);
	engine_power = clamp(engine_power, 0, 1);
	
	if (is_player) {
		var engine_sound = audio_play_sound(snd_car, 10, false);
		audio_sound_pitch(engine_sound, (engine_rpm / engine_rpm_max)+0.3);
	}
}