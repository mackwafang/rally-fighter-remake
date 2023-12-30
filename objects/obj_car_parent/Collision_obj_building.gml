var dist_to_building = point_distance(x, y, other.x, other.y);
var a = new Point(
	lengthdir_x(1, direction),
	lengthdir_y(1, direction)
);
var b = new Point(
	(other.x - x) / dist_to_building,
	(other.y - y) / dist_to_building
);
var _d = abs(dot_product(b.x, b.y, a.x, a.y));
hp *= _d;
turn_rate *= _d * 2;
move_contact_solid(dist_to_building - 180, 6);