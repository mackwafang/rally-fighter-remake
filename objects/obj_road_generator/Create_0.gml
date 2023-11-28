randomize();
//random_set_seed(0);
depth = 1000;

primary_count = 100 * global.difficulty;
road_segments = 20;
control_points = array_create(primary_count);
control_points_dist = 2048;
lane_width = 32;
track_length = 0;

var t = current_time;

// initialize control points
var next_dir = 0;
var stay_straight = 5;
control_points[0] = new Point(x,y);
for (var s = 1; s < primary_count; s++) {
	if (s > stay_straight) {
		next_dir += irandom_range(-1,1)*(global.difficulty * 15);
	}
	control_points[s] = new Point(
		control_points[s-1].x + (cos(degtorad(next_dir)) * control_points_dist),//((s < stay_straight) ? control_points_dist : irandom_range(control_points_dist/4, control_points_dist))),
		control_points[s-1].y + (sin(degtorad(next_dir)) * control_points_dist)//((s < stay_straight) ? control_points_dist : irandom_range(control_points_dist/4, control_points_dist)))
	);
}

road_list = generate_roads(control_points, road_segments);

// set up road node data
var lane_change_duration = 100; //how many nodes until change to new lane
var lane_change_to = 3; // change this side of road to this number of lanes
var lane_side_affected = ROAD_LANE_CHANGE_AFFECT.BOTH; // which side of the road changes 
for (var i = 0; i < array_length(road_list)-1; i++) {
	var road = road_list[@i];
	var road_next = road_list[@i+1];
	road.direction = point_direction(road.x, road.y, road_next.x, road_next.y);
	road.length = point_distance(road.x, road.y, road_next.x, road_next.y);
	// road.ideal_throttle = road.length / ((control_points_dist / road_segments) * 0.8);
	if (i > 0) {
		//road.ideal_throttle = cos(degtorad(angle_difference(road_list[@i-1].direction, road.direction)));
		road.ideal_throttle = road.length / ((control_points_dist / road_segments) * 0.8);
	}
	else {
		road.ideal_throttle = 1;
	}
	road._id = i;
	road.lane_width = lane_width;
	road_next.length_to_point = road.length_to_point + road.length;
	track_length += road.length;
	
	// road changes lane count
	if (lane_change_duration == 0) {
		lane_side_affected = choose(ROAD_LANE_CHANGE_AFFECT.LEFT, ROAD_LANE_CHANGE_AFFECT.RIGHT, ROAD_LANE_CHANGE_AFFECT.BOTH);
		lane_change_duration = 30+irandom(10);
		lane_change_to = 1+irandom(2);
	}
	switch(lane_side_affected) {
		case ROAD_LANE_CHANGE_AFFECT.LEFT:
			road.set_lanes_left(lane_change_to);
			road.set_lanes_right(road_list[@i-1].get_lanes_right());
			break;
		case ROAD_LANE_CHANGE_AFFECT.RIGHT:
			road.set_lanes_left(road_list[@i-1].get_lanes_left());
			road.set_lanes_right(lane_change_to);
			break;
		case ROAD_LANE_CHANGE_AFFECT.BOTH:
			road.set_lanes_side(lane_change_to);
			break;
	}
	lane_change_duration--;
}

road_points = []; // precalculate road polygons
road_collision_points = []; // calcuate road segments for colision checking

// 3d road render data
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
road_vertex_format = vertex_format_end();
road_vertex_buffers = vertex_create_buffer();

