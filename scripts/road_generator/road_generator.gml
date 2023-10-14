function RoadNode(_vec2) constructor {
	x = _vec2.x;
	y = _vec2.y;
	direction = 0;
	vec = _vec2;
	lanes = [1, 0, 1]; // lanes [left, median , right]
	
	toString = function() {
		return $"({x}, {y}). Lanes {lanes}\n";
	}
	
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
	
	get_left_lanes = function() {
		/// @function			get_left_lanes()
		/// @description		Return the number of left lanes
		/// @return {real}
		return lanes[0];
	}
	
	get_right_lanes = function() {
		/// @function			get_right_lanes()
		/// @description		Return the number of right lanes
		/// @return {real}
		return lanes[2];
	}
	
	get_middle_lanes = function() {
		/// @function			get_right_lanes()
		/// @description		Return the number of median lanes
		/// @return {real}
		return lanes[1];
	}
	
}

function bernstein_poly(i, n, t) {
	return ncr(n, i) * power(t,i) * (power(1 - t, n - i));
}

function bezier_n(_x, _y, _primary_segments, _steps, _primary_segment_dist=128) {
	/// @function								bezier_n(_x, _y, _primary_segments, _steps, _primary_segment_dist)
	/// @description							Generate roads
	/// @param {float} _x						x start of road
	/// @param {float} _y						y start of road
	/// @param {int} _primary_segments			number of primary points
	/// @param {int} _steps						number of secondary points between primary points
	
	//assert(_primary_segments > 20, "Model cannot handle more than 20 primary segments");
	
	_road_node_list = array_create(_primary_segments * _steps); // hold the road nodes for rendering
	
	var init_coord = vec2(_x, _y);
	
	// initialize control points
	var P = array_create(_primary_segments);
	var next_dir = 0;
	P[0] = new vec2(_x, _y);
	for (var s = 1; s < _primary_segments; s++) {
		show_debug_message(next_dir);
		P[s] = new vec2(
			P[s-1].x + (cos(degtorad(next_dir)) * _primary_segment_dist),
			P[s-1].y + (sin(degtorad(next_dir)) * _primary_segment_dist)
		);
		next_dir = irandom_range(-90, 90);
	}
	
	//calculate secondary points
	for (var i = 0; i < _steps * _primary_segments; i++) {
		var t = i / (_steps * _primary_segments);
		var p = new vec2();
		for (var s = 0; s < _primary_segments; s++) {
			p = p.add(P[@s].multiply(bernstein_poly(s, _primary_segments - 1, t)));
		}
		_road_node_list[i] = new RoadNode(p);
	}
	return _road_node_list;
}
	
function decasteljau(control_points, t=0.1) {
	/// @function			decasteljau(a, b)
	/// @description		calcuate the line from de casteljau's algorthim
	/// @param{array}		control_points	list of control points
	/// @param{float}		ratio t
	/// @return {vec2}
	if (array_length(control_points) == 1) {
		return control_points[0];
	}
	else {
		var new_cp = [];
		for (var i = 0; i < array_length(control_points) - 1; i++) {
			var a = control_points[i].multiply(1-t);
			var b = control_points[i+1].multiply(t);
			var lerp_point = a.add(b);
			new_cp = array_concat(new_cp, [lerp_point]);
		}
		return decasteljau(new_cp, t);
	}
}