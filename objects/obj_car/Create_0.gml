event_inherited();

var starting_road_seg = obj_road_generator.road_list[10];
x = starting_road_seg.x;
y = starting_road_seg.y;
direction = -starting_road_seg.direction;

image_index = irandom(sprite_get_number(sprite_index)-1);

horsepower = 200;

gear_shift_rpm = [
	[0, 5000],
	[3000, 6250],
]