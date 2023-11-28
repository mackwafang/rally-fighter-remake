function init_bike_shadow_buffer() {
	global.bike_shadow_buffer = {
		buffer: vertex_create_buffer(),
		format: undefined
	};
	
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_color();
	vertex_format_add_texcoord();
	global.bike_shadow_buffer.format = vertex_format_end();
	
	var uv = sprite_get_uvs(spr_bike_shadow_simple, 0);
	
	vertex_begin(global.bike_shadow_buffer.buffer, global.bike_shadow_buffer.format);
	vertex_position_3d(global.bike_shadow_buffer.buffer, 0, 0, 0);
	vertex_color(global.bike_shadow_buffer.buffer, c_gray, 0.5);
	vertex_texcoord(global.bike_shadow_buffer.buffer, uv[0], uv[1]);
	
	vertex_position_3d(global.bike_shadow_buffer.buffer, 64, 0, 0);
	vertex_color(global.bike_shadow_buffer.buffer, c_gray, 0.5);
	vertex_texcoord(global.bike_shadow_buffer.buffer, uv[2], uv[1]);
	
	vertex_position_3d(global.bike_shadow_buffer.buffer, 0, 64, 0);
	vertex_color(global.bike_shadow_buffer.buffer, c_gray, 0.5);
	vertex_texcoord(global.bike_shadow_buffer.buffer, uv[0], uv[3]);
	
	vertex_position_3d(global.bike_shadow_buffer.buffer, 64, 64, 0);
	vertex_color(global.bike_shadow_buffer.buffer, c_gray, 0.5);
	vertex_texcoord(global.bike_shadow_buffer.buffer, uv[2], uv[3]);
	
	vertex_end(global.bike_shadow_buffer.buffer);
	vertex_freeze(global.bike_shadow_buffer.buffer);
}