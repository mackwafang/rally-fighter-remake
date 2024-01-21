var cam_obj = obj_controller.main_camera_target;
var nearest_cp = find_nearest_cp(cam_obj.x, cam_obj.y);
if (nearest_cp != current_cp) {
	vertex_delete_buffer(road_vertex_buffers);
	
	render_control_point(nearest_cp, 3);
	
	current_cp = nearest_cp;
}