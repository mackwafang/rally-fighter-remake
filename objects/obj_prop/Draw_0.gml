var cam_target = obj_controller.main_camera_target;
if (point_distance(x, y, cam_target.x, cam_target.y) < 6000) {
	if (use_billboard) {shader_set(shd_sprite_billboard);}
	matrix_set(matrix_world, matrix);
	//vertex_submit(tree_vertex_buffer, pr_trianglelist, sprite_get_texture(sprite_index, image_index))
	if (use_billboard) {
		shader_set_uniform_f(global.color_replace_replace_color, false);
	}
	draw_sprite_ext(display_sprite_index, display_image_index, 0, 0, 1, -1, 0, image_blend, image_alpha);
	matrix_set(matrix_world, identity_matrix);
	if (use_billboard) {shader_reset();}
}