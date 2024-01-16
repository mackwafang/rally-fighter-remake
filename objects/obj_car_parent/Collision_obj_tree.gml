var dir = point_distance(x, y, other.x, other.y);
var a = new Point(
	lengthdir_x(1, direction),
	lengthdir_y(1, direction)
);
var b = new Point(
	(other.x - x) / dir,
	(other.y - y) / dir
);
var _d = abs(dot_product(b.x, b.y, a.x, a.y));
hp *= _d;
turn_rate *= _d * 2;
zspeed -= velocity / mass / 30;
move_contact_all(dir, 1);