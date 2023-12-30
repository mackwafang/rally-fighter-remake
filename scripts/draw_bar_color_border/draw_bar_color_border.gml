function draw_bar_color_border(xx, yy, value, max_value, width, height, border, color1, color2, color3, color4, bkg_color) {
	/// @function			draw_bar_color_border(xx, yy, value, max_value, width, height, border, color1, color2, color3, color4, bkg_color);
	/// @param				xx
	/// @param				yy
	/// @param				value
	/// @param				max_value
	/// @param				width
	/// @param				height
	/// @param				border
	/// @param				color1
	/// @param				color2
	/// @param				color3
	/// @param				color4
	/// @param				bkg_color
	var bar_border = border;
	var bar_x = xx;
	var bar_y = yy;
	var bar_height = height;
	var bar_width = width;
	draw_rectangle_color(bar_x, bar_y, bar_x + bar_width, bar_y - bar_height, bkg_color, bkg_color, bkg_color, bkg_color, false);
	draw_rectangle_color(bar_x + bar_border, bar_y - bar_border, bar_x + value/max_value*(bar_width - bar_border), bar_y - bar_height + bar_border, color1, color2, color3, color4, false);
}

function draw_bar_color_border_no_bkg(xx, yy, value, max_value, width, height, border, color1, color2, color3, color4) {
	/// @function			draw_bar_color_border_no_bkg(xx, yy, value, max_value, width, height, border, color1, color2, color3, color4);
	/// @param				xx
	/// @param				yy
	/// @param				value
	/// @param				max_value
	/// @param				width
	/// @param				height
	/// @param				border
	/// @param				color1
	/// @param				color2
	/// @param				color3
	/// @param				color4
	var bar_border = border;
	var bar_x = xx;
	var bar_y = yy;
	var bar_height = height;
	var bar_width = width;
	draw_rectangle_color(bar_x + bar_border, bar_y - bar_border, bar_x + value/max_value*(bar_width - bar_border), bar_y - bar_height + bar_border, color1, color2, color3, color4, false);
}