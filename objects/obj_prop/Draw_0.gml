var cam_target = obj_controller.main_camera_target;
if (point_distance(x, y, cam_target.x, cam_target.y) < 6000) {
	if (use_billboard) {shader_set(shd_sprite_billboard);}
	matrix_set(matrix_world, matrix);
	//vertex_submit(tree_vertex_buffer, pr_trianglelist, sprite_get_texture(sprite_index, image_index))
	draw_sprite(sprite_index, image_index, 0, 0);
	matrix_set(matrix_world, matrix_build_identity());
	if (use_billboard) {shader_reset();}
}