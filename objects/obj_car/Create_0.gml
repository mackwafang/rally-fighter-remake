is_player = false;		// does car belong to player?
can_move = true;		// can car be affected by movement or collision?

velocity = 0;			// car's speed
velocity_max = 10;		// car's max speed
turn_rate = 1;			// car's turning rate

accelerating = false;	// flag to check if car is accelerating
braking = false;		// flag to check if car is braking
boosting = false;		// flag to check if car is boosting
turning = 0;			// flag to ceck if car is turning, 1 for left and 2 for right, 0 for neither