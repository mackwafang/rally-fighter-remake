var cam_target = obj_controller.main_camera_target;
if (point_distance(x, y, cam_target.x, cam_target.y) < 4000) {
	shader_set(shd_sprite_billboard);
	matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, 0, 1, 1, 1));
	draw_sprite(sprite_index, image_index, 0, 0);
	matrix_set(matrix_world, matrix_build_identity());
	shader_reset();
}