vertex_begin(road_vertex_buffers, road_vertex_format);
for (var i = 0; i < array_length(road_list) - 1; i++) {
	// for each road piece
	var road = road_list[@ i];
	var next_road = road_list[@ i + 1];
	
	var lane_function = [road.get_lanes_left, road.get_lanes_right];
	var next_lane_function = [next_road.get_lanes_left, next_road.get_lanes_right];
	
	
	//compile left lanes
	var left_lanes = road.get_lanes_left();
	var right_lanes = road.get_lanes_right();
	var next_left_lanes = next_road.get_lanes_left();
	var next_right_lanes = next_road.get_lanes_right();
	var left_subimage = max(left_lanes, next_left_lanes);
	var right_subimage = max(right_lanes, next_right_lanes);
	var left_lane_sprite = (left_lanes != next_left_lanes) ? spr_road_no_lane_mark : spr_road;
	var right_lane_sprite = (right_lanes != next_right_lanes) ? spr_road_no_lane_mark : spr_road;
	var collision_points = [
		 [
			road.x+lengthdir_x(lane_width*left_lanes, road.direction+90),
			next_road.x+lengthdir_x(lane_width*next_left_lanes, next_road.direction+90),
			next_road.x+lengthdir_x(lane_width*next_right_lanes, next_road.direction-90),
			road.x+lengthdir_x(lane_width*right_lanes, road.direction-90),
		],
		[
			road.y+lengthdir_y(lane_width*left_lanes, road.direction+90),
			next_road.y+lengthdir_y(lane_width*next_left_lanes, next_road.direction+90),
			next_road.y+lengthdir_y(lane_width*next_right_lanes, next_road.direction-90),
			road.y+lengthdir_y(lane_width*right_lanes, road.direction-90),
		]
	];
	var left_uv = sprite_get_uvs(left_lane_sprite, left_subimage);
	var right_uv = sprite_get_uvs(right_lane_sprite, right_subimage);
	
	var road_seg_data = [
		[new Point(collision_points[0][0], collision_points[1][0]), new Point(left_uv[0], left_uv[3]), left_subimage, left_lane_sprite],
		[new Point(road.x, road.y), new Point(left_uv[0], left_uv[1]), left_subimage, left_lane_sprite],
		[new Point(collision_points[0][1], collision_points[1][1]), new Point(left_uv[2], left_uv[3]), left_subimage, left_lane_sprite],
		
		[new Point(road.x, road.y), new Point(left_uv[0], left_uv[1]), left_subimage, left_lane_sprite],
		[new Point(collision_points[0][1], collision_points[1][1]), new Point(left_uv[2], left_uv[3]), left_subimage, left_lane_sprite],
		[new Point(next_road.x, next_road.y), new Point(left_uv[2], left_uv[1]), left_subimage, left_lane_sprite],
		
		
		[new Point(road.x, road.y), new Point(right_uv[0], right_uv[1]), right_subimage, right_lane_sprite],
		[new Point(collision_points[0][3], collision_points[1][3]), new Point(right_uv[0], right_uv[3]), right_subimage, right_lane_sprite],
		[new Point(next_road.x, next_road.y), new Point(right_uv[2], right_uv[1]), right_subimage, right_lane_sprite],
		
		
		[new Point(collision_points[0][3], collision_points[1][3]), new Point(right_uv[0], right_uv[3]), right_subimage, right_lane_sprite],
		[new Point(next_road.x, next_road.y), new Point(right_uv[2], right_uv[1]), right_subimage, right_lane_sprite],
		[new Point(collision_points[0][2], collision_points[1][2]), new Point(right_uv[2], right_uv[3]), right_subimage, right_lane_sprite],
	]
	
	road_collision_points[array_length(road_collision_points)] = collision_points;
	road_points = array_concat(road_points, road_seg_data);
	
	if (global.CAMERA_MODE_3D) {
		for (var di = 0; di < array_length(road_seg_data); di++) {
			var data = road_seg_data[di];
			var pos = data[0];
			var uv = data[1];
			var subimage = data[2];
			var sprite = data[3];
			
			vertex_position_3d(road_vertex_buffers, pos.x, pos.y, 3);
			vertex_color(road_vertex_buffers, c_white, 1);
			vertex_texcoord(road_vertex_buffers, uv.x, uv.y);
		}
	}
}
vertex_end(road_vertex_buffers);
vertex_freeze(road_vertex_buffers);

obj_controller.x = road_list[0].x;
obj_controller.y = road_list[0].y;

show_debug_message($"road generation completed in {current_time - t}ms");
show_debug_message($"Road has {array_length(road_points)} points");
