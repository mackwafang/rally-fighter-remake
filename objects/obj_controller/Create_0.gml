cam_move_speed = 16;
cam_zoom = 1

participating_vehicles = [1];

for (var i = 0; i < 11; i++) {
	var car = instance_create_layer(0, 0, "Instances", obj_car);
	car.car_id = i+1;
	
	var starting_road_seg = obj_road_generator.road_list[i+1];
	var lane_position = (((car.car_id % starting_road_seg.get_lanes_left())) * starting_road_seg.lane_width) + (starting_road_seg.lane_width / 2);
	
	car.x = starting_road_seg.x + lengthdir_x(lane_position, starting_road_seg.direction - 90);
	car.y = starting_road_seg.y + lengthdir_y(lane_position, starting_road_seg.direction - 90);
	car.direction = starting_road_seg.direction;
	
	participating_vehicles[array_length(participating_vehicles)] = car;
}
car_ranking = [];

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