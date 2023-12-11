function create_tree_vertex(spr_index, img_index) {
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_color();
	vertex_format_add_texcoord();
	var tree_vertex_format = vertex_format_end();
	var tree_vertex_buffer = vertex_create_buffer();
	var uv = sprite_get_uvs(spr_index, img_index);
	vertex_begin(tree_vertex_buffer, tree_vertex_format);
	
	vertex_position_3d_uv(tree_vertex_buffer, 128, 0, 0, uv[2], uv[3]);
	vertex_position_3d_uv(tree_vertex_buffer, -128, 0, 0, uv[0], uv[3]);
	vertex_position_3d_uv(tree_vertex_buffer, -128, -256, 0, uv[0], uv[1]);
	
	vertex_position_3d_uv(tree_vertex_buffer, -128, -256, 0, uv[0], uv[1]);
	vertex_position_3d_uv(tree_vertex_buffer, 128, 0, 0, uv[2], uv[3]);
	vertex_position_3d_uv(tree_vertex_buffer, 128, -256, 0, uv[2], uv[1]);
	
	vertex_end(tree_vertex_buffer);
	vertex_freeze(tree_vertex_buffer);
	return tree_vertex_buffer;
}