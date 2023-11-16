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
transfer_eff = 1;		// transfer efficiency
acceleration = 0;		// acceleration value
braking_power = 30;		// braking magnetude

car_id = -1;			// car id

inertia = mass * (wheel_radius * wheel_radius) / 2;		// constant value for car's inertia
c_drag = 0.5 * 0.3 * 2.2 * AIR_DENSITY;					// constant value for car's air drag
c_rr = 20 * c_drag;										// constant value for car's drag

//gear's ratio
gear_ratio = [4, 2.2, 5/3, 4/3, 9/10, 8/10];
diff_ratio = 3.5;
gear_shift_rpm = [
	[0, 7000],
	[3000, 6000],
	[3500, 5800],
	[4000, 5500],
	[3000, 4200],
	[3000, 3000],
];
gear_shift_wait = 0;		//  time wait to change gear again

accelerating = false;		// flag to check if car is accelerating
braking = false;			// flag to check if car is braking
boosting = false;			// flag to check if car is boosting
turning = 0;				// flag to ceck if car is turning, 1 for left and 2 for right, 0 for neither
push_vector = new vec2()	// vector for collision 

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
		self.desired_lane = 1 + irandom(road_index.get_lanes_right()-1);
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

// functions
gear_shift_up = function() {
	//shift up
	if (gear_shift_wait == 0) {
		gear = min(gear+1, array_length(gear_shift_rpm));
		gear_shift_wait = 15;
	}
}

gear_shift_down = function() {
	//shift down
	if (gear_shift_wait == 0) {
		gear = max(gear-1, 1);
		gear_shift_wait = 15;
	}
}

gear_shift = function() {
	var gear_shift_rpm_upper = gear_shift_rpm[gear-1][1]
	var gear_shift_rpm_lower = gear_shift_rpm[gear-1][0];
		
	if (accelerating) {
		if (engine_rpm > gear_shift_rpm_upper) {
			gear_shift_up();
		}
		if ((gear > 3) && (acceleration < 0)) {
			gear_shift_down();
		}
	}
	if (!accelerating or braking) {
		if ((engine_rpm < gear_shift_rpm_lower)) {
			gear_shift_down();
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


on_road_index = set_on_road();					// keep track of which road segment its on 

alarm[0] = 1;
alarm[1] = 600;