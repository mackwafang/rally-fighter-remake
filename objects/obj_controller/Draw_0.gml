//for (var i = 0; i < array_length(control_points) - 1; i++) {
//	var road = control_points[@ i];
//	var next_road = control_points[@ i + 1];
//	draw_line_color(
//		road.x,
//		road.y,
//		next_road.x,
//		next_road.y, 
//		c_red, c_red
//	);
//	draw_circle_color(road.x, road.y, 4, c_red, c_red, false);
//}
draw_text(x, y, $"{x}, {y}");

for (var i = 0; i < array_length(road_list) - 1; i++) {
	var road = road_list[@ i];
	var next_road = road_list[@ i + 1];
	draw_line_color(
		road.x,
		road.y,
		next_road.x,
		next_road.y, 
		c_white, c_white
	);
	if ((i % 10 == 0) or (i == array_length(road_list)-1)) {
		draw_circle_color(road.x, road.y, 8, c_white, c_white, false);
	}
	else {
		draw_circle_color(road.x, road.y, 2, c_white, c_white, false);
	}
}
draw_text(x, y, $"{x}, {y}");