function find_nearest_road(_x, _y, starting, offset=0) {
	var dist = infinity;
	var index = -1;
	var i = starting;
	while(i++ < global.road_list_length-1) {
		var r = obj_road_generator.road_list[i];
		var d = point_distance(_x, _y, r.x, r.y);
		
		if (d > 512) {continue;}
		
		if (d < dist) {
			dist = d;
			index = r.get_id();
		}
		else {
			break;
		}
	}
	return obj_road_generator.road_list[min(array_length(obj_road_generator.road_list)-1, max(0, index))+offset];
}