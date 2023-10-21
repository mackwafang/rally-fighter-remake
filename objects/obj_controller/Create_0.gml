randomize();
//random_set_seed(0);

primary_count = 20;
road_segments = 20;
control_points = array_create(primary_count);
control_points_dist = 2048;

var t = current_time;
var next_dir = 0;
control_points[0] = new vec2(x-256,y+256);
for (var s = 1; s < primary_count; s++) {
	next_dir = irandom_range(-45, 45);
	control_points[s] = new vec2(
		control_points[s-1].x + (cos(degtorad(next_dir)) * irandom_range(control_points_dist/4,control_points_dist)),
		control_points[s-1].y + (sin(degtorad(next_dir)) * irandom_range(control_points_dist/4,control_points_dist))
	);
}

show_debug_message(control_points);

road_list = generate_roads(control_points, road_segments);

// find direciton of next road to render width of road
for (var i = 0; i < array_length(road_list)-1; i++) {
	var road = road_list[@i];
	var road_next = road_list[@i+1];
	road.direction = point_direction(road.x, road.y, road_next.x, road_next.y);
}


show_debug_message($"road generation completed in {current_time - t}ms");
//show_debug_message(road_list);
//show_debug_message(road_list);

cam_move_speed = 16;
cam_zoom = 1;