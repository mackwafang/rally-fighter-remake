var cam_target = obj_controller.main_camera_target;
if (point_distance(x, y, cam_target.x, cam_target.y) < 6000) {
	matrix_set(matrix_world, matrix);
	var tex = sprite_get_texture(spr_building_side, 0);
	vertex_submit(building_vertex_buffer, pr_trianglelist, tex);
	matrix_set(matrix_world, matrix_build_identity());
}