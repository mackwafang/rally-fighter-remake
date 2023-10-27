randomize();
//random_set_seed(0);

primary_count = 100;
road_segments = 4;
control_points = array_create(primary_count);
control_points_dist = 512;
lane_width = 32;

var t = current_time;
var next_dir = 0;
control_points[0] = new vec2(x,y);
for (var s = 1; s < primary_count; s++) {
	next_dir += choose(-1,0,1)*15;
	control_points[s] = new vec2(
		control_points[s-1].x + (cos(degtorad(next_dir)) * irandom_range(control_points_dist/4,control_points_dist)),
		control_points[s-1].y + (sin(degtorad(next_dir)) * irandom_range(control_points_dist/4,control_points_dist))
	);
}

road_list = generate_roads(control_points, road_segments);

// set up road node data
var lane_change_duration = 50; //how many nodes until change to new lane
var lane_change_to = 1; // change this side of road to this number of lanes
var lane_side_affected = ROAD_LANE_CHANGE_AFFECT.NONE; // which side of the road changes 
for (var i = 0; i < array_length(road_list)-1; i++) {
	var road = road_list[@i];
	var road_next = road_list[@i+1];
	road.direction = point_direction(road.x, road.y, road_next.x, road_next.y);
	
	// road changes lane count
	if (lane_change_duration < 0) {
		lane_side_affected = choose(ROAD_LANE_CHANGE_AFFECT.LEFT, ROAD_LANE_CHANGE_AFFECT.RIGHT, ROAD_LANE_CHANGE_AFFECT.BOTH);
		lane_change_duration = 20+irandom(50);
		lane_change_to = max(1, lane_change_to+irandom_range(-1,1));
	}
	else {
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
}

// precalc road polygons
road_points = []; // used to generate the roads
for (var i = 0; i < array_length(road_list) - 2; i++) {
	// for each road piece
	var road = road_list[@ i];
	var next_road = road_list[@ i + 1];
	//compile left lanes
	for (var l = 0; l < road.get_lanes_left(); l++) {
		var subimage = 0;
		if (l == 0) {subimage = 0;}
		else if (l == road.get_lanes_left()-1) {subimage = 2;}
		else {subimage = 1}
		
		road_points = array_concat(road_points, [
			[new vec2(road.x+lengthdir_x(lane_width*l, road.direction+90), road.y+lengthdir_y(lane_width*l, road.direction+90)), new vec2(0,0), subimage],
			[new vec2(road.x+lengthdir_x(lane_width*(l+1), road.direction+90), road.y+lengthdir_y(lane_width*(l+1), road.direction+90)), new vec2(0,1), subimage],
			[new vec2(next_road.x+lengthdir_x(lane_width*l, next_road.direction+90), next_road.y+lengthdir_y(lane_width*l, next_road.direction+90)), new vec2(1,0), subimage],
			[new vec2(next_road.x+lengthdir_x(lane_width*(l+1), next_road.direction+90), next_road.y+lengthdir_y(lane_width*(l+1), next_road.direction+90)), new vec2(1,1), subimage],
		]);
	}
	//compile right lanes
	for (var l = 0; l < road.get_lanes_right(); l++) {
		var subimage = 0;
		if (l == 0) {subimage = 0;}
		else if (l == road.get_lanes_right()-1) {subimage = 2;}
		else {subimage = 1}
		
		road_points = array_concat(road_points, [
			[new vec2(road.x+lengthdir_x(lane_width*l, road.direction-90), road.y+lengthdir_y(lane_width*l, road.direction-90)), new vec2(0,0), subimage],
			[new vec2(road.x+lengthdir_x(lane_width*(l+1), road.direction-90), road.y+lengthdir_y(lane_width*(l+1), road.direction-90)), new vec2(0,1), subimage],
			[new vec2(next_road.x+lengthdir_x(lane_width*min(l, next_road.get_lanes_right()), next_road.direction-90), next_road.y+lengthdir_y(lane_width*min(l, next_road.get_lanes_right()), next_road.direction-90)), new vec2(1,0), subimage],
			[new vec2(next_road.x+lengthdir_x(lane_width*min(l+1, next_road.get_lanes_right()), next_road.direction-90), next_road.y+lengthdir_y(lane_width*min(l+1, next_road.get_lanes_right()), next_road.direction-90)), new vec2(1,1), subimage],
		]);
	}
}

show_debug_message($"road generation completed in {current_time - t}ms");
