var timescale = delta_time / 1000000;
var nearest_road = find_nearest_road(x, y, on_road_index);
zlerp = lerp(nearest_road.z, nearest_road.next_road.z, clamp(0, 1, (dist_along_road + (velocity / 60) - nearest_road.length_to_point) / nearest_road.length));
vertical_on_road = (z+zspeed >= zlerp);
if (vertical_on_road) {
	acceleration += cos(nearest_road.elevation);
	z = zlerp;
}
else {
	// FREE FALLIN
	zspeed += global.gravity_3d * timescale;
}
z += zspeed;
z = clamp(z, -500, zlerp);
// z -= sin(degtorad(nearest_road .next_road.elevation)) * velocity / 60;
if (z > nearest_road.next_road.z + 100) {hp = 0;}

// move car in direction
if (!is_respawning) {
	turn_rate += -turn_rate * 0.1;
	turn_rate = clamp(turn_rate, -4, 4);
	
	direction += turn_rate;
	x += cos(degtorad(direction)) * velocity * timescale / global.WORLD_TO_REAL_SCALE;
	y -= sin(degtorad(direction)) * velocity * timescale / global.WORLD_TO_REAL_SCALE;
	image_angle = direction;
}

velocity += acceleration * timescale;// * gear_ratio[gear-1];