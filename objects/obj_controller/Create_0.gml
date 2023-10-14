randomize();

n_road_segments = 20;
road_steps = 10;
//road_list = bezier_n(room_width / 2, room_height / 2, n_road_segments, road_steps, 2024);

control_points = [
	new vec2(0, room_height/2),
	new vec2(64, room_height/2),
	new vec2(128, room_height/2 + 64),
	new vec2(192, room_height/2 + 64),
];
road_list = [];
for (var i = 0; i < 20; i++) {
	var p = decasteljau(control_points, i/20);
	road_list[array_length(road_list)] = p;
}

show_debug_message(road_list);
//show_debug_message(road_list);

cam_move_speed = 16;
cam_zoom = 1;