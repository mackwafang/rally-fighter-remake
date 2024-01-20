z = 0;
z_end = 0;
height = 32;
length = 0;
image_alpha = 0;

init_vertex_buffer = function() {
	var x0 = x;
	var y0 = y;
	var x1 = x + lengthdir_x(length, direction);
	var y1 = y + lengthdir_y(length, direction);
		
	var uv = sprite_get_uvs(spr_railing, 0);
		
	vertex_position_3d_uv(global.building_vertex_buffer, x1, y1, z_end - height, uv[0], uv[1]);
	vertex_position_3d_uv(global.building_vertex_buffer, x0, y0, z - height, uv[2], uv[1]);
	vertex_position_3d_uv(global.building_vertex_buffer, x1, y1, z_end, uv[0], uv[3]);
		
	vertex_position_3d_uv(global.building_vertex_buffer, x0, y0, z - height, uv[2], uv[1]);
	vertex_position_3d_uv(global.building_vertex_buffer, x0, y0, z, uv[2], uv[3]);
	vertex_position_3d_uv(global.building_vertex_buffer, x1, y1, z_end, uv[0], uv[3]);
}