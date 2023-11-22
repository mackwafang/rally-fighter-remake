function dist_on_line(A, B, pos) {
	/// @function			dist_on_line(a, b, pos)
	/// @description		Get the scalar projection distance from point A on line AB
	/// @param {Vec2}		a point a
	/// @param {Vec2}		b point b
	/// @param {Vec2}		pos	position to check
	var a = new Vec2(
		B.x - A.x,
		B.y - A.y,
	);
	var b = new Vec2(
		pos.x - A.x,
		pos.y - A.y,
	);
	var line_dir = point_direction(A.x, A.y, B.x, B.y);
	var length_a = a.length();
	var length_b = b.length();
	var a_hat = new Vec2(
		a.x / length_a,
		a.y / length_a
	);
	var ba = dot_product(b.x, b.y, a_hat.x, a_hat.y);
	return ba;
}