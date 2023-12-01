// debuging camera
if (keyboard_check(ord("W"))) {y -= cam_move_speed;}
if (keyboard_check(ord("S"))) {y += cam_move_speed;}
if (keyboard_check(ord("A"))) {x -= cam_move_speed;}
if (keyboard_check(ord("D"))) {x += cam_move_speed;}
if (keyboard_check(vk_space)) {z += 1;}
if (keyboard_check(vk_control)) {z -= 1;}
if (keyboard_check(ord("Q"))) {
	if (global.DEBUG_FREE_CAMERA) {
		cam_angle -= 5;
	}
}
if (keyboard_check_pressed(ord("Q"))) {
	if (!global.DEBUG_FREE_CAMERA) {
		participating_camera_index = (participating_camera_index + 1) % array_length(participating_vehicles);
	}
}
if (keyboard_check(ord("E"))) {
	if (global.DEBUG_FREE_CAMERA) {
		cam_angle += 5;
	}
}if (keyboard_check_pressed(ord("E"))) {
	if (!global.DEBUG_FREE_CAMERA) {
		participating_camera_index = (participating_camera_index - 1 < 0) ? array_length(participating_vehicles)-1 : participating_camera_index - 1;
	}
}
if (mouse_wheel_up()) {cam_zoom += 0.1;}
if (mouse_wheel_down()) {cam_zoom -= 0.1;}
main_camera_target = participating_vehicles[participating_camera_index];

cam_zoom = clamp(cam_zoom, 0.1, 10);

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
		camera_set_view_mat(main_camera, matrix_build_lookat(
			main_camera_target.x+lengthdir_x(-30, main_camera_target.image_angle), 
			main_camera_target.y+lengthdir_y(-30, main_camera_target.image_angle), 
			z, 
			main_camera_target.x+lengthdir_x(500, main_camera_target.image_angle),
			main_camera_target.y+lengthdir_y(500, main_camera_target.image_angle),
			z+120, 0, 0, -1)
		);
		camera_set_proj_mat(main_camera, matrix_build_projection_perspective_fov(-90, room_width/room_height, 1, 2000));
		camera_apply(main_camera);
		gpu_set_zwriteenable(true);
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
}
// other car spawning
if (!global.GAMEPLAY_NO_CARS) {
	var road_at_view_edge = find_nearest_road(
		main_camera_target.x + lengthdir_x(2000 * choose(-1,1), main_camera_target.image_angle),
		main_camera_target.y + lengthdir_y(2000 * choose(-1,1), main_camera_target.image_angle),
		main_camera_target.last_road_index
	)
	if (alarm[0] == -1) {
		if (irandom(100) == 1) {
			var spawn_lane = irandom_range(0, road_at_view_edge.get_lanes_right() - 1) + 0.5;
			var spawn_x = road_at_view_edge.x + lengthdir_x(road_at_view_edge.lane_width * spawn_lane, road_at_view_edge.direction - 90);
			var spawn_y = road_at_view_edge.y + lengthdir_y(road_at_view_edge.lane_width * spawn_lane, road_at_view_edge.direction - 90);
			var car = instance_create_layer(spawn_x, spawn_y, "Instances", obj_car, {
				image_angle: road_at_view_edge.direction,
			});
		
			car.rpm = 4000;
			car.max_velocity = 500;
			car.last_road_index = road_at_view_edge._id;
			car.nav_road_index = road_at_view_edge;
			car.max_gear = 3;
			car.gear_shift_rpm = [
				[0, 8000],
				[3000, 7000],
				[3500, 6000],
			];
		}
	}
}