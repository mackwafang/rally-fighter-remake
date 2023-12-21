randomize();
//random_set_seed(0);
depth = 1000;

// primary_count = 80 * global.difficulty;
road_segments = 15;
control_points = [];
control_points_dist = 2048;
lane_width = 80;
track_length = 0;
beyond_shoulder_range = 1500;

var t = current_time;


// initialize control points using path finding via a-star
grid_width = 64 * global.difficulty;
grid_height = 64 * global.difficulty;
grid = ds_list_create();
// intialize random weights for grids
print("Creating grid");
perlin_config = {
	inc: 0.15,
	X: random(1000),
	Y: random(1000),
}
for (var i = 0; i < grid_height*grid_width; i++) {ds_list_add(grid, 0);}

for (var yy = 0; yy < grid_height; yy++) {
	var Y_temp = perlin_config.Y;
	for (var xx = 0; xx < grid_width; xx++) {
		var index = xx + (yy * grid_height);
		var value = perlin_noise(perlin_config.X, Y_temp);
		grid[|index] = value*512;
		Y_temp += perlin_config.inc;
	}
	perlin_config.X += perlin_config.inc;
}
print($"{ds_list_size(grid)} {grid_height * grid_width}");
print("Creating road");
var init_grid = irandom(grid_height)
var control_start =  init_grid * grid_width;
var control_end = (min(grid_height, max(0, init_grid + irandom_range(-8 * global.difficulty, 8 * global.difficulty))) * grid_width) - 1;
control_path = a_star(grid, control_start, control_end, grid_width, a_star_heuristic);
primary_count = array_length(control_path);
for (var s = 0; s < array_length(control_path); s++) {
	var xx = ((control_path[s] % grid_width) * control_points_dist);// + (irandom(control_points_dist) * choose(-0.5, 0.5));
	var yy = ((control_path[s] div grid_width) * control_points_dist);// + (irandom(control_points_dist) * choose(-0.5, 0.5));
	var zz = -grid[|s];
	control_points[s] = new Point3D(xx, yy, zz);
}


// initialize control points
//var next_dir = 0;
//var next_elevation = 0
//var stay_straight = 5;
//control_points[0] = new Point3D(0, 0, 0);
//for (var s = 1; s < primary_count; s++) {
//	if (s > stay_straight) {
//		next_dir += random_range(-1,1)*(global.difficulty * 20);
//		next_elevation = irandom(500) * choose(-1,0,1);
//	}
//	control_points[s] = new Point3D(
//		control_points[s-1].x + (cos(degtorad(next_dir)) * control_points_dist),//((s < stay_straight) ? control_points_dist : irandom_range(control_points_dist/4, control_points_dist))),
//		control_points[s-1].y + (sin(degtorad(next_dir)) * control_points_dist),//((s < stay_straight) ? control_points_dist : irandom_range(control_points_dist/4, control_points_dist)))
//		control_points[s-1].z + next_elevation//((s < stay_straight) ? control_points_dist : irandom_range(control_points_dist/4, control_points_dist)))
//	);
//}
print("Rendering Road")
road_list = generate_roads(control_points, road_segments);
global.destination_road_index = array_length(road_list) - (road_segments * 2);
global.race_length = 0;

//set up building vertex buffer
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
building_vertex_format = vertex_format_end();
global.building_vertex_buffer = vertex_create_buffer();


// set up road node data
var lane_change_duration = 100; //how many nodes until change to new lane
var lane_change_to = 1+irandom(2); // change this side of road to this number of lanes
var cur_lane_change_to = lane_change_to; // current lane change for transition
var prev_lane_lane_to = lane_change_to; // previous lane change
var lane_side_affected = ROAD_LANE_CHANGE_AFFECT.BOTH; // which side of the road changes 
var cur_zone = choose(ZONE.CITY);
for (var i = 0; i < array_length(road_list)-1; i++) {
	var road = road_list[@i];
	var next_road = road_list[@i+1];
	road.next_road = next_road;
	road.direction = point_direction(road.x, road.y, next_road.x, next_road.y);
	road.length = sqrt(sqr(road.x - next_road.x) + sqr(road.y - next_road.y) + sqr(road.z - next_road.z));// point_distance(road.x, road.y, next_road.x, next_road.y);
	
	road.ideal_throttle = (road.length / (control_points_dist / road_segments))*(global.difficulty < 1 ? 0.75 : 1);
	road._id = i;
	road.lane_width = lane_width;
	road.zone = cur_zone;
	next_road.length_to_point = road.length_to_point + road.length;
	track_length += road.length;
	
	if (lane_change_to != cur_lane_change_to) {
		cur_lane_change_to += sign(lane_change_to - prev_lane_lane_to) * 0.5;
		road.transition_lane = true;
	}
	
	// road changes lane count
	if (lane_change_duration == 0) {
		prev_lane_lane_to = lane_change_to;
		lane_side_affected = choose(ROAD_LANE_CHANGE_AFFECT.LEFT, ROAD_LANE_CHANGE_AFFECT.RIGHT, ROAD_LANE_CHANGE_AFFECT.BOTH);
		lane_change_duration = 30+irandom(10);
		lane_change_to = 1+irandom(2);
		cur_zone = choose(ZONE.SUBURBAN, ZONE.CITY);
	}
	switch(lane_side_affected) {
		case ROAD_LANE_CHANGE_AFFECT.LEFT:
			road.set_lanes_left(cur_lane_change_to);
			road.set_lanes_right(road_list[@i-1].get_lanes_right());
			break;
		case ROAD_LANE_CHANGE_AFFECT.RIGHT:
			road.set_lanes_left(road_list[@i-1].get_lanes_left());
			road.set_lanes_right(cur_lane_change_to);
			break;
		case ROAD_LANE_CHANGE_AFFECT.BOTH:
			road.set_lanes_side(cur_lane_change_to);
			break;
	}
	lane_change_duration--;
}

