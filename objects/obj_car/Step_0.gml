
// player moving
if (is_player) {
	accelerating = keyboard_check(global.player_input.accelerate);
	braking = keyboard_check(global.player_input.brake);
	boosting = keyboard_check(global.player_input.boost);
	
	turning = (keyboard_check(global.player_input.turn.right) << 1) | (keyboard_check(global.player_input.turn.left));
}

if (accelerating) {
	velocity += 0.1;
}

if (braking) {
	velocity *= 0.6;
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
	//slowly loosing velocity
	if (!accelerating) {velocity *= 0.95;}
	
	velocity = clamp(velocity, 0, velocity_max);
	
	// move car in direction
	x += cos(degtorad(direction)) * velocity;
	y += sin(degtorad(direction)) * velocity;
	image_angle = -direction;
}