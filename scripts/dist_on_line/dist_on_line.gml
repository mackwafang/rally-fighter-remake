function dist_on_line(A, B, pos) {
	/// @function			dist_on_line(a, b, pos)
	/// @description		Get the scalar projection distance from point A on line AB
	/// @param {Vec2}		a point a
	/// @param {Vec2}		b point b
	/// @param {Vec2}		pos	position to check
	var a = new Point(
		B.x - A.x,
		B.y - A.y
	);
	var b = new Point(
		pos.x - A.x,
		pos.y - A.y
	);
	var line_dir = point_direction(A.x, A.y, B.x, B.y);
	var length_a = sqrt((a.x*a.x) + (a.y*a.y));
	var length_b = sqrt((b.x*b.x) + (b.y*b.y));
	var a_hat = new Point(
		a.x / length_a,
		a.y / length_a
	);
	var ba = dot_product(b.x, b.y, a_hat.x, a_hat.y);
	return ba;
}