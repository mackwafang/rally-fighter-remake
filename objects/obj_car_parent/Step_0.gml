// road fidning
nav_road = find_nearest_road(x + lengthdir_x(128, image_angle), y + lengthdir_y(128, image_angle), last_road_index);
var next_road = obj_road_generator.road_list[nav_road.get_id()+4];
var vec_to_road = point_to_line(
	new Point(nav_road.x, nav_road.y),
	new Point(next_road.x, next_road.y),
	new Point(x, y)
);
dist_along_road = on_road_index.length_to_point + point_distance(on_road_index.x, on_road_index.y, vec_to_road.x, vec_to_road.y);
vec_to_road.x += lengthdir_x(((ai_behavior.desired_lane + 0.5) * on_road_index.lane_width), on_road_index.direction-90);
vec_to_road.y += lengthdir_y(((ai_behavior.desired_lane + 0.5) * on_road_index.lane_width), on_road_index.direction-90);
var dist_to_road = point_distance(x,y,vec_to_road.x,vec_to_road.y);
//if (dist_to_road > 1024) {
//	hp = 0;
//}

if (can_move) {
	// player moving
	if (is_player) {
		accelerating = keyboard_check(global.player_input.accelerate);
		braking = keyboard_check(global.player_input.brake);
		boosting = keyboard_check_pressed(global.player_input.boost);
	
		turning = (keyboard_check(global.player_input.turn.right) << 1) | (keyboard_check(global.player_input.turn.left));
	}
	else {
		accelerating = true;
	}

	if (accelerating) {
		var angle_diff = angle_difference(on_road_index.direction, image_angle);
		if (is_player) {
			engine_power += 0.1;
			if (global.GAMEPLAY_TURN_GUIDE) {
				turn_rate += (angle_diff / 360); // moving along curved road
			}
		}
		else {
			#region Non-Player Car Movement
			if (ai_behavior.desired_lane > next_road.get_lanes_right()-1) {
				// desired lane doesn't exists, pick a new one
				ai_behavior.change_lane(nav_road);
			}
		
			engine_power = nav_road.get_ideal_throttle();
			var side = -(angle_difference(image_angle, point_direction(x, y, vec_to_road.x, vec_to_road.y)));
			var turn_adjustments = (ai_behavior.part_of_race) ? 1 : 2;
			// checking other cars
			var look_ahead_threshold = max(32, velocity / 20);
			var look_ahead_angle = 20;
			var car_look_ahead = instance_exists(collision_line(x, y, x+lengthdir_x(look_ahead_threshold, image_angle), y+lengthdir_y(look_ahead_threshold, image_angle), obj_car_parent, false, true));
			var car_look_left = instance_exists(collision_line(x+lengthdir_x(8, image_angle+look_ahead_angle), y+lengthdir_y(8, image_angle+look_ahead_angle), x+lengthdir_x(look_ahead_threshold, image_angle+look_ahead_angle), y+lengthdir_y(look_ahead_threshold, image_angle+look_ahead_angle), obj_car_parent, false, true));
			var car_look_right = instance_exists(collision_line(x+lengthdir_x(8, image_angle-look_ahead_angle), y+lengthdir_y(8, image_angle-look_ahead_angle), x+lengthdir_x(look_ahead_threshold, image_angle-look_ahead_angle), y+lengthdir_y(look_ahead_threshold, image_angle-look_ahead_angle), obj_car_parent, false, true));
			var is_off_road_left = !is_on_road(x+lengthdir_x(look_ahead_threshold/4, image_angle+90), y+lengthdir_y(look_ahead_threshold/4, image_angle+90), last_road_index) ? 1 : 0;
			var is_off_road_right = !is_on_road(x+lengthdir_x(look_ahead_threshold/4, image_angle-90), y+lengthdir_y(look_ahead_threshold/4, image_angle-90), last_road_index) ? 1 : 0;
			
			var evade_turn_rate = 0.2;
			if (car_look_left) {turn_rate -= evade_turn_rate;}
			if (car_look_right) {turn_rate += evade_turn_rate;}
			if (car_look_ahead) {
				accelerating = false;
				braking = true;
				if (!car_look_left) {turn_rate += evade_turn_rate;}
				else if (!car_look_right) {turn_rate -= evade_turn_rate;}
			}
			if (!is_off_road_left | !is_off_road_right) {
				turn_rate += -(is_off_road_left / 10) + (is_off_road_right / 10);
			}
		
			if (!on_road) {
				// off road, trying to get back on it
				// find the nearest road
				//var side = angle_difference(image_angle, point_direction(x,y,road.x,road.y));
				turn_rate += side / 800;
			}
			else {
				// car turning on curved road and moving to its desired lane
				var tr = (angle_diff / 60) * turn_adjustments; // moving along curved road
				
				// moving go desired lane
				if (dist_to_road > 16) {
					tr += (sign(side) / 20);
				}
				turn_rate += clamp(tr, -2, 2);
				braking = (abs(tr) > 1) | ((nav_road.get_ideal_throttle() < 0.25) && (abs(angle_diff) > 15));
			}
			
			// enables boost
			if (boost_juice >= 100) {
				if (irandom(20) < global.difficulty) {
					boosting = true;
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
			turn_rate -= 10 * global.deltatime;
		}
		else if (turning & 2 == 0) {
			// checking right turn
			turn_rate += 10 * global.deltatime;
		}
	}

	if (keyboard_check_pressed(vk_up)) {gear_shift_up();}
	if (keyboard_check_pressed(vk_down)) {gear_shift_down();}
}

// surface friction	
// first, location of cached index
on_road_index = set_on_road();

// finish
is_completed = dist_along_road >= global.race_length;
if (ai_behavior.part_of_race || is_player) {
	if (is_completed) {
		braking = true;
		accelerating = false;
		boosting = false;
		boost_active = false;
		engine_power = 0;
	}
}

// calculate engine stuff for acceleration
var engine_to_wheel_ratio = gear_ratio[gear-1] * diff_ratio;
var engine_torque_max = (horsepower / engine_rpm * 5252) * 20;//torque_lookup(engine_rpm)
var engine_torque = engine_torque_max * (boost_active ? 2 : engine_power);
var drive_torque = engine_torque * engine_to_wheel_ratio * transfer_eff;
	
var f_drag = -c_drag * velocity;
var f_rr = -c_rr * velocity;
var f_surface = -mass * global.gravity_3d * ((on_road) ? 0.2 : 20);
var f_brake = (braking) ? -braking_power * 1000 : 0;
var f_turn = -abs(turn_rate) * mass / 2;
if (velocity <= 0) {
	f_brake = 0;
	f_surface = 0;
}
var f_incline = arcsin(on_road_index.elevation / on_road_index.length) * mass * global.gravity_3d;
	
drive_force = (drive_torque / wheel_radius) + f_drag + f_rr + f_brake + f_surface + f_turn + f_incline - push_vector.x;

push_vector.x = max(0, push_vector.x - abs(drive_force));
push_vector.y = max(0, push_vector.y * 0.95);

drive_torque = drive_force * wheel_radius;
acceleration = (drive_torque / inertia);

var wheel_rotation_rate = velocity * 100 / 3600 / wheel_radius;
engine_rpm = (wheel_rotation_rate * engine_to_wheel_ratio * 60 / (2 * pi));

velocity = clamp(velocity, 0, max_velocity);

gear_shift(); // auto gear shift
engine_rpm = clamp(engine_rpm, 1000, engine_rpm_max);
engine_power = clamp(engine_power, 0, 1);
gear_shift_wait = clamp(gear_shift_wait-1, 0, 60);
	
if (hp > 0) {
	var engine_sound_pitch = ((engine_rpm / engine_rpm_max)+1.0);// - (gear / 12);
	if (obj_controller.main_camera_target.id == id) {
		audio_listener_position(x, y, z);
	}
	if (engine_sound_interval == 0) {
		audio_play_sound_on(engine_sound_emitter, (boost_active ? snd_boost : snd_car), false, 1);
	}
	audio_emitter_pitch(engine_sound_emitter, engine_sound_pitch);
	audio_emitter_position(engine_sound_emitter, x, y, z);
	engine_sound_interval = (engine_sound_interval + 1) % (engine_rpm < 2000 ? 16 : 8);
}


// remove non-participating cars when too far away
if (abs(obj_controller.main_camera_target.dist_along_road - dist_along_road) > 6000) {
	if (!global.DEBUG_FREE_CAMERA) {
		if (!ai_behavior.part_of_race) {
			instance_destroy()
		}
	}
	// randomly destroy car to simulate crashes
	if (irandom(30000) < ((global.total_participating_vehicles - race_rank + 1))) {
		if (!is_player) {
			hp = 0;
		}
	}
}

// boost
if (!boost_active) {
	if (boosting) {
		boost_active = true;
	}
	
	if (boost_juice < 100 && global.race_started) {
		boost_juice += (0.05 * global.difficulty) * (1 - (boost_juice_penalty / 100)) * global.deltatime * 100;
	}
}
else {
	if (boost_juice > 0) {
		boost_juice -= 0.25 * global.deltatime * 100;
	}
	else {
		boost_active = false;
		boost_juice_penalty = clamp(boost_juice_penalty + 10, 0, 90);
		if (!is_player) {
			boosting = false;
		}
	}
}

//check alive
if (hp <= 0) {
	on_death();
}
else {
	// health regen
	hp_regen_delay += global.deltatime;
	if (hp_regen_delay >= 0) {
		hp = clamp(hp+(3 / global.difficulty), 0, max_hp);
		hp_regen_delay = -1;
	}
}
	