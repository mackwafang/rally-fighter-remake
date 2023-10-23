// draw secondary points
for (var rpi = 0; rpi < array_length(road_points); rpi+=4) {
	// begin drawing road strip
	//check end of side
	//if (!camera_in_view(road_points[rpi][0].x, road_points[rpi][0].y, 256)) {continue;}
	draw_set_color(c_white);
	
	var subimage = 0;
	if (rpi > 0) {subimage = (road_points[rpi][2] != 0) ? 1:0;}
	
	var texture = sprite_get_texture(spr_road, subimage);
	draw_primitive_begin_texture(pr_trianglestrip, texture);
	for (var k = rpi; k < rpi+4; k++) {
		var coordinate = road_points[k][0];
		var uv = road_points[k][1];
		
		// occulsion culling
		draw_vertex_texture(coordinate.x, coordinate.y, uv.x, uv.y);
	}
	draw_primitive_end();
	draw_set_color(c_white);
}

if (global.DEBUG_ROAD_DRAW_CONTROL_POINTS) {
	for (var i = 0; i < array_length(control_points) - 1; i++) {
		var road = control_points[@ i];
		var next_road = control_points[@ i + 1];
		draw_line_color(
			road.x,
			road.y,
			next_road.x,
			next_road.y, 
			c_red, c_red
		);
		draw_circle_color(road.x, road.y, 4, c_red, c_red, false);
	}
}

// debug road information
if (global.DEBUG_ROAD_DRAW_ROAD_POINTS) {
	for (var i = 0; i < array_length(road_list) - 1; i++) {
		var road = road_list[@ i];
		var next_road = road_list[@ i + 1];
		
		if (!camera_in_view(road.x, road.y, 256)) {continue;}
		
		var segments = [
			new vec2(road.x+lengthdir_x(64*road.get_left_lanes(), road.direction+90), road.y+lengthdir_y(64*road.get_left_lanes(), road.direction+90)),
			new vec2(road.x+lengthdir_x(64*road.get_right_lanes(), road.direction-90), road.y+lengthdir_y(64*road.get_right_lanes(), road.direction-90)),
			new vec2(next_road.x+lengthdir_x(64*next_road.get_left_lanes(), next_road.direction+90), next_road.y+lengthdir_y(64*next_road.get_left_lanes(), next_road.direction+90)),
			new vec2(next_road.x+lengthdir_x(64*next_road.get_right_lanes(), next_road.direction-90), next_road.y+lengthdir_y(64*next_road.get_right_lanes(), next_road.direction-90)),
		];
		draw_line_color(
			road.x,
			road.y,
			next_road.x,
			next_road.y, 
			c_blue, c_blue
		);
		if (global.DEBUG_ROAD_DRAW_ROAD_LANES_POINTS) {
			draw_line_color(
				road.x,
				road.y,
				segments[0].x,
				segments[0].y,
				#00ff00, #00ff00
			);
			draw_line_color(
				road.x,
				road.y,
				segments[1].x,
				segments[1].y,
				#00ff00, #00ff00
			);
		}
	
		if ((i % road_segments == 0) or (i == array_length(road_list)-1)) {
			draw_circle_color(road.x, road.y, 8, c_white, c_white, false);
		}
		else {
			draw_circle_color(road.x, road.y, 2, c_white, c_white, false);
		}
	}
	
	//draw road segment corners
	//for (var i = 0; i < array_length(road_points); i++) {
	//	var coordinate = road_points[i][0];
		
	//	if (coordinate == undefined) {continue;}
	//	if (!camera_in_view(coordinate.x, coordinate.y ,256)) {continue;}

	//	draw_circle_color(coordinate.x, coordinate.y, 4, c_orange, c_orange, false);
	//	draw_text(coordinate.x, coordinate.y, i)
	//}
}