event_inherited();

var starting_road_seg = obj_road_generator.road_list[1 + irandom(2)];
var lane_position = irandom_range(-starting_road_seg.get_lanes_left(), starting_road_seg.get_lanes_right()) * 32;
x = starting_road_seg.x + lengthdir_x(lane_position, random(starting_road_seg.direction));
y = starting_road_seg.y + lengthdir_y(lane_position, random(starting_road_seg.direction));
direction = -starting_road_seg.direction;

image_index = irandom(sprite_get_number(sprite_index)-1);

horsepower = 1000;

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