// draw secondary points
for (var i = 0; i < array_length(road_list) - 2; i++) {
	var road = road_list[@ i];
	var next_road = road_list[@ i + 1];
	// occulsion culling
	if (!camera_in_view(road.x, road.y, 256) || !camera_in_view(next_road.x, next_road.y, 256)) {
		continue;
	}
	// TODO REWORK ROAD RENDERING
	// begin drawing road strip
	draw_set_color(c_white);
	
	show_debug_message(array_length(road_points))
	for (var j = 0; j < array_length(road_points); j+=4) {
		var texture = sprite_get_texture(spr_road, (j < 4) ? 0 : 1);
		draw_primitive_begin_texture(pr_trianglestrip, texture);
		for (var k = j; k < j+4; k++) {
			show_debug_message(k);
			if (road_points[k] == undefined) {j-=2; break;}
			var coordinate = road_points[k][0];
			var uv = road_points[k][1];
		
			draw_vertex_texture(coordinate.x, coordinate.y, uv.x, uv.y);
		}
		draw_primitive_end();
	}
	draw_set_color(c_white);
	draw_text_color(road.x, road.y, road.lanes, c_white,c_white,c_white,c_white,1);
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
		var road_points = [
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
				road_points[0].x,
				road_points[0].y,
				#00ff00, #00ff00
			);
			draw_line_color(
				road.x,
				road.y,
				road_points[1].x,
				road_points[1].y,
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
}