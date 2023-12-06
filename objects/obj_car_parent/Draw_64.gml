var main_camera = obj_controller.main_camera;
var main_camera_pos = {
	x: camera_get_view_x(main_camera),
	y: camera_get_view_y(main_camera)
};
var main_camera_angle = camera_get_view_angle(main_camera);
var main_camera_size = {
	width: camera_get_view_width(main_camera),
	height: camera_get_view_height(main_camera)
};
var port_width = view_wport[main_camera];
var port_height = view_hport[main_camera];

#region Health Bar
if (ai_behavior.part_of_race) {
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	var original_coord = {
		x1: main_camera_size.width/2,
		y1: main_camera_size.height/2,
		x2: x - main_camera_pos.x + lengthdir_x(-sprite_width + 2, image_angle),
		y2: y - main_camera_pos.y + lengthdir_y(-sprite_width + 2, image_angle),
	}
	var dist = point_distance(original_coord.x1, original_coord.y1, original_coord.x2, original_coord.y2);
	var dir = point_direction(original_coord.x1, original_coord.y1, original_coord.x2, original_coord.y2) + main_camera_angle;
	var draw_x = (main_camera_size.width/2) + lengthdir_x(dist, dir);
	var draw_y = (main_camera_size.height/2) + lengthdir_y(dist, dir);
	draw_sprite_ext(spr_health_bar_small, 0, draw_x, draw_y, 1, 1, 0, c_white, 1);
	draw_sprite_general(spr_health_bar_small, 1, 0, 0, 16, 8, draw_x, draw_y, 1, 1, 0, c_red, c_red, c_red, c_red, 1);
	var health_bar = max(0, hp/max_hp) * 13;
	draw_rectangle_color(draw_x + 1, draw_y+2, draw_x+1 + health_bar, draw_y+5, c_green, c_green, c_green, c_green, false);

	if (ai_behavior.part_of_race) {
		if (race_rank > 0) {
			var rank_str = string(race_rank);
			for (var i = 0; i < string_length(rank_str); i++) {
				draw_sprite(spr_rank_font_small, ord(string_char_at(rank_str, i+1)) - 48, draw_x - ((string_length(rank_str) - i)*4), draw_y);
			}
		}
	}
}
#endregion

if (obj_controller.main_camera_target.id == id) {
	draw_text(16, 16, $"{x}, {y}, {z}");
	draw_text(16, 32, $"{zspeed}");
	
	// rpm odometer
	var odometer_x = 48;
	var odometer_y = port_height - 48;
	odometer_rpm += ((engine_rpm / engine_rpm_max) - odometer_rpm) * 0.2;
	draw_line_width_color(
		odometer_x,
		odometer_y,
		odometer_x + lengthdir_x(32,180 - (odometer_rpm * 180)),
		odometer_y + lengthdir_y(32,180 - (odometer_rpm * 180)),
		3,
		c_red,
		c_red
	)
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_center);
	draw_text(odometer_x, odometer_y - 32, $"{round(engine_rpm)} RPM");
	
	// speed odometer
	odometer_x = 128;
	odometer_y = port_height - 48;
	odometer_speed += ((velocity / 100 / 18) - odometer_speed) * 0.2;
	draw_line_width_color(
		odometer_x,
		odometer_y,
		odometer_x + lengthdir_x(32,180 - (odometer_speed * 180)),
		odometer_y + lengthdir_y(32,180 - (odometer_speed * 180)),
		3,
		c_red,
		c_red
	)
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_center);
	draw_text(odometer_x, odometer_y - 48, $"{round(acceleration * global.WORLD_TO_REAL_SCALE / 10)} MPH");
	draw_text(odometer_x, odometer_y - 32, $"{round(velocity * global.WORLD_TO_REAL_SCALE / 10)} MPH");
	
	// gear
	draw_set_valign(fa_top);
	draw_set_halign(fa_center);
	draw_text(64,port_height - 32,$"{gear} gear");
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_center);
	draw_text(128,port_height - 32,$"{ai_behavior.race_rank}");
}