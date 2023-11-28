depth = -10;

is_player = false;		// does car belong to player?
can_move = true;		// can car be affected by movement or collision?

max_hp = 100;			// car max health
hp = max_hp;			// car health

engine_rpm_max = 10000;	// max rpm
engine_rpm = 1000;		// engine rpm
test_rpm = 0;
velocity = 0;			// car's speed
max_velocity = 1800;	// car's max speed
wheel_radius = 0.34;	// wheel radius in m
mass = 1500;			// vehicle mass, in kg
horsepower = 300;		// horsepower
turn_rate = 0;			// car's turning rate
gear = 1;				// car's gear 
max_gear = 6;
engine_power = 0;		// throttle position
transfer_eff = 0.8;		// transfer efficiency
acceleration = 0;		// acceleration value
braking_power = 50;		// braking magnetude
is_respawning = false;	// car is respawning
engine_sound_interval = 0;

car_id = -1;			// car id

inertia = mass * (wheel_radius * wheel_radius) / 2;		// constant value for car's inertia
c_drag = 0.5 * 0.3 * 2.2 * AIR_DENSITY;					// constant value for car's air drag
c_rr = 20 * c_drag;										// constant value for car's drag

//gear's ratio
gear_ratio = [3, 8/3, 2, 4.5/3, 10/8, 11/10];
diff_ratio = 6.5;
gear_shift_rpm = [
	[0, 7000],
	[4000, 7000],
	[4500, 7000],
	[4500, 6500],
	[4500, 6000],
	[3500, 5500],
];
gear_shift_wait = 0;		//  time wait to change gear again

accelerating = false;		// flag to check if car is accelerating
braking = false;			// flag to check if car is braking
boosting = false;			// flag to check if car is boosting
turning = 0;				// flag to ceck if car is turning, 1 for left and 2 for right, 0 for neither
push_vector = new Vec2()	// vector for collision 

// surface check
on_road = false;

// visual
odometer_rpm = 0;
odometer_speed = 0;

// ai behavior
ai_behavior = {
	desired_lane: 1,				// desired lane to move to
	reversed_direction: false,		// negative direction on road look up
	part_of_race: false,			// part of the ranking race
	change_lane: function(road_index) {
		self.desired_lane = 1+irandom(road_index.get_lanes_right()-1);
	},
}

// audio emitter for engine
engine_sound_emitter = audio_emitter_create();
audio_falloff_set_model(audio_falloff_exponent_distance);
audio_emitter_falloff(engine_sound_emitter, 128, 258, 1);

// misc
last_road_index = 0;							// last road index was checked for off road
nav_road_index = find_nearest_road(x, y);		// keep track of which road segment to travel to
image_speed = 0;
vehicle_type = 0;
vehicle_detail_index = 0;
vehicle_color = 0;
dist_along_road = 0;							// how far along the road it is
race_rank = 0;

// functions
gear_shift_up = function() {
	//shift up
	if (gear+1 < max_gear) {
		engine_power = 0;
		gear_shift_wait = 60;
	}
	gear = min(gear+1, min(max_gear, array_length(gear_shift_rpm)));
}

gear_shift_down = function() {
	//shift down
	if (gear-1 > 0) {
		gear_shift_wait = 60;
		engine_power = 0;
	}
	gear = max(gear-1, 1);
}

gear_shift = function() {
	var gear_shift_rpm_upper = gear_shift_rpm[gear-1][1]
	var gear_shift_rpm_lower = gear_shift_rpm[gear-1][0];
		
	if (gear_shift_wait == 0) {
		if (accelerating or (engine_rpm > 9000)) {
			if ((engine_rpm > gear_shift_rpm_upper)) {
				gear_shift_up();
			}
		}
		if (!accelerating or braking) {
			if ((engine_rpm < gear_shift_rpm_lower)) {
				gear_shift_down();
			}
		}
	}
}

is_on_road = function(_x, _y, index) {
	var polygon_x = obj_road_generator.road_collision_points[index][0];
	var polygon_y = obj_road_generator.road_collision_points[index][1];
	
	return pnpoly(4, polygon_x, polygon_y, _x, _y);
}

set_on_road = function() {
	var p_i = last_road_index;
	while(p_i++ < array_length(obj_road_generator.road_collision_points)-1) {
		var polygon = obj_road_generator.road_collision_points[max(0, p_i)];
		if (point_distance(x,y,polygon[0][0], polygon[1][0]) > 256) {continue;}
		// on road collision
		on_road = is_on_road(x, y, p_i);
		if (on_road) {
			last_road_index = p_i;
			break;
		}
	}
	return obj_road_generator.road_list[last_road_index];
}

on_respawn = function() {
	if (is_respawning) {
		x = on_road_index.x + lengthdir_x((on_road_index.get_lanes_right()) * on_road_index.lane_width, on_road_index.direction - 90);
		y = on_road_index.y + lengthdir_y((on_road_index.get_lanes_right()) * on_road_index.lane_width, on_road_index.direction - 90);
		image_alpha = 1;
		solid = true;
		mask_index = sprite_index;
		
		hp = max_hp;
		velocity = 0;
		gear = 1;
		rpm = 1000;
		can_move = true;
		engine_power = 0;
		push_vector.x = 0;
		push_vector.y = 0;
		is_respawning = false;
	}
}

on_death = function() {
	if (!is_respawning) {
		instance_create_layer(x, y, "Instances", obj_explosion);
		if (ai_behavior.part_of_race) {
			image_alpha = 0;
			is_respawning = true;
			can_move = false;
			alarm[2] = 120;
			solid = false;
			mask_index = spr_empty;
		}
		else {
			instance_destroy();
		}
	}
}


on_road_index = set_on_road();					// keep track of which road segment its on 

alarm[0] = 1;
alarm[1] = 600;