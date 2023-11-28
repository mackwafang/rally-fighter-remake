// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_bike_shadow_buffer()	{
	global.bike_shadow = {
		buffer: vertex_create_buffer(),
		format: undefined,
	}
	var w = 12;
	var h = 16;
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_color();
	vertex_format_add_texcoord();
	global.bike_shadow.format = vertex_format_end();
	
	var uv = sprite_get_uvs(spr_bike_shadow_simple, 0);
	
	vertex_begin(global.bike_shadow.buffer, global.bike_shadow.format);
	
	vertex_position_3d(global.bike_shadow.buffer, -w/2, -h/2, 0);
	vertex_color(global.bike_shadow.buffer, c_black, 0.5);
	vertex_texcoord(global.bike_shadow.buffer, uv[0], uv[1]);
	
	vertex_position_3d(global.bike_shadow.buffer, w/2, -h/2, 0);
	vertex_color(global.bike_shadow.buffer, c_black, 0.5);
	vertex_texcoord(global.bike_shadow.buffer, uv[0], uv[3]);
	
	vertex_position_3d(global.bike_shadow.buffer, -w/2, h/2, 0);
	vertex_color(global.bike_shadow.buffer, c_black, 0.5);
	vertex_texcoord(global.bike_shadow.buffer, uv[2], uv[1]);
	
	vertex_position_3d(global.bike_shadow.buffer, w/2, h/2, 0);
	vertex_color(global.bike_shadow.buffer, c_black, 0.5);
	vertex_texcoord(global.bike_shadow.buffer, uv[2], uv[3]);
	
	vertex_end(global.bike_shadow.buffer);
	vertex_freeze(global.bike_shadow.buffer);
}