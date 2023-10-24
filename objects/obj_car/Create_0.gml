is_player = false;		// does car belong to player?
can_move = true;		// can car be affected by movement or collision?

rpm_max = 10000;		// max rpm
rpm = 0					// rpm for calculating speed
velocity = 0;			// car's speed
velocity_max = 18;		// car's max speed
turn_rate = 1;			// car's turning rate
tire_d = 0.60;			// car's tire diameter, in m
gear = 1;				// car's gear 
engine_power = 0.5		// engine's power, 0 = off, 1 = full power

//gear's ratio
gear_ratio = [3, 2, 4/3, 1, 8/10, 1/2];

accelerating = false;	// flag to check if car is accelerating
braking = false;		// flag to check if car is braking
boosting = false;		// flag to check if car is boosting
turning = 0;			// flag to ceck if car is turning, 1 for left and 2 for right, 0 for neither