depth = -10;

is_player = false;		// does car belong to player?
can_move = true;		// can car be affected by movement or collision?

engine_rpm_max = 10000;	// max rpm
engine_rpm = 0			// engine rpm
velocity = 0;			// car's speed
velocity_max = 18;		// car's max speed
wheel_radius = 0.34;	// wheel radius in m
mass = 1500;			// vehicle mass, in kg
horsepower = 900;		// horsepower
turn_rate = 0;			// car's turning rate
gear = 1;				// car's gear 
engine_power = 0;		// throttle position
transfer_eff = 0.7;		//transfer efficiency
acceleration = 0;		// acceleration value
braking_power = 30;		// braking magnetude

inertia = mass * (wheel_radius * wheel_radius) / 2;		// constant value for car's inertia
c_drag = 0.5 * 0.3 * 2.2 * AIR_DENSITY;					// constant value for car's air drag
c_rr = 20 * c_drag;										// constant value for car's drag

//gear's ratio
gear_ratio = [4, 2.2, 5/3, 4/3, 9/10, 8/10];
diff_ratio = 3.5;
gear_shift_rpm = [
	[0, 7000],
	[3000, 6250],
	[3500, 6000],
	[4000, 6000],
	[3000, 4500],
	[1100, 3000],
]

accelerating = false;	// flag to check if car is accelerating
braking = false;		// flag to check if car is braking
boosting = false;		// flag to check if car is boosting
turning = 0;			// flag to ceck if car is turning, 1 for left and 2 for right, 0 for neither

// surface check
on_road = false;

// visual
odometer_rpm = 0;
odometer_speed = 0;

// ai behavior
ai_behavior = {
	reversed_direction: false		// negative direction on road look up
}

// misc
last_road_index = 0; // last road index was checked for off road

image_speed = 0;

// functions
gear_shift_up = function() {
	//shift up
	gear = min(gear+1, array_length(gear_shift_rpm));
}

gear_shift_down = function() {
	//shift down
	gear = max(gear-1, 1);
}

gear_shift = function() {
	var gear_shift_rpm_upper = gear_shift_rpm[gear-1][1]
	var gear_shift_rpm_lower = gear_shift_rpm[gear-1][0];
		
	if (accelerating) {
		if (engine_rpm > gear_shift_rpm_upper) {
			gear_shift_up();
		}
	}
	if (!accelerating or braking) 
		if (engine_rpm < gear_shift_rpm_lower) {
			{gear_shift_down();
		}
	}
}

is_on_road = function(_x, _y, index) {
	var polygon_x = obj_road_generator.road_collision_points[index][0];
	var polygon_y = obj_road_generator.road_collision_points[index][1];
	
	return pnpoly(4, polygon_x, polygon_y, _x, _y);
}

set_on_road = function() {
	for (var p_i = 0; p_i < array_length(obj_road_generator.road_collision_points); p_i++) {
		var polygon = obj_road_generator.road_collision_points[p_i];
		if (!camera_in_view(polygon[0][0], polygon[1][0], 256)) {continue;}
		
		// on road collision
		on_road = is_on_road(x, y, p_i);
		if (on_road) {
			last_road_index = p_i;
			break;
		}
	}
}