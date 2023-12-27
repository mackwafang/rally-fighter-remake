// debuging camera
//if (keyboard_check(ord("W"))) {y -= cam_move_speed;}
//if (keyboard_check(ord("S"))) {y += cam_move_speed;}
//if (keyboard_check(ord("A"))) {x -= cam_move_speed;}
//if (keyboard_check(ord("D"))) {x += cam_move_speed;}
//if (keyboard_check(vk_space)) {z += 1;}
//if (keyboard_check(vk_control)) {z -= 1;}
//if (keyboard_check(ord("Q"))) {
//	if (global.DEBUG_FREE_CAMERA) {
//		cam_angle -= 5;
//	}
//}
//if (keyboard_check_pressed(ord("Q"))) {
//	if (!global.DEBUG_FREE_CAMERA) {
//		participating_camera_index = (participating_camera_index + 1) % array_length(participating_vehicles);
//	}
//}
//if (keyboard_check(ord("E"))) {
//	if (global.DEBUG_FREE_CAMERA) {
//		cam_angle += 5;
//	}
//}if (keyboard_check_pressed(ord("E"))) {
//	if (!global.DEBUG_FREE_CAMERA) {
//		participating_camera_index = (participating_camera_index - 1 < 0) ? array_length(participating_vehicles)-1 : participating_camera_index - 1;
//	}
//}
//if (mouse_wheel_up()) {cam_zoom += 2;}
//if (mouse_wheel_down()) {cam_zoom -= 2;}

// play music
if (alarm[0] == global.display_freq * 3) {
	audio_play_sound(snd_race_1, 128, true);
}

// other controls
if (keyboard_check(vk_escape)) {
	global.game_state_paused = !global.game_state_paused;
}

main_camera_target = participating_vehicles[participating_camera_index];


if (!global.DEBUG_FREE_CAMERA) {
	// normal game camera
	if (!global.CAMERA_MODE_3D) {
		camera_set_view_pos(
			main_camera,
			main_camera_target.x - (main_camera_size.width/2) + lengthdir_x(main_camera_size.width * 0.45, main_camera_target.image_angle),
			main_camera_target.y - (main_camera_size.height/2) + lengthdir_y(main_camera_size.width * 0.45, main_camera_target.image_angle)
		);
		camera_set_view_angle(main_camera, -main_camera_target.image_angle+90);
	}
	else {
		gpu_set_zwriteenable(false);
		global.view_matrix = matrix_build_lookat(
			main_camera_target.x+lengthdir_x(-30+cam_zoom, main_camera_target.image_angle), 
			main_camera_target.y+lengthdir_y(-30+cam_zoom, main_camera_target.image_angle), 
			main_camera_target.z + z, 
			main_camera_target.x+lengthdir_x(500, main_camera_target.image_angle),
			main_camera_target.y+lengthdir_y(500, main_camera_target.image_angle),
			main_camera_target.z+z+120, 0, 0, 1
		);
		camera_set_view_mat(main_camera, global.view_matrix);
		camera_set_proj_mat(main_camera, global.projection_matrix);
		
		camera_apply(main_camera);
		gpu_set_zwriteenable(true);
		
		cam_zoom = clamp(cam_zoom, -100, 10);
	}
}
else {
	// debug camera
	camera_set_view_pos(
		main_camera,
		x,
		y
	);
	camera_set_view_size(main_camera, main_camera_size.width / cam_zoom, main_camera_size.height / cam_zoom);
	camera_set_view_angle(main_camera, cam_angle);
	cam_zoom = clamp(cam_zoom, 0.1, 10);
}
// other car spawning
if (global.GAMEPLAY_CARS) {
	var road_at_view_edge = find_nearest_road(
		main_camera_target.x + lengthdir_x(5000 * choose(-1,1), main_camera_target.image_angle),
		main_camera_target.y + lengthdir_y(5000 * choose(-1,1), main_camera_target.image_angle),
		main_camera_target.on_road_index
	)
	if (alarm[0] == -1) {
		if (irandom(200) == 1) {
			var spawn_lane = irandom_range(0, road_at_view_edge.get_lanes_right() - 1) + 0.5;
			var spawn_x = road_at_view_edge.x + lengthdir_x(road_at_view_edge.lane_width * spawn_lane, road_at_view_edge.direction - 90);
			var spawn_y = road_at_view_edge.y + lengthdir_y(road_at_view_edge.lane_width * spawn_lane, road_at_view_edge.direction - 90);
			var car = instance_create_layer(spawn_x, spawn_y, "Instances", obj_car, {
				image_angle: road_at_view_edge.direction,
			});
			car.rpm = 2000;
			car.max_velocity = 600 + (global.difficulty * 200);
			car.last_road_index = road_at_view_edge._id;
			car.on_road_index = road_at_view_edge;
			car.horsepower = 40;
			car.max_gear = 2;
			car.z = road_at_view_edge.z;
			car.ai_behavior.desired_lane = irandom(road_at_view_edge.get_lanes_right());
		}
	}
}

// race timer
if (alarm[0] < 0) {
	global.race_timer += delta_time / 1000000;
}