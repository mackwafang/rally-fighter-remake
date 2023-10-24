function camera_in_view(x, y, margin=64) {
	///@function			camera_in_view(x,y)
	///@description			check to see if point (x,y) is in camera
	///@param{float} x		x coordinate of object
	///@param{float} y		y coordinate of object
	///@param{float} margin	[optional] outside margin to extend areas
	
	var cam = view_camera[view_current];
	var cam_x = x-camera_get_view_x(cam);
	var cam_y = y-camera_get_view_y(cam);
	var within_x = (-margin < cam_x) && (cam_x < camera_get_view_width(cam)+margin);
	var within_y = (-margin < cam_y) && (cam_y < camera_get_view_height(cam)+margin);
	return within_x && within_y;
}