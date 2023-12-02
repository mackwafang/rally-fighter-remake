function vertex_position_3d_uv(buffer, _x, _y, _z, _u, _v) {
	/// @function		vertex_position_3d_uv(buffer, x, y, z, u, v)
	vertex_position_3d(buffer, _x, _y, _z);
	vertex_color(buffer, c_white, 1);
	vertex_texcoord(buffer, _u, _v);
}