function find_nearest_road(_x, _y) {
	var dist = infinity;
	var index = -1;
	for (var i = 0; i < array_length(obj_road_generator.road_list); i++) {
		var r = obj_road_generator.road_list[i];
		var d = point_distance(_x, _y, r.x, r.y);
		
		if (d > r.length* 2) {continue;}
		
		if (d < dist) {
			dist = d;
			index = r.get_id();
		}
		else {
			break;
		}
	}
	return obj_road_generator.road_list[min(array_length(obj_road_generator.road_list), max(0, index))];
}