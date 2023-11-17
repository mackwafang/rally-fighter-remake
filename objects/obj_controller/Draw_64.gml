draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_text(0, 0, fps);

draw_set_valign(fa_top);
draw_set_halign(fa_right);
draw_text(main_camera_size.width, 0, obj_road_generator.track_length);


var ranking_verticle_cap = 20;
for (var rank = 0; rank < array_length(car_ranking); rank++) {
	var vehicle = car_ranking[rank];
	
	var dist = vehicle.dist_along_road;
	if (rank > 0) {
		dist = vehicle.dist_along_road - car_ranking[0].dist_along_road;
	}
	draw_text(main_camera_size.width - 32, 16 + (rank * ranking_verticle_cap), vehicle.race_rank);
	draw_text(main_camera_size.width - 48, 16 + (rank * ranking_verticle_cap), dist);
	draw_sprite_ext(vehicle.sprite_index, vehicle.image_index, main_camera_size.width - 16, 24 + (rank * ranking_verticle_cap), 1, 1, 90, vehicle.image_blend, 1);
	draw_sprite_ext(vehicle.vehicle_detail_index, vehicle.image_index, main_camera_size.width - 16, 24 + (rank * ranking_verticle_cap), 1, 1, 90, c_white, 1);
}


// starting timer
if (alarm[0] > 0) {
	draw_set_alpha(0.6);
	draw_rectangle_color(0, 0, main_camera_size.width, main_camera_size.height, 0, 0, 0, 0, false);
	draw_set_alpha(1);
	if (alarm[0] < 3 * 60) {
		draw_set_valign(fa_middle);
		draw_set_halign(fa_center);
		draw_sprite_ext(spr_starting_number, (alarm[0] div 60), main_camera_size.width / 2, main_camera_size.height / 2, 1, 2, 0, c_white, 1);
	}
}