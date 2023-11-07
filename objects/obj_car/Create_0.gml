event_inherited();

image_index = irandom(sprite_get_number(sprite_index)-1);

horsepower = 200;

//gear_shift_rpm = [
//	[0, 5000],
//	[3000, 6250],
//]

//gear_shift_rpm = [
//	[0, 7000],
//	[3000, 6250],
//	[3500, 6000],
//	[4000, 6000],
//	[3000, 4500],
//	[1100, 3000],
//]

vehicle_type = choose(VEHICLE_TYPE.CAR, VEHICLE_TYPE.BIKE);
vehicle_color = make_color_rgb(irandom(255), irandom(255), irandom(255));