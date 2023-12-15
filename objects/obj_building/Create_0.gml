z = 0;
image_speed = 0;
image_index = irandom(image_number);

building_height = 256;

vertex_format_begin();

vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
var building_vertex_format = vertex_format_end();
building_vertex_buffer = vertex_create_buffer();
var uv = sprite_get_uvs(spr_building_side, 0);
var building_uv = sprite_get_uvs(spr_building_front, image_index);
vertex_begin(building_vertex_buffer, building_vertex_format);
	
//bottom
vertex_position_3d_uv(building_vertex_buffer, -128, -128, 32, uv[0], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, 128, -128, 32, uv[2], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, 128, 128, 32, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, 128, 32, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, -128, 128, 32, uv[0], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, -128, -128, 32, uv[0], uv[1]);

//top
vertex_position_3d_uv(building_vertex_buffer, -128, -128, -building_height, uv[0], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, -128, 128, -building_height, uv[0], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, 128, -building_height, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, 128, -building_height, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, -128, -building_height, uv[2], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, -128, -128, -building_height, uv[0], uv[1]);

// +y
vertex_position_3d_uv(building_vertex_buffer, -128, 128, -building_height, uv[0], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, -128, 128, 32, uv[0], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, 128, 32, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, 128, 32, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, 128, -building_height, uv[2], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, -128, 128, -building_height, uv[0], uv[1]);

// -y
vertex_position_3d_uv(building_vertex_buffer, 128, -128, -building_height, building_uv[0], building_uv[1]);
vertex_position_3d_uv(building_vertex_buffer, 128, -128, 32, building_uv[0], building_uv[3]);
vertex_position_3d_uv(building_vertex_buffer, -128, -128, 32, building_uv[2], building_uv[3]);
vertex_position_3d_uv(building_vertex_buffer, -128, -128, 32, building_uv[2], building_uv[3]);
vertex_position_3d_uv(building_vertex_buffer, -128, -128, -building_height, building_uv[2], building_uv[1]);
vertex_position_3d_uv(building_vertex_buffer, 128, -128, -building_height, building_uv[0], building_uv[1]);

// -x
vertex_position_3d_uv(building_vertex_buffer, -128, -128, -building_height, uv[0], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, -128, -128, 32, uv[0], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, -128, 128, 32, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, -128, 128, 32, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, -128, 128, -building_height, uv[2], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, -128, -128, -building_height, uv[0], uv[1]);

// +x
vertex_position_3d_uv(building_vertex_buffer, 128, 128, -building_height, uv[0], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, 128, 128, 32, uv[0], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, -128, 32, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, -128, 32, uv[2], uv[3]);
vertex_position_3d_uv(building_vertex_buffer, 128, -128, -building_height, uv[2], uv[1]);
vertex_position_3d_uv(building_vertex_buffer, 128, 128, -building_height, uv[0], uv[1]);
	
vertex_end(building_vertex_buffer);
vertex_freeze(building_vertex_buffer);
alarm[0] = 1;