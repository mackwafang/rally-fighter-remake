cam_move_speed = 16;
cam_zoom = 1

participating_vehicles = [1];

for (var i = 0; i < 5; i++) {
	var car = instance_create_layer(0, 0, "Instances", obj_car);
	car.car_id = i+1;
	
	var road = obj_road_generator.road_list[(i div 3) + 1];
	var lane_position_x = ((i % road.get_lanes_right()) * road.lane_width * 1.5) + (road.lane_width / 2);
	var lane_position_y =  0;
	
	car.x = road.x + lengthdir_x(lane_position_x, road.direction - 45);
	car.y = road.y + lengthdir_y(lane_position_x, road.direction - 45);
	car.image_angle = road.direction;
	car.can_move = false;
	
	participating_vehicles[array_length(participating_vehicles)] = car;
}
car_ranking = [];
array_copy(car_ranking, 0, participating_vehicles, 0, array_length(participating_vehicles));

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

alarm[0] = 6 * 60; // starting timer