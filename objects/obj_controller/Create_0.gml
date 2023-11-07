cam_move_speed = 16;
cam_zoom = 1

for (var i = 0; i < 12; i++) {
	instance_create_layer(0, 0, "Instances", obj_car);
}

if (!global.DEBUG_FREE_CAMERA) {
	main_camera_size = {
		width: 480,
		height: 640,
	}
	main_camera_target = 4;
}
else {
	main_camera_size = {
		width: 640,
		height: 480,
	}
}
// set camera size
main_camera = view_camera[view_current];

view_set_wport(0, main_camera_size.width);
view_set_hport(0, main_camera_size.height);

window_set_size(main_camera_size.width, main_camera_size.height);
camera_set_view_size(main_camera, main_camera_size.width, main_camera_size.height);
surface_resize(application_surface, main_camera_size.width, main_camera_size.height);