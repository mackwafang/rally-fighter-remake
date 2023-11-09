
function point_to_line(A, B, pos) {
	/// @function			point_to_line(a, b, pos)
	/// @description		Get the point to intersect line AB at the perpendicular
	/// @param {vec2}		a point a
	/// @param {vec2}		b point b
	/// @param {vec2}		pos	position to check
	var ba = dist_on_line(A,B,pos);
	var line_dir = point_direction(A.x, A.y, B.x, B.y);
	var loc = new vec2(
		A.x + lengthdir_x(ba, line_dir),
		A.y + lengthdir_y(ba, line_dir),
	)
	return loc;
}