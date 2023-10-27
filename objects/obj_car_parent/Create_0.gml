is_player = false;		// does car belong to player?
can_move = true;		// can car be affected by movement or collision?

engine_rpm_max = 10000;	// max rpm
engine_rpm = 0			// engine rpm
velocity = 0;			// car's speed
velocity_max = 18;		// car's max speed
wheel_radius = 0.34;		// wheel radius in m
mass = 1500;			// vehicle mass, in kg
horsepower = 200;		// horsepower
turn_rate = 0;			// car's turning rate
gear = 1;				// car's gear 
engine_power = 0.5;		// engine's power, 0 = off, 1 = full power
transfer_eff = 0.7;		//transfer efficiency
acceleration = 0;		// acceleration value

//gear's ratio
gear_ratio = [3, 2.5, 5/3, 4/3, 8/10, 1/2];
diff_ratio = 3.42;
gear_shift_rpm = [		// rpm needed for gear shift [lower_bound, upper_bound]
	[0, 7500],
	[1500, 9500],
	[1100, 8500],
	[1100, 8500],
	[1100, 8500],
	[1100, 11000],
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

gear_shift_up = function() {
	//shift up
	gear = min(gear+1, 6);
	engine_rpm = gear_shift_rpm[gear-1][0] * 1.01;
}

gear_shift_down = function() {
	//shift down
	gear = max(gear-1, 1);
	engine_rpm = gear_shift_rpm[gear-1][1] * 0.99;
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