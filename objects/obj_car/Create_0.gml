event_inherited();

var starting_road_seg = obj_road_generator.road_list[10];
x = starting_road_seg.x + irandom_range(-64, 64);
y = starting_road_seg.y + irandom_range(-64, 64);
direction = -starting_road_seg.direction;

image_index = irandom(sprite_get_number(sprite_index)-1);