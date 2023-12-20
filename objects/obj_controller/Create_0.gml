cam_move_speed = 16;
cam_zoom = 1;
cam_angle = 0;
z = -50;

depth = 10000;

participating_vehicles = [];
global.total_participating_vehicles = 12;
global.difficulty = 2;
global.gravity_3d = 9.8;

// cam stuff
if (global.CAMERA_MODE_3D) {
	gpu_set_zwriteenable(true);
	gpu_set_ztestenable(true);
	gpu_set_alphatestenable(true);
	gpu_set_alphatestref(64);
	game_set_speed(60, gamespeed_fps);
	init_bike_shadow_buffer();
}


instance_create_layer(0, 0, "Instances", obj_road_generator);

// racing car
for (var i = 0; i < global.total_participating_vehicles; i++) {
	var car = instance_create_layer(0, 0, "Instances", obj_car);
	if (i == 0) {
		car.is_player = true;
	}
	car.car_id = i+1;
	car.depth = 10;
	car.z = -10;
	participating_vehicles[array_length(participating_vehicles)] = car;
}

for (var i = 0; i < array_length(participating_vehicles); i++) {
	var car = participating_vehicles[i];
	car.race_rank = (array_length(participating_vehicles) - i);
	var road = obj_road_generator.road_list[(i div 3) + 1];
	var lane_position_x = (((i % 3) / 3) * road.length) + (road.length * (i div 3));
	var lane_position_y = ((i % road.get_lanes_right()) * road.lane_width) + (road.lane_width / 2) + (irandom(road.lane_width / 2) * choose(-1,1));
	
	var dist = point_distance(road.x, road.y, road.x + lane_position_x, road.y + lane_position_y);
	var dir = point_direction(road.x, road.y, road.x + lane_position_x, road.y + lane_position_y);
	
	car.x = road.x + lengthdir_x(dist, dir);
	car.y = road.y + lengthdir_y(dist, dir);
	car.image_angle = road.direction;
	if (!car.is_player) {
		car.can_move = false;
	}
	car.horsepower = 30 * global.difficulty;
	car.ai_behavior.part_of_race = true;	
	car.ai_behavior.desired_lane = (i % 3);
	//for (var g = 0; g < array_length(car.gear_shift_rpm); g++) {
	//	car.gear_shift_rpm[g][1] += (500 * global.difficulty);
	//}
}
car_ranking = [];
array_copy(car_ranking, 0, participating_vehicles, 0, array_length(participating_vehicles));

if (!global.DEBUG_FREE_CAMERA) {
	if (global.CAMERA_MODE_3D) {
		main_camera_size = {width: 640, height: 480,}
	}
	else {
		main_camera_size = {width: 480, height: 640,}
	}
	main_camera_target = participating_vehicles[0];
}
else {
	main_camera_size = {
		width: 640,
		height: 480,
	}
}
// set camera size
participating_camera_index = 0;
main_camera = view_camera[view_current];

view_set_wport(0, main_camera_size.width);
view_set_hport(0, main_camera_size.height);

window_set_size(main_camera_size.width, main_camera_size.height);
camera_set_view_size(main_camera, main_camera_size.width, main_camera_size.height);
surface_resize(application_surface, main_camera_size.width, main_camera_size.height);
global.view_matrix = undefined;
global.projection_matrix = matrix_build_projection_perspective_fov(120, 4/3, 1, 5000);


// set up sky box
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
skybox_vertex_format = vertex_format_end();
skybox_vertex_buffer = vertex_create_buffer();
vertex_begin(skybox_vertex_buffer, skybox_vertex_format);

vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, -1000, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, -1000, -1000, 1, 0);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, 1000, -1000, 0, 1);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, -1000, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, 0, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, 1000, 0, 0, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, 0, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, 0, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, -1000, 0, 1, 0);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, 0, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, 1000, 0, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, 1000, -1000, 0, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, 0, 1, 0);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, 1000, 0, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, -1000, 0, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, -1000, -1000, 0, 1);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, 0, 1, 0);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, -1000, 0, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, 0, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, -1000, 0, 1);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, 1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, 1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, 1000, 0, 1, 0);
vertex_position_3d_uv(skybox_vertex_buffer, -1000, -1000, 0, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, 0, 0, 0);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, -1000, 0, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, -1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, -1000, -1000, 1, 1);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, -1000, 0, 1, 0);
vertex_position_3d_uv(skybox_vertex_buffer, 1000, 1000, 0, 0, 0);

vertex_end(skybox_vertex_buffer);
vertex_freeze(skybox_vertex_buffer);

alarm[0] = 5 * 60; // starting timer