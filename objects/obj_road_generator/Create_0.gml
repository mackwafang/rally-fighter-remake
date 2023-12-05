randomize();
//random_set_seed(0);
depth = 1000;

primary_count = 100 * global.difficulty;
road_segments = 10;
control_points = array_create(primary_count);
control_points_dist = 2048;
lane_width = 64;
track_length = 0;
beyond_shoulder_range = 2048;

var t = current_time;

// initialize control points
var next_dir = 0;
var next_elevation = 0
var stay_straight = 5;
control_points[0] = new Point3D(x, y, 0);
for (var s = 1; s < primary_count; s++) {
	if (s > stay_straight) {
		next_dir += random_range(-1,1)*(global.difficulty * 15);
		next_elevation = irandom(600) * choose(-1,0,1);
	}
	control_points[s] = new Point3D(
		control_points[s-1].x + (cos(degtorad(next_dir)) * control_points_dist),//((s < stay_straight) ? control_points_dist : irandom_range(control_points_dist/4, control_points_dist))),
		control_points[s-1].y + (sin(degtorad(next_dir)) * control_points_dist),//((s < stay_straight) ? control_points_dist : irandom_range(control_points_dist/4, control_points_dist)))
		control_points[s-1].z + next_elevation//((s < stay_straight) ? control_points_dist : irandom_range(control_points_dist/4, control_points_dist)))
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

// calcualte elevation
for (var i = 0; i < array_length(road_list)-1; i++) {
	var road = road_list[@i];
	var road_next = road_list[@i+1];
	road.next_road = road_next;
	road.elevation = arctan((road.z - road_next.z) / road.length);
}

road_points = []; // precalculate road polygons

// 3d road render data
vertex_format_begin();
if (global.CAMERA_MODE_3D) {vertex_format_add_position_3d();} else {vertex_format_add_position();}
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
	var shoulder_uv = sprite_get_uvs(spr_road_shoulder, 0);
	var grass_uv = sprite_get_uvs(spr_grass, 0);
	
	#region Road Render Polygons
	var road_seg_data = [
		//left grass
		[new Point3D(collision_points[0][0], collision_points[1][0], road.z+1), new Point(grass_uv[0], grass_uv[1])],
		[new Point3D(road.x+lengthdir_x(beyond_shoulder_range, road.direction+90), road.y+lengthdir_y(beyond_shoulder_range, road.direction+90), road.z), new Point(grass_uv[0], grass_uv[3])],
		[new Point3D(collision_points[0][1], collision_points[1][1], next_road.z+1), new Point(grass_uv[2], grass_uv[1])],
		
		[new Point3D(collision_points[0][1], collision_points[1][1], next_road.z+1), new Point(grass_uv[2], grass_uv[1])],
		[new Point3D(road.x+lengthdir_x(beyond_shoulder_range, road.direction+90), road.y+lengthdir_y(beyond_shoulder_range, road.direction+90), road.z), new Point(grass_uv[0], grass_uv[3])],
		[new Point3D(next_road.x+lengthdir_x(beyond_shoulder_range, next_road.direction+90), next_road.y+lengthdir_y(beyond_shoulder_range, next_road.direction+90), next_road.z), new Point(grass_uv[2], grass_uv[3])],
	
		//left shoulder 
		[new Point3D(collision_points[0][0], collision_points[1][0], road.z), new Point(shoulder_uv[0], shoulder_uv[1])],
		[new Point3D(road.x+lengthdir_x(lane_width*(left_lanes+1), road.direction+90), road.y+lengthdir_y(lane_width*(left_lanes+1), road.direction+90), road.z), new Point(shoulder_uv[0], shoulder_uv[3])],
		[new Point3D(collision_points[0][1], collision_points[1][1], next_road.z), new Point(shoulder_uv[2], shoulder_uv[1])],
		
		[new Point3D(collision_points[0][1], collision_points[1][1], next_road.z), new Point(shoulder_uv[2], shoulder_uv[1])],
		[new Point3D(road.x+lengthdir_x(lane_width*(left_lanes+1), road.direction+90), road.y+lengthdir_y(lane_width*(left_lanes+1), road.direction+90), road.z), new Point(shoulder_uv[0], shoulder_uv[3])],
		[new Point3D(next_road.x+lengthdir_x(lane_width*(next_left_lanes+1), next_road.direction+90), next_road.y+lengthdir_y(lane_width*(next_left_lanes+1), next_road.direction+90), next_road.z), new Point(shoulder_uv[2], shoulder_uv[3])],
		
		//left road
		[new Point3D(collision_points[0][0], collision_points[1][0], road.z), new Point(left_uv[0], left_uv[3])],
		[new Point3D(road.x, road.y, road.z), new Point(left_uv[0], left_uv[1])],
		[new Point3D(collision_points[0][1], collision_points[1][1], next_road.z), new Point(left_uv[2], left_uv[3])],
		
		[new Point3D(road.x, road.y, road.z), new Point(left_uv[0], left_uv[1])],
		[new Point3D(collision_points[0][1], collision_points[1][1], next_road.z), new Point(left_uv[2], left_uv[3])],
		[new Point3D(next_road.x, next_road.y, next_road.z), new Point(left_uv[2], left_uv[1])],
		
		//righ road
		[new Point3D(road.x, road.y, road.z), new Point(right_uv[0], right_uv[1])],
		[new Point3D(collision_points[0][3], collision_points[1][3], road.z), new Point(right_uv[0], right_uv[3])],
		[new Point3D(next_road.x, next_road.y, next_road.z), new Point(right_uv[2], right_uv[1])],
		
		
		[new Point3D(collision_points[0][3], collision_points[1][3], road.z), new Point(right_uv[0], right_uv[3])],
		[new Point3D(next_road.x, next_road.y, next_road.z), new Point(right_uv[2], right_uv[1])],
		[new Point3D(collision_points[0][2], collision_points[1][2], next_road.z), new Point(right_uv[2], right_uv[3])],
		
		//right shoulder 
		[new Point3D(collision_points[0][2], collision_points[1][2], next_road.z), new Point(shoulder_uv[0], shoulder_uv[1])],
		[new Point3D(road.x+lengthdir_x(lane_width*(next_right_lanes+1), road.direction-90), road.y+lengthdir_y(lane_width*(next_right_lanes+1), road.direction-90), road.z), new Point(shoulder_uv[0], shoulder_uv[3])],
		[new Point3D(collision_points[0][3], collision_points[1][3], road.z), new Point(shoulder_uv[2], shoulder_uv[1])],
		
		[new Point3D(collision_points[0][2], collision_points[1][2], next_road.z), new Point(shoulder_uv[2], shoulder_uv[1])],
		[new Point3D(next_road.x+lengthdir_x(lane_width*(next_right_lanes+1), next_road.direction-90), next_road.y+lengthdir_y(lane_width*(next_right_lanes+1), next_road.direction-90), next_road.z), new Point(shoulder_uv[2], shoulder_uv[3])],
		[new Point3D(road.x+lengthdir_x(lane_width*(next_right_lanes+1), road.direction-90), road.y+lengthdir_y(lane_width*(next_right_lanes+1), road.direction-90), road.z), new Point(shoulder_uv[0], shoulder_uv[3])],
		
		// right grass
		[new Point3D(collision_points[0][2], collision_points[1][2], next_road.z+1), new Point(grass_uv[0], grass_uv[1])],
		[new Point3D(road.x+lengthdir_x(beyond_shoulder_range, road.direction-90), road.y+lengthdir_y(beyond_shoulder_range, road.direction-90), road.z), new Point(grass_uv[0], grass_uv[3])],
		[new Point3D(collision_points[0][3], collision_points[1][3], road.z+1), new Point(grass_uv[2], grass_uv[1])],
		
		[new Point3D(collision_points[0][2], collision_points[1][2], next_road.z+1), new Point(grass_uv[2], grass_uv[1])],
		[new Point3D(next_road.x+lengthdir_x(beyond_shoulder_range, next_road.direction-90), next_road.y+lengthdir_y(beyond_shoulder_range, next_road.direction-90), next_road.z), new Point(grass_uv[2], grass_uv[3])],
		[new Point3D(road.x+lengthdir_x(beyond_shoulder_range, road.direction-90), road.y+lengthdir_y(beyond_shoulder_range, road.direction-90), road.z), new Point(grass_uv[0], grass_uv[3])],
	]
	#endregion
	
	road.collision_points = collision_points;
	
	road_points = array_concat(road_points, road_seg_data);
	for (var di = 0; di < array_length(road_seg_data); di++) {
		var data = road_seg_data[di];
		var pos = data[0];
		var uv = data[1];
		if (global.CAMERA_MODE_3D) {vertex_position_3d(road_vertex_buffers, pos.x, pos.y, pos.z + 3);} else {vertex_position(road_vertex_buffers, pos.x, pos.y);}
		vertex_color(road_vertex_buffers, c_white, 1);
		vertex_texcoord(road_vertex_buffers, uv.x, uv.y);
	}
	
	//create trees
	for (var tid = 0; tid < irandom(5); tid++) {
		var begin_length = choose(
			lane_width*(left_lanes+1) + irandom(beyond_shoulder_range),
			-lane_width*(right_lanes+1) - irandom(beyond_shoulder_range),
		);
		var tree_obj = instance_create_layer(
			road.x + lengthdir_x(begin_length, road.direction + 90),
			road.y + lengthdir_y(begin_length, road.direction + 90),
			"Instances",
			obj_tree
		);
		tree_obj.z = road.z;
	}
}
vertex_end(road_vertex_buffers);
vertex_freeze(road_vertex_buffers);

global.road_list_length = array_length(road_list);

obj_controller.x = road_list[0].x;
obj_controller.y = road_list[0].y;

show_debug_message($"road generation completed in {current_time - t}ms");
show_debug_message($"Road has {array_length(road_points)} points");
