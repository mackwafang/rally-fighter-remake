function RoadNode(_vec2) constructor {
	x = _vec2.x;
	y = _vec2.y;
	direction = 0;
	vec = _vec2;
	lanes = [1, 0, 1]; // lanes [left, median , right]
	
	toString = function() {
		return $"({x}, {y}). Lanes {lanes}\n";
	}
	
	set_lanes_left = function(_lanes) {lanes[0] = _lanes;}
	set_lanes_right = function(_lanes) {lanes[2] = _lanes;}
	set_lanes_side = function(_lanes) {lanes[0] = _lanes; lanes[2] = _lanes;}
	
	get_lanes = function() {
		/// @function			get_lanes()
		/// @description		Return the total number of lanes this sector has
		/// @return {real}
		sum = 0;
		for (var i = 0; i < array_length(lanes); i++) {
			sum += lanes[i];
		}
		return sum;
	}
	
	get_lanes_left = function() {
		/// @function			get_lanes_left()
		/// @description		Return the number of left lanes
		/// @return {real}
		return lanes[0];
	}
	
	get_lanes_right = function() {
		/// @function			get_lanes_right()
		/// @description		Return the number of right lanes
		/// @return {real}
		return lanes[2];
	}
	
	get_lanes_middle = function() {
		/// @function			get_lanes_right()
		/// @description		Return the number of median lanes
		/// @return {real}
		return lanes[1];
	}
	
}

function cutmull_rom(P, t) {
	var tt = t*t;
	var ttt = tt*t;
	
	var px = P[1].x * 2;
	px += (-P[0].x + P[2].x) * t;
	px += ((2*P[0].x) - (5*P[1].x) + (4*P[2].x) - P[3].x) * tt;
	px += (-P[0].x + (3*P[1].x) - (3*P[2].x) + P[3].x) * ttt;
	
	var py = P[1].y * 2;
	py += (-P[0].y + P[2].y) * t;
	py += ((2*P[0].y) - (5*P[1].y) + (4*P[2].y) - P[3].y) * tt;
	py += (-P[0].y + (3*P[1].y) - (3*P[2].y) + P[3].y) * ttt;
	
	
	return new vec2(px / 2, py / 2);
}

function generate_roads(control_points, _steps) {
	/// @function								generate_roads(control_points, _steps, _primary_segment_dist)
	/// @description							Generate roads
	/// @param {array} control_points			array of control points
	/// @param {int} _steps						number of secondary points between primary points
	
	// initialize control points
	var P = control_points;
	var nP = array_length(control_points);
	
	_road_node_list = []; // hold the road nodes for rendering
	
	//calculate secondary points
	for (var i = 0; i < nP-3; i++) {
		var p = [];
		array_copy(p, 0, P, i, 4); // "array slice"
		for (var j = 0; j < _steps; j++) {
			var t = j/_steps;
			var point = new RoadNode(cutmull_rom(p, t));
			_road_node_list[array_length(_road_node_list)] = point;
		}
	}
	return _road_node_list;
}