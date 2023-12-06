function find_nearest_road(_x, _y, starting, offset=0) {
	// first, find nearest control point
	// we're effectively finding nearest chunk
	var closest_cp = -1;
	var closest_cp_dist = infinity;
	for (var ci = 0; ci < obj_road_generator.primary_count; ci++) {
		var p = obj_road_generator.control_points[ci];
		// var d = point_distance(_x, _y, p.x, p.y);
		var d = abs(_x - p.x) + abs(_y - p.y);
		if (d < closest_cp_dist) {
			closest_cp_dist = d;
			closest_cp = ci;
		}
	}
	
	// find nearest road segment based on visible chunks
	var closest_road = undefined;
	var closest_road_dist = infinity;
	var ri_start = max(0, (closest_cp - 2) * obj_road_generator.road_segments);
	var ri_end = min(global.road_list_length, max(1, closest_cp) * obj_road_generator.road_segments);
	for (var ri = ri_start; ri < ri_end; ri++ ) {
		var road = obj_road_generator.road_list[ri];
		// var d = point_distance(_x, _y, road.x, road.y);
		var d = abs(_x - road.x) + abs(_y - road.y);
		if (d < closest_road_dist) {
			closest_road_dist = d;
			closest_road = road;
		}
	}
	return closest_road;
}
