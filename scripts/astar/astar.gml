
function a_star_heuristic(node, _end, width) {
	var node_x = node % width;
	var node_y = node div width;
	var goal_x = _end % width;
	var goal_y = _end div width;
	return sqrt((sqr(node_x - goal_x)) + (sqr(node_y - goal_y)));
}

function a_star(_grid, _start, _end, width, _h) {
	/// @function		a_star(_start, _end, width, _h)
	/// @param _grid	graph (expects a ds_grid)
	/// @param _start	start grid
	/// @param _end		end grid
	/// @param _h		hueristic function pointer
	/// @param width	width of grid
	
	var frontier = ds_priority_create();
	var searched = ds_list_create();
	var parent = ds_list_create();
	var g = ds_list_create();
	for (var i = 0; i < ds_list_size(_grid); i++) {
		ds_list_add(searched, false);
		ds_list_add(parent, -1);
		ds_list_add(g, -1);
	}
	ds_priority_add(frontier, _start, 0);

	
	while (ds_priority_find_min(frontier) != _end) {
		var current = ds_priority_delete_min(frontier); // remove from queue
		searched[|current] = true; //  add to search
		
		// finding neighbors
		var neighbor_index = [-1, 1, -width, width];
		if (current % width == 0) {
			neighbor_index = [1, -width, width];
		}
		if (current % width == width-1) {
			neighbor_index = [-1, -width, width];
		}
		
		var neighbors = ds_list_create();
		for (var ni = 0; ni < array_length(neighbor_index); ni++) {
			var n = current + neighbor_index[ni];
			if (0 <= n && n < ds_list_size(_grid)) {
				ds_list_add(neighbors, n);
			}
		}
		
		// for each neighbors
		for (var ni = 0; ni < ds_list_size(neighbors); ni++) {
			var n = neighbors[|ni];
			var cost = g[|current] + abs(_grid[|n] - _grid[|current]);
			
			if ((ds_priority_find_priority(frontier, n) != undefined) && (cost < g[|n])) {
				// new path is better
				ds_priority_delete_value(frontier, n);
			}
			
			if (searched[|n] && (cost < g[|n])) {
				searched[|n] = false;
			}
			
			if ((ds_priority_find_priority(frontier, n) == undefined) && !searched[|n]) {
				g[|n] = cost;
				ds_priority_add(frontier, n, g[|n] + _h(n, _end, width));
				parent[|n] = current;
			}
		}
		// post process
		ds_list_destroy(neighbors);
	}
	
	var path = [];
	var cur = parent[|_end];
	while (true) {
		path[array_length(path)] = cur;
		cur = parent[|cur];
		if (cur == _start) {break;}
	}
	path[array_length(path)] = _start;
	return path;
}