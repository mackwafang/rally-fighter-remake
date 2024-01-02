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
if (abs(z-other.z) < 8) {
	switch(other.display_image_index) {
		case 0:
			hp *= _d;
			turn_rate *= _d * 2;
			break;
		case 1:
			zspeed -= velocity / mass / 30;
			break;
	}
	move_contact_all(dir - 180, 6);
}