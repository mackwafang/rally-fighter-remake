if (is_player) {
	var port_width = view_wport[view_camera[view_current]];
	var port_height = view_hport[view_camera[view_current]];
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	draw_text(0, 100, on_road);
	
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
	
	// speed odometer
	odometer_x = 96;
	odometer_y = port_height - 48;
	odometer_speed += ((velocity / 18) - odometer_speed) * 0.2;
	draw_line_width_color(
		odometer_x,
		odometer_y,
		odometer_x + lengthdir_x(32,180 - (odometer_speed * 180)),
		odometer_y + lengthdir_y(32,180 - (odometer_speed * 180)),
		3,
		c_red,
		c_red
	)
	
	// gear
	draw_set_valign(fa_top);
	draw_set_halign(fa_center);
	draw_text(64,port_height - 32,$"{gear} gear");
}