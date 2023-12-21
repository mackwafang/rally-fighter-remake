
var port_width = view_wport[obj_controller.main_camera];
var port_height = view_hport[obj_controller.main_camera];

draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_text(0, 0, fps);

// draw race length
draw_set_valign(fa_top);
draw_set_halign(fa_right);
draw_text(main_camera_size.width, 0, $"{global.race_length / global.WORLD_TO_REAL_SCALE / 10000} km");


var ranking_verticle_cap = 20;
for (var rank = 0; rank < array_length(global.car_ranking); rank++) {
	var vehicle = global.car_ranking[rank];
	
	var dist = vehicle.dist_along_road;
	//if (rank > 0) {
	//	dist = vehicle.dist_along_road - car_ranking[0].dist_along_road;
	//}
	var distance_display = dist / global.WORLD_TO_REAL_SCALE / 10000;
	draw_text(main_camera_size.width - 32, 16 + (rank * ranking_verticle_cap), vehicle.race_rank);
	draw_text(main_camera_size.width - 48, 16 + (rank * ranking_verticle_cap), $"{distance_display} km");
	draw_sprite_ext(vehicle.sprite_index, vehicle.image_index, main_camera_size.width - 16, 24 + (rank * ranking_verticle_cap), 1, 1, 90, vehicle.image_blend, 1);
	if (vehicle.is_respawning) {
		draw_sprite_ext(spr_cross, 0, main_camera_size.width - 16, 24 + (rank * ranking_verticle_cap), 1, 1, 90, c_white, 1);
	}
	vehicle.ai_behavior.race_rank = rank + 1;
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

var border = 2;
// draw control path
for (var i = 0; i < array_length(obj_road_generator.control_path)-1; i++) {
	var x1 = ((obj_road_generator.control_path[i] % obj_road_generator.grid_width)*border) + 8;
	var y1 = ((obj_road_generator.control_path[i] div obj_road_generator.grid_width)*border) + 8;
	var x2 = ((obj_road_generator.control_path[i+1] % obj_road_generator.grid_width)*border) + 8;
	var y2 = ((obj_road_generator.control_path[i+1] div obj_road_generator.grid_width)*border) + 8;
	draw_line_width_color(x1, y1, x2, y2, 2, c_red, c_red);
}

//for (var i = 0; i < ds_list_size(obj_road_generator.grid); i++) {
//	var x1 = ((i % obj_road_generator.grid_width)*border);
//	var y1 = ((i div obj_road_generator.grid_width)*border);
//	var x2 = (((i % obj_road_generator.grid_width)-1)*border);
//	var y2 = (((i div obj_road_generator.grid_width)-1)*border);
//	var col = (obj_road_generator.grid[|i])+128;
//	col = make_color_rgb(col, col, col);
//	draw_rectangle_color(x1, y1, x2, y2, col, col, col, col, false);
//}

vehicle_current_pos_ping = (vehicle_current_pos_ping+1) % 100;
for (var i = 0; i < global.total_participating_vehicles; i++) {
	var vehicle = participating_vehicles[i];
	if (vehicle != undefined) {
		var vehicle_current_cp = find_nearest_cp(vehicle.x, vehicle.y);
		var x1 = ((obj_road_generator.control_path[vehicle_current_cp] % obj_road_generator.grid_width)*border) + 8;
		var y1 = ((obj_road_generator.control_path[vehicle_current_cp] div obj_road_generator.grid_width)*border) + 8;
		var dot_data = {
			size: vehicle.is_player ? 4 : 2,
			color: vehicle.is_player ? c_green : c_white,
		}
		draw_circle_color(x1, y1, dot_data.size, dot_data.color, dot_data.color, false);
		
		if (vehicle.is_player) {
			var anic = animcurve_get(anic_ping);
			var scale = animcurve_channel_evaluate(animcurve_get_channel(anic, 0), vehicle_current_pos_ping/100) / 2;
			var alpha = animcurve_channel_evaluate(animcurve_get_channel(anic, 1), vehicle_current_pos_ping/100);
			draw_sprite_ext(spr_ping, 0, x1, y1, scale, scale, 0, c_red, alpha);
		}
	}
}