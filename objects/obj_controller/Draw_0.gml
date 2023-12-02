matrix_set(matrix_world, matrix_build(main_camera_target.x, main_camera_target.y, 500, 0, 0, 0, 3, 3, 3));
var tex = sprite_get_texture(spr_cloud, 0);
vertex_submit(skybox_vertex_buffer, pr_trianglelist, tex);
matrix_set(matrix_world, matrix_build_identity());