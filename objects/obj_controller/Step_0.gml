if (keyboard_check(ord("W"))) {y -= cam_move_speed;}
if (keyboard_check(ord("S"))) {y += cam_move_speed;}
if (keyboard_check(ord("A"))) {x -= cam_move_speed;}
if (keyboard_check(ord("D"))) {x += cam_move_speed;}
if (mouse_wheel_up()) {cam_zoom -= 0.1;}
if (mouse_wheel_down()) {cam_zoom += 0.1;}

cam_zoom = clamp(cam_zoom, 0.1, 10);
camera_set_view_pos(view_camera[0], x, y);
camera_set_view_size(view_camera[0], view_wport / cam_zoom, view_hport / cam_zoom);