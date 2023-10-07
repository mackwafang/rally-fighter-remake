for (var i = 0; i < array_length(road_list) - 1; i++) {
	var road = road_list[@ i];
	var next_road = road_list[@ i + 1];
	draw_line_color(
		xstart + road.x,
		ystart + road.y,
		xstart + next_road.x,
		ystart + next_road.y, 
		c_white, c_white
	);
}