function RoadNode(_vec2) constructor {
	x = _vec2.x;
	y = _vec2.y;
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

function generate_road(_x, _y, _primary_segments, _steps) {
	/// @function							generate_road(length)
	/// @description						generate road, starting at coordiante _x, _y
	/// @param {float} _x					world x coordinate
	/// @param {float} _y					world y coordinate
	/// @param {int} primary_segments		number of primary segments to create
	/// @param {int} steps					number of steps per primary segments
	/// @return {Array}						array of road nodes
	
	_road_node_list = array_create(_primary_segments * _steps); // hold the road nodes for rendering
	
	var init_coord = vec2(_x, _y);
	
	var P = array_create(_primary_segments);
	
	for (var s = 0; s < _primary_segments; s++) {
		//P[s] = new vec2(64 * (s + 1), irandom_range(-64, 64));
		P[s] = new vec2(256 * s, irandom_range(-128, 128));
	}
		
	for (var i = 0; i < _steps * _primary_segments; i++) {
		var t = i / (_steps * _primary_segments);
		var p = P[0].multiply(power(1 - t, 3));
		p = p.add(P[1].multiply(3 * sqr(1 - t) * t));
		p = p.add(P[2].multiply(3 * (1 - t) * sqr(t)));
		p = p.add(P[3].multiply(power(t, 3)));
			
		_road_node_list[i] = new RoadNode(p);
	}
	return _road_node_list;
}