
function dist_to_line(A, B, pos) {
	/// @function dist_to_line(a, b, pos)
	/// @description Get the distance to intersect line AB at the perpendicular
	/// @param {vec2}		a point a
	/// @param {vec2}		b point b
	/// @param {vec2}		pos	position to check
	var a = new vec2(
		B.x - A.x,
		B.y - A.y,
	);
	var b = new vec2(
		pos.x - A.x,
		pos.y - A.y,
	);
	var length_a = a.length();
	var length_b = b.length();
	var theta = point_direction(A.x, A.y, pos.x, pos.y);
	var a_scalar = length_b * cos(degtorad(theta));
	var b_projection = a_scalar / length_a;
	var loc = new vec2(
		A.x + lengthdir_x(length_b * b_projection, point_direction(A.x, A.y, B.x, B.y)),
		A.y + lengthdir_y(length_b * b_projection, point_direction(A.x, A.y, B.x, B.y)),
	);
	
	return loc;
}