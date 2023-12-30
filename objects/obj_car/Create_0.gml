event_inherited();

if (!ai_behavior.part_of_race) {
	vehicle_type = choose(VEHICLE_TYPE.CAR, VEHICLE_TYPE.BIKE);
}

if (vehicle_type == VEHICLE_TYPE.CAR) {
	vehicle_detail_subimage = irandom(sprite_get_number(spr_car_3d));
	if (!ai_behavior.part_of_race) {
		mass += 1000;
		horsepower += 100;
		max_hp += 300;
		hp += 300;
	}
}
vehicle_color = {
	primary: make_color_hsv(irandom(255), 128 + irandom(128), 128 + irandom(128)),
	secondary: make_color_hsv(irandom(255), 128 + irandom(128), 128 + irandom(128)),
	tetriary: make_color_hsv(irandom(255), 128 + irandom(128), 128 + irandom(128))
};