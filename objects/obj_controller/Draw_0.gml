matrix_set(matrix_world, matrix_build(main_camera_target.x, main_camera_target.y, main_camera_target.z + 1000, 0, 0, 0, 5, 5, 5));
var tex = sprite_get_texture(spr_cloud, 0);
vertex_submit(skybox_vertex_buffer, pr_trianglelist, tex);
matrix_set(matrix_world, matrix_build_identity());