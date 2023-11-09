draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_text(0, 0, fps);

draw_set_valign(fa_top);
draw_set_halign(fa_right);
draw_text(main_camera_size.width, 0, obj_road_generator.track_length);


var ranking_verticle_cap = 20;
for (var rank = 0; rank < array_length(car_ranking); rank++) {
	var vechicle = car_ranking[rank];
	var dist = vechicle.dist_along_road;
	if (rank > 0) {
		dist = vechicle.dist_along_road - car_ranking[0].dist_along_road;
	}
	draw_text(main_camera_size.width - 32, 16 + (rank * ranking_verticle_cap), rank);
	draw_text(main_camera_size.width - 48, 16 + (rank * ranking_verticle_cap), dist);
	draw_sprite_ext(vechicle.sprite_index, vechicle.image_index, main_camera_size.width - 16, 24 + (rank * ranking_verticle_cap), 1, 1, 90, vechicle.image_blend, 1);
	draw_sprite_ext(vechicle.vehicle_detail_index, vechicle.image_index, main_camera_size.width - 16, 24 + (rank * ranking_verticle_cap), 1, 1, 90, c_white, 1);
}