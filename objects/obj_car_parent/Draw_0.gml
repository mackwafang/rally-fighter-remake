if (vehicle_type == VEHICLE_TYPE.BIKE) {
	draw_sprite_ext(spr_vehicle_shadow, 0, x, y, image_xscale, image_yscale, image_angle, c_white, 0.5);
}
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_sprite_ext(vehicle_detail_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);

//draw_arrow(x, y, x+lengthdir_x(push_vector.x, image_angle), y+lengthdir_y(push_vector.x, image_angle), 10);
//draw_arrow(x, y, x+lengthdir_x(push_vector.y, image_angle-90), y+lengthdir_y(push_vector.y, image_angle-90), 10);

if (global.DEBUG_CAR) {
	if (accelerating) {draw_circle_color(x+8, y-10, 4, c_green, c_green, false);}
	if (boosting) {draw_circle_color(x, y-10, 4, c_yellow, c_yellow, false);}
	if (braking) {draw_circle_color(x-8, y-10, 4, c_red, c_red, false);}
	
	
	draw_text_transformed_color(x + lengthdir_x(16, image_angle+180),y + lengthdir_y(16, image_angle+180),round(velocity / 10),1,1,image_angle-90,c_white,c_white,c_white,c_white,1)
	draw_text_transformed_color(x + lengthdir_x(32, image_angle+180),y + lengthdir_y(32, image_angle+180),gear,1,1,image_angle-90,c_white,c_white,c_white,c_white,1)
	draw_text_transformed_color(x + lengthdir_x(48, image_angle+180),y + lengthdir_y(48, image_angle+180),round(engine_rpm),1,1,image_angle-90,c_white,c_white,c_white,c_white,1)

	draw_arrow(x, y, x+lengthdir_x(engine_power * 32, image_angle), y+lengthdir_y(engine_power * 32, image_angle), 10);
	draw_arrow(x, y, x+lengthdir_x(turn_rate * 32, image_angle+90), y+lengthdir_y(turn_rate * 32, image_angle+90), 10);
	draw_text_transformed_color(x+lengthdir_x(turn_rate * 32, image_angle+90), y+lengthdir_y(turn_rate * 32, image_angle+90),turn_rate,1,1,image_angle-90,c_white,c_white,c_white,c_white,1)

	if (!on_road) {
		draw_text_transformed_color(
			x + lengthdir_x(-16, image_angle+90),
			y + lengthdir_y(-16, image_angle+90),
			"!",
			2,
			2,
			image_angle-90,
			c_red,
			c_red,
			c_red,
			c_red,
			1
		)
	}
}