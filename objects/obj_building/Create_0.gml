z = 0;
image_speed = 0;
image_index = irandom(image_number);

building_height = 256;
building_width= 32;
z_start = 0;
z_end = -32;

vertex_format_begin();

vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
building_vertex_format = vertex_format_end();
building_vertex_buffer = vertex_create_buffer();

function init_vertex_buffer() {
	z_start -= z;
	z_end -= z;
	
	matrix = matrix_build(x, y, z, 0, 0, direction, 1, 1, 1);

	var uv = sprite_get_uvs(spr_building_side, 0);
	var building_uv = sprite_get_uvs(spr_building_front, image_index);
	vertex_begin(building_vertex_buffer, building_vertex_format);
	
	//bottom
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start, uv[0], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, -128, z_end, uv[2], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, 0, 128, z_start, uv[0], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start, uv[0], uv[1]);

	//top
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start-building_height, uv[0], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, 0, 128, z_start-building_height, uv[0], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end-building_height, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end-building_height, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, -128, z_end-building_height, uv[2], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start-building_height, uv[0], uv[1]);

	// +y
	vertex_position_3d_uv(building_vertex_buffer, 0, 128, z_start-building_height, uv[0], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, 0, 128, z_start, uv[0], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end-building_height, uv[2], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, 0, 128, z_start-building_height, uv[0], uv[1]);

	// -y
	vertex_position_3d_uv(building_vertex_buffer, building_width, -128, z_end-building_height, building_uv[0], building_uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, -128, z_end, building_uv[0], building_uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start, building_uv[2], building_uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start, building_uv[2], building_uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start-building_height, building_uv[2], building_uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, -128, z_end-building_height, building_uv[0], building_uv[1]);

	// -x
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start-building_height, uv[0], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start, uv[0], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, 0, 128, z_start, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, 0, 128, z_start, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, 0, 128, z_start-building_height, uv[2], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, 0, -128, z_start-building_height, uv[0], uv[1]);

	// +x
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end-building_height, uv[0], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end, uv[0], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, -128, z_end, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, -128, z_end, uv[2], uv[3]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, -128, z_end-building_height, uv[2], uv[1]);
	vertex_position_3d_uv(building_vertex_buffer, building_width, 128, z_end-building_height, uv[0], uv[1]);
	
	vertex_end(building_vertex_buffer);
	vertex_freeze(building_vertex_buffer);
}