// post road generation adjustments
for (var i = 0; i < array_length(road_list)-1; i++) {
	var road = road_list[@i];
	var next_road = road_list[@i+1];
	var lane_change_dist = 1000;
	
	// extend road if lane changes
	//if (road.get_lanes() != next_road.get_lanes()) {
	//	track_length += lane_change_dist;
	//	road.length += lane_change_dist;
	//	road.length_to_point += lane_change_dist;
	//	for (var j = i+1; j < array_length(road_list)-1; j++) {
	//		var r = road_list[@j];
	//		road_list[@j].x += lengthdir_x(lane_change_dist, road.direction);
	//		road_list[@j].y += lengthdir_y(lane_change_dist, road.direction);
	//		//road_list[@j].z += lengthdir_y(lane_change_dist, radtodeg(arcsin(road.elevation/road.length)));
	//	}
	//}
	
	// set road elevation
	road.elevation = arctan((road.z - next_road.z) / road.length);
}


road_points = []; // precalculate road polygons
// 3d road render data
vertex_format_begin();
if (global.CAMERA_MODE_3D) {vertex_format_add_position_3d();} else {vertex_format_add_position();}
vertex_format_add_color();
vertex_format_add_texcoord();
road_vertex_format = vertex_format_end();
road_vertex_buffers = vertex_create_buffer();


