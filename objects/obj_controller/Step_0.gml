// debuging camera
if (keyboard_check(ord("W"))) {y -= cam_move_speed;}
if (keyboard_check(ord("S"))) {y += cam_move_speed;}
if (keyboard_check(ord("A"))) {x -= cam_move_speed;}
if (keyboard_check(ord("D"))) {x += cam_move_speed;}
if (mouse_wheel_up()) {cam_zoom += 0.1;}
if (mouse_wheel_down()) {cam_zoom -= 0.1;}

cam_zoom = clamp(cam_zoom, 0.1, 10);

if (!global.DEBUG_FREE_CAMERA) {
	camera_set_view_pos(
		main_camera,
		main_camera_target.x - (main_camera_size.width/2) + lengthdir_x(main_camera_size.width * 0.45, main_camera_target.image_angle),
		main_camera_target.y - (main_camera_size.height/2) + lengthdir_y(main_camera_size.width * 0.45, main_camera_target.image_angle)
	);
	camera_set_view_angle(main_camera, -main_camera_target.image_angle+90);
}
else {
	camera_set_view_pos(
		main_camera,
		x,
		y
	);
	camera_set_view_size(main_camera, main_camera_size.width / cam_zoom, main_camera_size.height / cam_zoom);
}


// car ranking
array_sort(car_ranking, function(car1, car2) {
	return car2.dist_along_road - car1.dist_along_road;
});