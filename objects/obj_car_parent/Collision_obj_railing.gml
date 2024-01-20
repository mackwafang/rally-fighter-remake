if (abs(z-other.z) <= other.height) {
	var dist_to_building = point_distance(x, y, other.x, other.y);
	var a = new Point(
		lengthdir_x(1, direction),
		lengthdir_y(1, direction)
	);
	var b = new Point(
		(other.x - x) / dist_to_building,
		(other.y - y) / dist_to_building
	);
	var _d = clamp(abs(dot_product(b.x, b.y, a.x, a.y)), 0, 1);
	hp -= 0.001;
	if (abs(_d) < 0.25) {
		hp = max_hp * abs(_d); 
	}
	move_and_collide(dcos(direction) * velocity, -dsin(direction) * velocity, obj_railing, 4, 0, 0, 1, 1);
}