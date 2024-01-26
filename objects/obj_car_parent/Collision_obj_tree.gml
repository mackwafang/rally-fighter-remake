var dist = max(1, point_distance(x, y, other.x, other.y));
var a = new Point(
	lengthdir_x(1, direction),
	lengthdir_y(1, direction)
);
var b = new Point(
	(other.x - x) / dist,
	(other.y - y) / dist
);
var _d = dot_product(b.x, b.y, a.x, a.y);
hp *= abs(_d);
turn_rate *= abs(_d) * 2;
zspeed -= velocity / mass / 30;
move_contact_all(arccos(_d), 1);