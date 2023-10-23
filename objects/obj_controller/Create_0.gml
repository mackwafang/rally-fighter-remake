cam_move_speed = 16;
cam_zoom = 1


main_camera = view_camera[view_current];
camera_set_view_size(main_camera, 480, 640);

main_camera_size = {
	width: camera_get_view_width(main_camera),
	height: camera_get_view_height(main_camera),
}
main_camera_target = 1;
// set camera size
view_set_wport(view_wport[view_current], main_camera_size.width);
view_set_hport(view_hport[view_current], main_camera_size.height);