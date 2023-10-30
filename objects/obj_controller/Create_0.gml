cam_move_speed = 16;
cam_zoom = 1

if (!global.DEBUG_FREE_CAMERA) {
	main_camera_size = {
		width: 480,
		height: 640,
	}
}
else {
	main_camera_size = {
		width: 640,
		height: 640,
	}
}
// set camera size

main_camera = camera_create_view(0, 0, main_camera_size.width, main_camera_size.height);

view_set_wport(1, main_camera_size.width);
view_set_hport(1, main_camera_size.height);

window_set_size(main_camera_size.width, main_camera_size.height);
camera_set_view_size(main_camera, main_camera_size.width, main_camera_size.height);
view_set_camera(1, main_camera);
view_set_visible(1, true)