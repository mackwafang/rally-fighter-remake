is_player = false;		// does car belong to player?
can_move = true;		// can car be affected by movement or collision?

engine_rpm_max = 10000;	// max rpm
engine_rpm = 0			// engine rpm
velocity = 0;			// car's speed
velocity_max = 18;		// car's max speed
wheel_radius = 0.34;		// wheel radius in m
mass = 1500;			// vehicle mass, in kg
horsepower = 200;		// horsepower
turn_rate = 1;			// car's turning rate
gear = 1;				// car's gear 
engine_power = 0.5;		// engine's power, 0 = off, 1 = full power
transfer_eff = 0.7;		//transfer efficiency
acceleration = 0;		// acceleration value

//gear's ratio
gear_ratio = [2.66, 2, 4/3, 1, 8/10, 1/2];
diff_ratio = 3.42;

accelerating = false;	// flag to check if car is accelerating
braking = false;		// flag to check if car is braking
boosting = false;		// flag to check if car is boosting
turning = 0;			// flag to ceck if car is turning, 1 for left and 2 for right, 0 for neither