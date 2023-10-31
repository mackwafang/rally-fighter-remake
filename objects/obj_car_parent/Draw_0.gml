draw_sprite_ext(spr_car, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_sprite_ext(spr_car_detail, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

if (accelerating) {draw_circle_color(x+8, y-10, 4, c_green, c_green, false);}
if (boosting) {draw_circle_color(x, y-10, 4, c_yellow, c_yellow, false);}
if (braking) {draw_circle_color(x-8, y-10, 4, c_red, c_red, false);}

draw_arrow(x, y, x+lengthdir_x(engine_power * 32, image_angle), y+lengthdir_y(engine_power * 32, image_angle), 10);

if (turning != 0) {
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_center);
	draw_arrow(x, y, x+lengthdir_x(turn_rate * 32, image_angle+90), y+lengthdir_y(turn_rate * 32, image_angle+90), 10);
}