vertex_begin(global.building_vertex_buffer, building_vertex_format);
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
	var left_subimage = max(left_lanes, next_left_lanes)+4;
	var right_subimage = max(right_lanes, next_right_lanes)+1;
	var left_lane_sprite = (left_lanes != next_left_lanes) ? spr_road : spr_road;
	var right_lane_sprite = (right_lanes != next_right_lanes) ? spr_road : spr_road;
	var collision_points = [
		 [
			road.x+lengthdir_x(lane_width*(left_lanes + (road.shoulder[0] ? 1 : 0)), road.direction+90),
			next_road.x+lengthdir_x(lane_width*(next_left_lanes + (next_road.shoulder[0] ? 1 : 0)), next_road.direction+90),
			next_road.x+lengthdir_x(lane_width*(next_right_lanes + (next_road.shoulder[1] ? 1 : 0)), next_road.direction-90),
			road.x+lengthdir_x(lane_width*(right_lanes + (road.shoulder[1] ? 1 : 0)), road.direction-90),
		],
		[
			road.y+lengthdir_y(lane_width*(left_lanes + (road.shoulder[0] ? 1 : 0)), road.direction+90),
			next_road.y+lengthdir_y(lane_width*(next_left_lanes + (next_road.shoulder[0] ? 1 : 0)), next_road.direction+90),
			next_road.y+lengthdir_y(lane_width*(next_right_lanes+ (next_road.shoulder[1] ? 1 : 0)), next_road.direction-90),
			road.y+lengthdir_y(lane_width*(right_lanes + (road.shoulder[1] ? 1 : 0)), road.direction-90),
		]
	];
	var shoulder_uv = sprite_get_uvs(spr_road_shoulder, 0);
	var grass_uv = sprite_get_uvs(spr_grass, 0);
	switch(road.zone) {
		case ZONE.CITY:
			shoulder_uv = sprite_get_uvs(spr_road_shoulder, 1);
			grass_uv = sprite_get_uvs(spr_grass, 1);
			break;
	}
	
	if (road.transition_lane) {
		// create lane intersection
		shoulder_uv = sprite_get_uvs(spr_road_shoulder, 2);
		grass_uv = sprite_get_uvs(spr_road_side, 0);
		left_subimage = 0;
		right_subimage = 0;
		if (!next_road.transition_lane) {
			// far end
			grass_uv = sprite_get_uvs(spr_road_side, 2);
			left_subimage = 1;
			right_subimage = 1;
		}
	}
	else {
		if (next_road.transition_lane) {
			left_subimage = 1;
			right_subimage = 1;
		}
	}
	
	if (i == global.destination_road_index) {
		left_lane_sprite = spr_checkered;
		right_lane_sprite = spr_checkered;
		left_subimage = 0;
		right_subimage = 0;
		global.race_length = road.length_to_point;
	}
	
	var left_uv = texture_get_uvs(sprite_get_texture(left_lane_sprite, left_subimage));//sprite_get_uvs(left_lane_sprite, left_subimage);
	var right_uv = texture_get_uvs(sprite_get_texture(right_lane_sprite, right_subimage));//sprite_get_uvs(right_lane_sprite, right_subimage);
	
	var road_render_points = [
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
	
	#region Road Render Polygons
	var road_seg_data = [
		//left grass
		[new Point3D(road_render_points[0][0], road_render_points[1][0], road.z+5), new Point(grass_uv[0], grass_uv[1])],
		[new Point3D(road.x+lengthdir_x(beyond_shoulder_range, road.direction+90), road.y+lengthdir_y(beyond_shoulder_range, road.direction+90), road.z), new Point(grass_uv[0], grass_uv[3])],
		[new Point3D(road_render_points[0][1], road_render_points[1][1], next_road.z+5), new Point(grass_uv[2], grass_uv[1])],
		
		[new Point3D(road_render_points[0][1], road_render_points[1][1], next_road.z+5), new Point(grass_uv[2], grass_uv[1])],
		[new Point3D(road.x+lengthdir_x(beyond_shoulder_range, road.direction+90), road.y+lengthdir_y(beyond_shoulder_range, road.direction+90), road.z), new Point(grass_uv[0], grass_uv[3])],
		[new Point3D(next_road.x+lengthdir_x(beyond_shoulder_range, next_road.direction+90), next_road.y+lengthdir_y(beyond_shoulder_range, next_road.direction+90), next_road.z), new Point(grass_uv[2], grass_uv[3])],
	
		//left shoulder 
		[new Point3D(road_render_points[0][0], road_render_points[1][0], road.z), new Point(shoulder_uv[0], shoulder_uv[1])],
		[new Point3D(road.x+lengthdir_x(lane_width*(left_lanes+1), road.direction+90), road.y+lengthdir_y(lane_width*(left_lanes+1), road.direction+90), road.z), new Point(shoulder_uv[0], shoulder_uv[3])],
		[new Point3D(road_render_points[0][1], road_render_points[1][1], next_road.z), new Point(shoulder_uv[2], shoulder_uv[1])],
		
		[new Point3D(road_render_points[0][1], road_render_points[1][1], next_road.z), new Point(shoulder_uv[2], shoulder_uv[1])],
		[new Point3D(road.x+lengthdir_x(lane_width*(left_lanes+1), road.direction+90), road.y+lengthdir_y(lane_width*(left_lanes+1), road.direction+90), road.z), new Point(shoulder_uv[0], shoulder_uv[3])],
		[new Point3D(next_road.x+lengthdir_x(lane_width*(next_left_lanes+1), next_road.direction+90), next_road.y+lengthdir_y(lane_width*(next_left_lanes+1), next_road.direction+90), next_road.z), new Point(shoulder_uv[2], shoulder_uv[3])],
		
		//left road
		[new Point3D(road_render_points[0][0], road_render_points[1][0], road.z), new Point(left_uv[0], left_uv[3])],
		[new Point3D(road.x, road.y, road.z), new Point(left_uv[0], left_uv[1])],
		[new Point3D(road_render_points[0][1], road_render_points[1][1], next_road.z), new Point(left_uv[2], left_uv[3])],
		
		[new Point3D(road.x, road.y, road.z), new Point(left_uv[0], left_uv[1])],
		[new Point3D(road_render_points[0][1], road_render_points[1][1], next_road.z), new Point(left_uv[2], left_uv[3])],
		[new Point3D(next_road.x, next_road.y, next_road.z), new Point(left_uv[2], left_uv[1])],
		
		//righ road
		[new Point3D(road.x, road.y, road.z), new Point(right_uv[0], right_uv[1])],
		[new Point3D(road_render_points[0][3], road_render_points[1][3], road.z), new Point(right_uv[0], right_uv[3])],
		[new Point3D(next_road.x, next_road.y, next_road.z), new Point(right_uv[2], right_uv[1])],
		
		
		[new Point3D(road_render_points[0][3], road_render_points[1][3], road.z), new Point(right_uv[0], right_uv[3])],
		[new Point3D(next_road.x, next_road.y, next_road.z), new Point(right_uv[2], right_uv[1])],
		[new Point3D(road_render_points[0][2], road_render_points[1][2], next_road.z), new Point(right_uv[2], right_uv[3])],
		
		//right shoulder 
		[new Point3D(road_render_points[0][3], road_render_points[1][3], road.z), new Point(shoulder_uv[0], shoulder_uv[1])],
		[new Point3D(road.x+lengthdir_x(lane_width*(right_lanes+1), road.direction-90), road.y+lengthdir_y(lane_width*(next_right_lanes+1), road.direction-90), road.z), new Point(shoulder_uv[0], shoulder_uv[3])],
		[new Point3D(road_render_points[0][2], road_render_points[1][2], next_road.z), new Point(shoulder_uv[2], shoulder_uv[1])],
		
		[new Point3D(road_render_points[0][2], road_render_points[1][2], next_road.z), new Point(shoulder_uv[2], shoulder_uv[1])],
		[new Point3D(road.x+lengthdir_x(lane_width*(right_lanes+1), road.direction-90), road.y+lengthdir_y(lane_width*(next_right_lanes+1), road.direction-90), road.z), new Point(shoulder_uv[0], shoulder_uv[3])],
		[new Point3D(next_road.x+lengthdir_x(lane_width*(next_right_lanes+1), next_road.direction-90), next_road.y+lengthdir_y(lane_width*(next_right_lanes+1), next_road.direction-90), next_road.z), new Point(shoulder_uv[2], shoulder_uv[3])],
		
		// right grass
		[new Point3D(road_render_points[0][2], road_render_points[1][2], next_road.z+5), new Point(grass_uv[0], grass_uv[1])],
		[new Point3D(road.x+lengthdir_x(beyond_shoulder_range, road.direction-90), road.y+lengthdir_y(beyond_shoulder_range, road.direction-90), road.z), new Point(grass_uv[0], grass_uv[3])],
		[new Point3D(road_render_points[0][3], road_render_points[1][3], road.z+5), new Point(grass_uv[2], grass_uv[1])],
		
		[new Point3D(road_render_points[0][2], road_render_points[1][2], next_road.z+5), new Point(grass_uv[2], grass_uv[1])],
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
	
	// create speed limit sign
		
	if ((i % 100) == 0) {
		var prop_obj = instance_create_layer(
			collision_points[0][2],
			collision_points[1][2],
			"Instances",
			obj_traffic_prop
		);
		prop_obj.image_index = 0;
		prop_obj.z = road.z;
	}
	
	switch(road.zone) {
		// create building
		case ZONE.CITY:	
			if (!road.transition_lane) {
				// create buildings
				if ((i%2) == 0) {
					for (var j = -1; j <= 1; j += 2) {
						var func = undefined;
						var pos = [road.x, road.y];
						switch(j) {
							case -1:
								func = road.get_lanes_left;
								pos = [next_road.x, next_road.y];
								break;
							case 1:
								func = road.get_lanes_right;
								break;
						}
						var prop_obj = instance_create_layer(
							pos[0] + lengthdir_x((func() * lane_width + 256) * j , road.direction-90),
							pos[1] + lengthdir_y((func() * lane_width + 256) * j, road.direction-90),
							"Instances",
							obj_building
						);
						prop_obj.z = road.z;
						prop_obj.direction = road.direction + (j == -1 ? 180 : 0);
						prop_obj.building_width = road.length;
						prop_obj.building_height = 128;
						prop_obj.z_start = road.z;
						prop_obj.z_end = next_road.z;
						if (j == -1) {
							prop_obj.z_start = next_road.z;
							prop_obj.z_end = road.z;
						}
						prop_obj.init_vertex_buffer();
					}
				}
				// create city trees
				if ((i%4) == 0) {
					var begin_length = choose(
						lane_width*(left_lanes+0.5),
						-lane_width*(right_lanes+0.5),
					);
					var tree_obj = instance_create_layer(
						road.x + lengthdir_x(begin_length, road.direction + 90),
						road.y + lengthdir_y(begin_length, road.direction + 90),
						"Instances",
						obj_tree
					);
					tree_obj.image_index = choose(1,2);
					tree_obj.z = road.z;
				}
			}
			break;
		default:
			//create trees
			if (global.GAMEPLAY_TREES) {
				for (var tid = 0; tid < irandom(3); tid++) {
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
			break;
	}
}
vertex_end(road_vertex_buffers);
vertex_freeze(road_vertex_buffers);
vertex_end(global.building_vertex_buffer);
vertex_freeze(global.building_vertex_buffer);

global.road_list_length = array_length(road_list);

obj_controller.x = road_list[0].x;
obj_controller.y = road_list[0].y;

show_debug_message($"road generation completed in {current_time - t}ms");
show_debug_message($"Road has {array_length(road_points)} points");


vehicle_current_pos_ping = 0;