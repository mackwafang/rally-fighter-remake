randomize();
//random_set_seed(0);

primary_count = 100;
road_segments = 10;
control_points = array_create(primary_count);
control_points_dist = 1024;

var t = current_time;
var next_dir = 0;
control_points[0] = new vec2(x-256,y+256);
for (var s = 1; s < primary_count; s++) {
	next_dir += irandom_range(-45, 45);
	control_points[s] = new vec2(
		control_points[s-1].x + (cos(degtorad(next_dir)) * irandom_range(control_points_dist/4,control_points_dist)),
		control_points[s-1].y + (sin(degtorad(next_dir)) * irandom_range(control_points_dist/4,control_points_dist))
	);
}

road_list = generate_roads(control_points, road_segments);

// find direciton of next road to render width of road
for (var i = 0; i < array_length(road_list)-1; i++) {
	var road = road_list[@i];
	var road_next = road_list[@i+1];
	road.direction = point_direction(road.x, road.y, road_next.x, road_next.y);
	if (i > 20) {
		road.lanes = [2, 0, 1];
	}
}

road_points = []; // used to generate the roads
for (var i = 0; i < array_length(road_list) - 2; i++) {
	var road = road_list[@ i];
	var next_road = road_list[@ i + 1];
	for (var l = 0; l < road.get_left_lanes(); l++) {
		road_points = array_concat(road_points, [
			[new vec2(road.x+lengthdir_x(64*l, road.direction+90), road.y+lengthdir_y(64*l, road.direction+90)), new vec2(0,0)],
			[new vec2(road.x+lengthdir_x(64*(l+1), road.direction+90), road.y+lengthdir_y(64*(l+1), road.direction+90)), new vec2(0,1)],
			[new vec2(next_road.x+lengthdir_x(64*min(l, next_road.get_left_lanes()), next_road.direction+90), next_road.y+lengthdir_y(64*min(l, next_road.get_left_lanes()), next_road.direction+90)), new vec2(1,0)],
			[new vec2(next_road.x+lengthdir_x(64*min(l+1, next_road.get_left_lanes()), next_road.direction+90), next_road.y+lengthdir_y(64*min(l+1, next_road.get_left_lanes()), next_road.direction+90)), new vec2(1,1)],
		]);
	}
	// add break point for defining median
	road_points = array_concat(road_points, array_create(2, undefined));
	
	for (var l = 0; l < road.get_right_lanes(); l++) {
		road_points = array_concat(road_points, [
			[new vec2(road.x+lengthdir_x(64*l, road.direction-90), road.y+lengthdir_y(64*l, road.direction-90)), new vec2(0,0)],
			[new vec2(road.x+lengthdir_x(64*(l+1), road.direction-90), road.y+lengthdir_y(64*(l+1), road.direction-90)), new vec2(0,1)],
			[new vec2(next_road.x+lengthdir_x(64*min(l, next_road.get_right_lanes()), next_road.direction-90), next_road.y+lengthdir_y(64*min(l, next_road.get_right_lanes()), next_road.direction-90)), new vec2(1,0)],
			[new vec2(next_road.x+lengthdir_x(64*min(l+1, next_road.get_right_lanes()), next_road.direction-90), next_road.y+lengthdir_y(64*min(l+1, next_road.get_right_lanes()), next_road.direction-90)), new vec2(1,1)],
		]);
	}
}

show_debug_message($"road generation completed in {current_time - t}ms");
//show_debug_message(road_list);
//show_debug_message(road_list);

cam_move_speed = 16;
cam_zoom = 1;