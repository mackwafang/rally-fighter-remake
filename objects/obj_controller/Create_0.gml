randomize();
n_road_segments = 30;
road_list = bezier_n(0, room_height / 2, n_road_segments, 10, 256);
//road_list = generate_road(0, room_height / 2, 4, 5);
//show_debug_message(road_list);

cam_move_speed = 16;