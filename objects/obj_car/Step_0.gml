
// player moving
if (is_player) {
	accelerating = keyboard_check(global.player_input.accelerate);
	braking = keyboard_check(global.player_input.brake);
	boosting = keyboard_check(global.player_input.boost);
	
	turning = (keyboard_check(global.player_input.turn.right) << 1) | (keyboard_check(global.player_input.turn.left));
}

if (accelerating) {
	engine_power += 0.01;
}

if (braking) {
	velocity -= 0.8;
	engine_rpm *= 0.9;
}

if (turning != 0) {
	// checking turning
	if (turning & 1 == 0) {
		// checking left turn
		direction += turn_rate;
	}
	else if (turning & 2 == 0) {
		// checking right turn
		direction -= turn_rate;
	}
}

// moving car
if (can_move) {
	engine_power = clamp(engine_power, 0, 1);
	
	//slowly loosing velocity
	if (accelerating) {
		engine_rpm += engine_power * 100;
	}
	else {
		engine_rpm *= 0.95;
	}
	engine_rpm = clamp(engine_rpm, 1000, engine_rpm_max);
	
	var engine_to_wheel_ratio = gear_ratio[gear-1] * diff_ratio;
	var engine_torque_max = 5252 * horsepower / engine_rpm_max;
	var engine_torque = engine_torque_max * engine_rpm / engine_rpm_max;
	var drive_torque = engine_torque * gear_ratio[gear-1] * diff_ratio * transfer_eff;
	
	var inertia = mass * (wheel_radius * wheel_radius) / 2;
	
	acceleration = (drive_torque / inertia);
	
	var u = 0.8 * mass * 9.8;
	show_debug_message($"{acceleration} {drive_torque} {inertia}");
	
	velocity += 0;//sqrt((u*u) - (2 * acceleration)) / 200;
	velocity = clamp(velocity, 0, 18);
	
	// move car in direction
	x += cos(degtorad(direction)) * velocity;
	y += sin(degtorad(direction)) * velocity;
	image_angle = -direction;
	
	if (keyboard_check_pressed(vk_up)) {gear = min(gear+1, 6); engine_rpm *= 0.125;}
	if (keyboard_check_pressed(vk_down)) {gear = max(gear-1, 1); engine_rpm *= 0.125;}
}