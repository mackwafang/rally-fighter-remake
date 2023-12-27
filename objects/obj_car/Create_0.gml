event_inherited();


vehicle_type = choose(VEHICLE_TYPE.CAR, VEHICLE_TYPE.BIKE);
switch(vehicle_type) {
	case VEHICLE_TYPE.CAR:
		image_index = irandom(sprite_get_number(spr_car_3d)-1);
		if (!ai_behavior.part_of_race) {
			mass += 1000;
			horsepower += 100;
			max_hp += 300;
			hp += 300;
		}
		break;
}
vehicle_color = {
	primary: make_color_hsv(irandom(255), 128 + irandom(128), 128 + irandom(128)),
	secondary: make_color_hsv(irandom(255), 128 + irandom(128), 128 + irandom(128)),
	tetriary: make_color_hsv(irandom(255), 128 + irandom(128), 128 + irandom(128))
};