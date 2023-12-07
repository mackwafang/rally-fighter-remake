event_inherited();

image_index = irandom(sprite_get_number(sprite_index)-1);

vehicle_type = choose(VEHICLE_TYPE.CAR, VEHICLE_TYPE.BIKE);
vehicle_color = {
	primary: make_color_hsv(irandom(255), 128 + irandom(128), 128 + irandom(128)),
	secondary: make_color_hsv(irandom(255), 128 + irandom(128), 128 + irandom(128)),
	tetriary: make_color_hsv(irandom(255), 128 + irandom(128), 128 + irandom(128))
};