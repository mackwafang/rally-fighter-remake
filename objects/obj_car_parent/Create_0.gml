depth = -10;
z = 0;
zlerp = 0;

is_player = false;		// does car belong to player?
can_move = true;		// can car be affected by movement or collision?

max_hp = 100;			// car max health
hp = max_hp;			// car health
hp_display = 1;			// smooth hp thingy
hp_regen_delay = 0;		// delay for health regen

engine_rpm_max = 10000;	// max rpm
engine_rpm = 1000;		// engine rpm
test_rpm = 0;
velocity = 0;			// car's speed
max_velocity = 3000;	// car's max speed
wheel_radius = 0.34;	// wheel radius in m
mass = 300;				// vehicle mass, in kg
horsepower = 300;		// horsepower
turn_rate = 0;			// car's turning rate
gear = 1;				// car's gear 
max_gear = 6;
engine_power = 0;		// throttle position
transfer_eff = 0.8;		// transfer efficiency
acceleration = 0;		// acceleration value
braking_power = 25;		// braking magnetude
zspeed = 0;				// vertical 
boost_juice = 0;		// boosting meter
boost_usable = false;	// is boost usable
boost_active = false;	// if boost is using
boost_juice_penalty = 0;// penalty for using boost

is_completed = false;	// did vehicle completed race

air_drag_coef = 0.3;	// air drag coefficient
drag_area = 1.2;		// cross sectional area

is_respawning = false;	// car is respawning
engine_sound_interval = 0;

car_id = -1;			// car id

inertia = mass * (wheel_radius * wheel_radius) / 2;		// constant value for car's inertia
c_drag = 0.5 * air_drag_coef * drag_area * AIR_DENSITY;	// constant value for car's air drag
c_rr = 20 * c_drag;										// constant value for car's drag

//gear's ratio
// gear_ratio = [3, 2.5, 2, 5/3, 10/7, 11/9];
gear_ratio = [3, 2.25, 1.8, 5/3, 10/7, 11/9];
gear_shift_rpm = [
	[0, 4500],
	[2000, 4250],
	[2750, 4000],
	[2750, 4000],
	[2750, 4000],
	[2750, 2750],
];
for (var g = 0; g < array_length(gear_shift_rpm); g++) {
	gear_shift_rpm[g][0] *= global.difficulty;
	gear_shift_rpm[g][1] *= global.difficulty;
}
//gear_shift_rpm = [
//	[0, 9000],
//	[4000, 8500],
//	[5500, 8000],
//	[5500, 8000],
//	[5500, 8000],
//	[5500, 5500],
//];
//gear_ratio = [2.66, 1.78, 1.3, 1, 0.74, 0.5];
//gear_shift_rpm = [
//	[0, 8000],
//	[4000, 8500],
//	[4500, 7000],
//	[4500, 5500],
//	[4500, 5000],
//	[3500, 5500],
//];

diff_ratio = 3.5;
gear_shift_wait = 0;		//  time wait to change gear again

accelerating = false;		// flag to check if car is accelerating
braking = false;			// flag to check if car is braking
boosting = false;			// flag to check if car is boosting
turning = 0;				// flag to ceck if car is turning, 1 for left and 2 for right, 0 for neither
push_vector = new Vec2()	// vector for collision 
drive_force = 0;			// the force generated by the engine

// surface check
on_road = false				// check if on road horizontally
vertical_on_road = true;	// check if on road vertically
on_road_index = 0;
nearest_road = undefined;

// visual
odometer_rpm = 0;
odometer_speed = 0;

// ai behavior
ai_behavior = {
	desired_lane: 1,				// desired lane to move to
	reversed_direction: false,		// negative direction on road look up
	part_of_race: false,			// part of the ranking race
	change_lane: function(road_index) {
		/// @function	change_lane(road);
		self.desired_lane = (self.reversed_direction ? -irandom(road_index.get_lanes_left()-1): irandom(road_index.get_lanes_right()-1));
	},
}
race_rank = 0;
completed_race_rank = 0;
// audio emitter for engine
engine_sound_emitter = audio_emitter_create();
audio_falloff_set_model(audio_falloff_exponent_distance);
audio_emitter_falloff(engine_sound_emitter, 64, 128, 1);

