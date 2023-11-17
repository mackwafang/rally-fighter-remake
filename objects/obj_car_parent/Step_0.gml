// road fidning
nav_road_index = find_nearest_road(x + lengthdir_x(32, image_angle), y + lengthdir_y(32, image_angle), , last_road_index);
var next_road = obj_road_generator.road_list[nav_road_index.get_id()+2];
var vec_to_road = point_to_line(
	new vec2(on_road_index.x, on_road_index.y),
	new vec2(next_road.x, next_road.y),
	new vec2(x, y)
);
dist_along_road = on_road_index.length_to_point + point_distance(on_road_index.x, on_road_index.y, vec_to_road.x, vec_to_road.y);
vec_to_road.x += lengthdir_x(((-ai_behavior.desired_lane + 0.5) * on_road_index.lane_width), on_road_index.direction+90);
vec_to_road.y += lengthdir_y(((-ai_behavior.desired_lane + 0.5) * on_road_index.lane_width), on_road_index.direction+90);

if (can_move) {
	// player moving
	if (is_player) {
		accelerating = keyboard_check(global.player_input.accelerate);
		braking = keyboard_check(global.player_input.brake);
		boosting = keyboard_check(global.player_input.boost);
	
		turning = (keyboard_check(global.player_input.turn.right) << 1) | (keyboard_check(global.player_input.turn.left));
	}
	else {
		accelerating = true;
	}

	if (accelerating) {
		if (is_player) {
			engine_power += 0.1;
		}
		else {
			#region Non-Player Car Movement
			var angle_diff = angle_difference(nav_road_index.direction, image_angle);
		
			assert(nav_road_index.get_id() != next_road.get_id());
			if (ai_behavior.desired_lane > next_road.get_lanes_right()) {
				// desired lane doesn't exists, pick a new one
				ai_behavior.change_lane(nav_road_index);
			}
		
			engine_power = nav_road_index.get_ideal_throttle() * 0.9;
			var side = -(angle_difference(image_angle, point_direction(x, y, vec_to_road.x, vec_to_road.y)));
		
			if (!on_road) {
				// off road, trying to get back on it
				// find the nearest road
				//var side = angle_difference(image_angle, point_direction(x,y,road.x,road.y));
				turn_rate += side / 800;
				engine_power = 1;
				gear_shift_down();
			}
			else {
				// car turning on curved road and moving to its desired lane
				var tr = (angle_diff / 75) + (side / 10000);
				turn_rate += clamp(tr, -2, 2);
				braking = (abs(tr) > 2) | ((nav_road_index.get_ideal_throttle() < 0.25) && (angle_diff > 15));
			}
		
			// checking other cars
			var look_ahead_threshold = 32;
			var car_look_ahead = collision_line(x, y, x+lengthdir_x(look_ahead_threshold, image_angle), y+lengthdir_y(look_ahead_threshold, image_angle), obj_car, false, true);
			var car_look_left = collision_line(x+lengthdir_x(4, image_angle+45), y+lengthdir_x(4, image_angle+45), x+lengthdir_x(look_ahead_threshold, image_angle+45), y+lengthdir_y(look_ahead_threshold, image_angle+45), obj_car, false, true);
			var car_look_right = collision_line(x+lengthdir_x(4, image_angle-45), y+lengthdir_x(4, image_angle-45), x+lengthdir_x(look_ahead_threshold, image_angle-45), y+lengthdir_y(look_ahead_threshold, image_angle-45), obj_car, false, true);
			var is_off_road_left = !is_on_road(x+lengthdir_x(look_ahead_threshold/4, image_angle+90), y+lengthdir_y(look_ahead_threshold/4, image_angle+90), last_road_index) ? 1 : 0;
			var is_off_road_right = !is_on_road(x+lengthdir_x(look_ahead_threshold/4, image_angle-90), y+lengthdir_y(look_ahead_threshold/4, image_angle-90), last_road_index) ? 1 : 0;
		
			if (instance_exists(car_look_ahead)) {car_look_ahead = !car_look_ahead.is_respawning;}
			if (instance_exists(car_look_left)) {car_look_left = !car_look_left.is_respawning;}
			if (instance_exists(car_look_right)) {car_look_right = !car_look_right.is_respawning;}
			
			if (!is_player) {
				turn_rate += -(is_off_road_left / 10) + (is_off_road_right / 10);
				if (car_look_ahead) {
					if (car_look_left) {turn_rate += 0.2;}
					else if (car_look_right) {turn_rate -= 0.2;}
					else {
						engine_power = 0;
					}
				}
			}
			#endregion
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
}

// surface friction	
// first, location of cached index
if (!is_on_road(x, y, last_road_index)) {
	// probably not on that segment anymore, recheck
	on_road_index = set_on_road();
}
// calculate engine stuff for acceleration
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
	
var drive_force = (drive_torque / wheel_radius) + f_drag + f_rr + f_brake + f_surface - push_vector.x;

push_vector.x = max(0, push_vector.x - abs(drive_force));
push_vector.y = max(0, push_vector.y * 0.96);

drive_torque = drive_force * wheel_radius;
acceleration = (drive_torque / inertia);
velocity += acceleration * (delta_time / 1000000);// * gear_ratio[gear-1];
velocity = clamp(velocity, 0, velocity_max);
	
// move car in direction
if (!is_respawning) {
	turn_rate += -turn_rate * 0.1;
	turn_rate = clamp(turn_rate, -2, 2);
	
	direction += turn_rate;
	x += cos(degtorad(direction)) * velocity / 100;
	y -= sin(degtorad(direction)) * velocity / 100;
	image_angle = direction;
}
	
gear_shift(); // auto gear shift
engine_rpm = clamp(engine_rpm, 1000, engine_rpm_max);
engine_power = clamp(engine_power, 0, 1);
	
var engine_sound_pitch = (engine_rpm / engine_rpm_max)+0.3;
if (is_player) {
	var engine_sound = audio_play_sound(snd_car, 10, false);
	audio_sound_pitch(engine_sound, engine_sound_pitch);
		
	audio_listener_position(x, y, 0);
}
else {
	audio_emitter_pitch(engine_sound_emitter, engine_sound_pitch);
	audio_play_sound_on(engine_sound_emitter, snd_car, false, 1);
	audio_emitter_position(engine_sound_emitter, x, y, 0);
}
	
gear_shift_wait = clamp(gear_shift_wait - 1, 0, 60);

// remove non-participating cars when too far away
if (abs(obj_controller.main_camera_target.dist_along_road - dist_along_road) > 1024) {
	if (!global.DEBUG_FREE_CAMERA) {
		if (!ai_behavior.part_of_race) {
			instance_destroy()
		}
	}
	// randomly destroy car to simulate crashes
	if (irandom(1000) == 0) {
		if (!is_player) {
			hp = 0;
		}
	}
}
//check alive
if (hp <= 0) {
	on_death();
}
	