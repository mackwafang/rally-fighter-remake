// debuging camera
if (keyboard_check(ord("W"))) {y -= cam_move_speed;}
if (keyboard_check(ord("S"))) {y += cam_move_speed;}
if (keyboard_check(ord("A"))) {x -= cam_move_speed;}
if (keyboard_check(ord("D"))) {x += cam_move_speed;}
if (keyboard_check(ord("Q"))) {cam_angle -= 5;}
if (keyboard_check(ord("E"))) {cam_angle += 5;}
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
	camera_set_view_angle(main_camera, cam_angle);
}
// other car spawning
var road_at_view_edge = find_nearest_road(
	main_camera_target.x - (main_camera_size.width/2) + lengthdir_x(main_camera_size.width * 2, main_camera_target.image_angle),
	main_camera_target.y - (main_camera_size.height/2) + lengthdir_y(main_camera_size.width * 2, main_camera_target.image_angle)
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
		car.velocity = 3;
	}
}