// misc
last_road_index = 0;					// last road index was checked for off road
nav_road = find_nearest_road(x, y, 0);	// keep track of which road segment to travel to
image_speed = 0;
vehicle_type = 0;
vehicle_detail_index = 0;
vehicle_detail_subimage = 0;
vehicle_color = {
	primary: 0,
	secondary: 0,
	tetriary: 0,
};
racer_color_replace_dst = [];
dist_along_road = 0;							// how far along the road it is

counter = 0;						// counter for various things

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
		
	//if (gear_shift_wait == 0) {
		if (accelerating or (engine_rpm > 9000)) {
			if ((engine_rpm > gear_shift_rpm_upper)) {
				gear_shift_up();
			}
		}
		if (!accelerating or braking or !on_road) {
			if ((engine_rpm < gear_shift_rpm_lower)) {
				gear_shift_down();
			}
		}
	//}
}

is_on_road = function(_x, _y, road_id) {
	/// @function			is_on_road(x, y, index)
	var proj = point_to_line(
		new Point(on_road_index.x, on_road_index.y),
		new Point(on_road_index.next_road.x, on_road_index.next_road.y),
		new Point(x, y)
	);
	var side = sign(dcos(point_direction(x, y, proj.x, proj.y) - on_road_index.direction + 90)); // sign to make sure that value is -1 or 1
	var dist = point_distance(x, y, proj.x, proj.y);
	var side_check = false;
	if (side == -1) {
		// right
		side_check = (dist < (on_road_index.get_lanes_right()+1) * on_road_index.lane_width)
	}
	if (side == 1) {
		// left
		side_check = (dist < (on_road_index.get_lanes_left()+1) * on_road_index.lane_width)
	}
	
	return side_check;
}

set_on_road = function() {
	nearest_road = find_nearest_road(x, y, last_road_index);
	
	last_road_index = nearest_road._id;
	var polygon_x = obj_road_generator.road_list[last_road_index].get_collision_x();
	var polygon_y = obj_road_generator.road_list[last_road_index].get_collision_y();
	var on_segment = pnpoly(4, polygon_x, polygon_y, x, y);
	on_road = is_on_road(x,y,last_road_index);
	if (!on_segment) {
		if (last_road_index-1 > 0) {
			last_road_index -= 1;
			on_road = is_on_road(x,y,last_road_index);
			return obj_road_generator.road_list[last_road_index];
		}
	}
	
	//var p_i = last_road_index-1;
	//while(p_i++ < last_road_index + 100) {//global.road_list_length-1) {
	//	var road = obj_road_generator.road_list[p_i];
	//	var polygon = road.get_collision_points();
	//	if (point_distance(x,y,road.x,road.y) > road.get_lanes() * road.lane_width) {continue;}
	//	// on road collision
	//	on_road = is_on_road(x, y, p_i);
	//	if (on_road) {
	//		last_road_index = p_i;
	//		break;
	//	}
	//}
	return obj_road_generator.road_list[last_road_index];
}

on_respawn = function() {
	if (is_respawning) {
		func = choose(-on_road_index.get_lanes_left(), on_road_index.get_lanes_right());
		x = on_road_index.x + lengthdir_x(func * on_road_index.lane_width, on_road_index.direction - 90);
		y = on_road_index.y + lengthdir_y(func * on_road_index.lane_width, on_road_index.direction - 90);
		image_alpha = 1;
		//solid = true;
		mask_index = sprite_index;
		gear = 1;
		
		hp = max_hp;
		can_move = true;
		push_vector.x = 0;
		push_vector.y = 0;
		is_respawning = false;
		z = on_road_index.z;
	}
}

on_death = function() {
	if (!is_respawning) {
		instance_create_layer(x, y, "Instances", obj_explosion);
		if (ai_behavior.part_of_race) {
			image_alpha = 0;
			is_respawning = true;
			can_move = false;
			//solid = false;
			mask_index = spr_empty;
			direction = on_road_index.direction;
		}
		else {
			instance_destroy();
		}
		//velocity = 0;
		//gear = 1;
		//rpm = 1000;
		turn_rate = 0;
		boost_active = false;
		engine_power = 0;
	}
}

alarm[0] = 1;
alarm[1] = 1200;