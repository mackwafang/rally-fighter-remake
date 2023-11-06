randomize();
//random_set_seed(0);
depth = 1000;

primary_count = 100;
road_segments = 10;
control_points = array_create(primary_count);
control_points_dist = 2048;
lane_width = 32;

var t = current_time;

// initialize control points
var next_dir = 0;
control_points[0] = new vec2(x,y);
for (var s = 1; s < primary_count; s++) {
	next_dir += irandom_range(-1,1)*30;
	control_points[s] = new vec2(
		control_points[s-1].x + (cos(degtorad(next_dir)) * irandom_range(control_points_dist/4, control_points_dist)),
		control_points[s-1].y + (sin(degtorad(next_dir)) * irandom_range(control_points_dist/4, control_points_dist))
	);
}

road_list = generate_roads(control_points, road_segments);

// set up road node data
var lane_change_duration = 50; //how many nodes until change to new lane
var lane_change_to = 2; // change this side of road to this number of lanes
var lane_side_affected = ROAD_LANE_CHANGE_AFFECT.BOTH; // which side of the road changes 
for (var i = 0; i < array_length(road_list)-1; i++) {
	var road = road_list[@i];
	var road_next = road_list[@i+1];
	road.direction = point_direction(road.x, road.y, road_next.x, road_next.y);
	road.length = point_distance(road.x, road.y, road_next.x, road_next.y);
	road.ideal_throttle = road.length / ((control_points_dist / road_segments) * 0.8);
	road._id = i;
	
	// road changes lane count
	if (lane_change_duration == 0) {
		lane_side_affected = choose(ROAD_LANE_CHANGE_AFFECT.LEFT, ROAD_LANE_CHANGE_AFFECT.RIGHT, ROAD_LANE_CHANGE_AFFECT.BOTH);
		lane_change_duration = 10+irandom(20);
		lane_change_to = max(1, 6);
	}
	switch(lane_side_affected) {
		case ROAD_LANE_CHANGE_AFFECT.LEFT:
			road.set_lanes_left(lane_side_affected);
			break;
		case ROAD_LANE_CHANGE_AFFECT.RIGHT:
			road.set_lanes_right(lane_side_affected);
			break;
		case ROAD_LANE_CHANGE_AFFECT.BOTH:
			road.set_lanes_side(lane_side_affected);
			break;
	}
	lane_change_duration--;
}

road_points = []; // precalculate road polygons
road_collision_points = []; // calcuate road segments for colision checking
for (var i = 0; i < array_length(road_list) - 1; i++) {
	// for each road piece
	var road = road_list[@ i];
	var next_road = road_list[@ i + 1];
	
	var lane_function = [road.get_lanes_left, road.get_lanes_right];
	var next_lane_function = [next_road.get_lanes_left, next_road.get_lanes_right];
	for (var f = 0; f < 2; f++) {
		var road_lane = lane_function[f]();
		var next_road_lane = next_lane_function[f]();
		var lane_transitioning = next_road_lane > road_lane;
		var render_direction_flip = (f == 1) ? -1 : 1;
		//compile left lanes
		for (var l = 0; l < road_lane+(lane_transitioning ? 1 : 0); l++) {
			var subimage = 3;
			if (l == 0) {
				if (road_lane > 1) {subimage = 0;} // used for lane closes to median
				else if (lane_transitioning) {subimage = 0;} // used for lane closes to median
				else {subimage = 1;}
			}
			else if (l == road_lane) {subimage = 2;} // used for lane transition
			else if (l == road_lane-1) {
				if (lane_transitioning) {subimage = 3;}
				else {subimage = 4;}
			} // used for edge
		
			var next_l = next_road_lane;
			var render_direction = road.direction + (90 * render_direction_flip);
			var next_render_direction = next_road.direction + (90 * render_direction_flip);
		
			var p = [
				[new vec2(road.x+lengthdir_x(lane_width*l, render_direction), road.y+lengthdir_y(lane_width*l, render_direction)), new vec2(0,0), subimage],
				[new vec2(road.x+lengthdir_x(lane_width*(l+1), render_direction), road.y+lengthdir_y(lane_width*(l+1), render_direction)), new vec2(0,1), subimage],
				[new vec2(next_road.x+lengthdir_x(lane_width*(l), next_render_direction), next_road.y+lengthdir_y(lane_width*(l), next_render_direction)), new vec2(1,0), subimage],
				[new vec2(next_road.x+lengthdir_x(lane_width*(l+1), next_render_direction), next_road.y+lengthdir_y(lane_width*(l+1), next_render_direction)), new vec2(1,1), subimage],
			];
		
			if (road_lane != next_road_lane) {
				if (road_lane > next_road_lane) {
					if (l > next_road_lane-1) {
						p[2] = [new vec2(next_road.x+lengthdir_x(lane_width*next_road_lane, next_render_direction), next_road.y+lengthdir_y(lane_width*next_road_lane, next_render_direction)), new vec2(1,0), subimage]
						p[3] = [new vec2(next_road.x+lengthdir_x(lane_width*next_road_lane, next_render_direction), next_road.y+lengthdir_y(lane_width*next_road_lane, next_render_direction)), new vec2(1,1), subimage]
					}
				}
				if (road_lane < next_road_lane) {
					if (l == road_lane) {
						p[1] = [new vec2(road.x+lengthdir_x(lane_width*road_lane, render_direction), road.y+lengthdir_y(lane_width*road_lane, render_direction)), new vec2(0,1), subimage];
						p[2] = [new vec2(next_road.x+lengthdir_x(lane_width*road_lane, next_render_direction), next_road.y+lengthdir_y(lane_width*road_lane, next_render_direction)), new vec2(1,0), subimage];
						p[3] = [new vec2(next_road.x+lengthdir_x(lane_width*next_road_lane, next_render_direction), next_road.y+lengthdir_y(lane_width*next_road_lane, next_render_direction)), new vec2(1,1), subimage];
					}
				}
			}
		
			road_points = array_concat(road_points, p);
		}
	}
	
	//compile left lanes
	var left_lanes = road.get_lanes_left();
	var right_lanes = road.get_lanes_right();
	var next_left_lanes = next_road.get_lanes_left();
	var next_right_lanes = next_road.get_lanes_right();
	var collision_points = [
		 [
			road.x+lengthdir_x(lane_width*left_lanes, road.direction+90),
			next_road.x+lengthdir_x(lane_width*next_left_lanes, next_road.direction+90),
			next_road.x+lengthdir_x(lane_width*next_right_lanes, next_road.direction-90),
			road.x+lengthdir_x(lane_width*right_lanes, road.direction-90),
		],
		[
			road.y+lengthdir_y(lane_width*left_lanes, road.direction+90),
			next_road.y+lengthdir_y(lane_width*next_left_lanes, next_road.direction+90),
			next_road.y+lengthdir_y(lane_width*next_right_lanes, next_road.direction-90),
			road.y+lengthdir_y(lane_width*right_lanes, road.direction-90),
		]
	];
	
	road_collision_points[array_length(road_collision_points)] = collision_points;
}

obj_controller.x = road_list[0].x;
obj_controller.y = road_list[0].y;

show_debug_message($"road generation completed in {current_time - t}ms");
show_debug_message($"Road has {array_length(road_points)} points");
