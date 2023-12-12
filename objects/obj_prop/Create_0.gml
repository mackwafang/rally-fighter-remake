z = 0;
image_index = irandom(image_number);
image_speed = 0;

tree_vertex_buffer = create_tree_vertex(sprite_index, image_index);
render_scale = {
	x: 1,
	y: 1,
	z: 1
}

matrix = matrix_build(0,0,0,0,0,0,0,0,0);
alarm[0] = 1;