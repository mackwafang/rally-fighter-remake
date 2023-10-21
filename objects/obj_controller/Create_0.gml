randomize();
//random_set_seed(0);

primary_count = 4 * 10;
road_segments = 20;
control_points = array_create(primary_count);

var t = current_time;
var next_dir = 0;
control_points[0] = new vec2();
for (var s = 1; s < primary_count; s++) {
	next_dir = irandom_range(-90, 90);
	control_points[s] = new vec2(
		control_points[s-1].x + (cos(degtorad(next_dir)) * 1024),
		control_points[s-1].y + (sin(degtorad(next_dir)) * 1024)
	);
}

show_debug_message(control_points);

road_list = generate_roads(control_points, 10);

//control_points = [];
//var prev_x, prev_y, prev_dir;
//prev_x = 0;
//prev_y = y + 256;
//prev_dir = 0;
//for (var i = 0; i < primary_count; i ++) {
//	control_points[array_length(control_points)] = new vec2(prev_x, prev_y);
//	prev_x += cos(degtorad(prev_dir)) * 1024;
//	prev_y += sin(degtorad(prev_dir)) * 1024;
//	prev_dir += irandom_range(-90,90);
//}

//road_list = [];
//for (var i = 0; i < road_segments; i++) {
//	var p = decasteljau(control_points, i/road_segments);
//	road_list[array_length(road_list)] = p;
//}


show_debug_message($"road generation completed in {current_time - t}ms");
//show_debug_message(road_list);
//show_debug_message(road_list);

cam_move_speed = 16;
cam_zoom = 1;