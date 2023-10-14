randomize();
//random_set_seed(0);

primary_count = 20;
road_segments = primary_count * 10;

var t = current_time;
road_list = bezier_n(0, y+256, primary_count, 10, 1024);

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