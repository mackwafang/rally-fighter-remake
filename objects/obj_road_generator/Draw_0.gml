// draw roads
if (global.CAMERA_MODE_3D) {
	//for (var i = 0; i < array_length(road_vertex_buffers); i++) {
	//	var buffer = road_vertex_buffers[i][0];
	//	var subimage = road_vertex_buffers[i][1];
	//	var sprite = road_vertex_buffers[i][2];
		
	//	var tex = sprite_get_texture(sprite, subimage);
	//	vertex_submit(buffer, pr_trianglestrip, tex);
	//}
	var tex = sprite_get_texture(spr_road, 0);
	vertex_submit(road_vertex_buffers, pr_trianglelist, tex);
}
else {
	for (var rpi = 0; rpi < array_length(road_points); rpi+=4) {
		// begin drawing road strip
		//check end of side
		if (!camera_in_view(road_points[rpi][0].x, road_points[rpi][0].y, 512)) {continue;}
		draw_set_color(c_white);
	
		var subimage = road_points[rpi][2];
		var sprite = road_points[rpi][3];
		var texture = sprite_get_texture(sprite, subimage);
	
		draw_primitive_begin_texture(pr_trianglestrip, texture);
		for (var k = rpi; k < rpi+4; k++) {
			var coordinate = road_points[k][0];
			var uv = road_points[k][1];
		
			draw_vertex_texture(coordinate.x, coordinate.y, uv.x, uv.y);
		}
		draw_primitive_end();
		draw_set_color(c_white);
	
		//var a = [0,1,3,2];
		//for (var k = 0; k <= 4; k++) {
		//	var coordinate = road_points[rpi+(a[k%4])][0];
		//	var coordinate_next = road_points[rpi+(a[(k+1)%4])][0];
		//	draw_line_width_color(coordinate.x, coordinate.y, coordinate_next.x, coordinate_next.y, 2, c_red, c_red);
		//}
	}
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
		
		draw_text(road.x, road.y, road.ideal_throttle);
		if (!camera_in_view(road.x, road.y, 256)) {continue;}
		
		var segments = [
			new Vec2(road.x+lengthdir_x(64*road.get_lanes_left(), road.direction+90), road.y+lengthdir_y(64*road.get_lanes_left(), road.direction+90)),
			new Vec2(road.x+lengthdir_x(64*road.get_lanes_right(), road.direction-90), road.y+lengthdir_y(64*road.get_lanes_right(), road.direction-90)),
			new Vec2(next_road.x+lengthdir_x(64*next_road.get_lanes_left(), next_road.direction+90), next_road.y+lengthdir_y(64*next_road.get_lanes_left(), next_road.direction+90)),
			new Vec2(next_road.x+lengthdir_x(64*next_road.get_lanes_right(), next_road.direction-90), next_road.y+lengthdir_y(64*next_road.get_lanes_right(), next_road.direction-90)),
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

//array_foreach(road_collision_points, function(road) {
//	for (var i = 0; i <= 4; i++) {
		
//		draw_line_width(
//			road[0][i % 4],
//			road[1][i % 4],
//			road[0][(i+1) % 4],
//			road[1][(i+1) % 4],
//			2
//		)
//	}
//});