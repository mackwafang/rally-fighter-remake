randomize();

n_road_segments = 20;
road_steps = 10;
road_list = bezier_n(room_width / 2, room_height / 2, n_road_segments, road_steps, 2024);
//road_list = generate_road(0, room_height / 2, 4, 5);
//show_debug_message(road_list);

cam_move_speed = 16;
cam_zoom = 1;