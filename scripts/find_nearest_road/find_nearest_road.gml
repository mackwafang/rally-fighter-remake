function find_nearest_road(_x, _y) {
	var dist = infinity;
	var index = -1;
	for (var i = 0; i < array_length(obj_road_generator.road_list); i++) {
		var road = obj_road_generator.road_list[i];
		var d = point_distance(_x, _y, road.x, road.y);
		if (d < dist) {
			dist = d;
			index = road.get_id();
		}
		else {
			break;
		}
	}
	return obj_road_generator.road_list[index];
}