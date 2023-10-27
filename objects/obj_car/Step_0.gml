
// player moving
if (is_player) {
	accelerating = keyboard_check(global.player_input.accelerate);
	braking = keyboard_check(global.player_input.brake);
	boosting = keyboard_check(global.player_input.boost);
	
	turning = (keyboard_check(global.player_input.turn.right) << 1) | (keyboard_check(global.player_input.turn.left));
}

if (accelerating) {
	engine_power += 0.05;
}

if (braking) {
	velocity -= 0.2;
	engine_rpm *= 0.9;
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
	engine_rpm = clamp(engine_rpm, 1000, engine_rpm_max);
	
	var engine_to_wheel_ratio = gear_ratio[gear-1] * diff_ratio;
	var engine_torque_max = 5252 * horsepower / engine_rpm_max;
	var engine_torque = engine_torque_max * engine_rpm / engine_rpm_max;
	var drive_torque = engine_torque * gear_ratio[gear-1] * diff_ratio * transfer_eff;
	var inertia = mass * (wheel_radius * wheel_radius) / 2;
	var u = 0.8 * mass * 9.8;
	
	acceleration = (drive_torque / inertia);
	
	if (!accelerating) {
		var drive_force = drive_torque / wheel_radius;
		drive_force -= u / 10;
		drive_torque = drive_force * wheel_radius
		acceleration = (drive_torque / inertia);
		
		engine_rpm *= 0.95;
		engine_power -= 0.05;
	}
	else {
		engine_rpm += engine_power * 50 * gear_ratio[gear-1];
		acceleration = (drive_torque / inertia);
		if (velocity > 10 / gear_ratio[gear-1]) {
			acceleration = 0;
		}
	}
	
	velocity += (acceleration / 200) * gear_ratio[gear-1];
	velocity = clamp(velocity, 0, 18);
	
	// move car in direction
	turn_rate += -turn_rate * 0.1;
	direction += turn_rate;
	x += cos(degtorad(direction)) * velocity;
	y += sin(degtorad(direction)) * velocity;
	image_angle = -direction;
	
	gear_shift();
	engine_power = clamp(engine_power, 0, 1);
}