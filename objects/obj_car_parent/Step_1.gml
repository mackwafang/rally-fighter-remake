var vel = (velocity * 0.75) * global.deltatime / global.WORLD_TO_REAL_SCALE;
var nearest_road = find_nearest_road(
	x,
	y,
	on_road_index
);
var lerp_value = (dist_along_road - nearest_road.length_to_point) / nearest_road.length;
zlerp = lerp(nearest_road.z, nearest_road.next_road.z, lerp_value);
zlerp = max(zlerp, lerp(on_road_index.z, on_road_index.next_road.z, (dist_along_road - on_road_index.length_to_point) / nearest_road.length));
vertical_on_road = (z+zspeed >= zlerp);
if (vertical_on_road) {
	drive_force -= sin(nearest_road.elevation) * global.gravity_3d * mass;
	z = zlerp;
}
else {
	// FREE FALLING
	zspeed += global.gravity_3d * global.deltatime;
}
z += zspeed;
z = clamp(z, -500, zlerp);
// z -= sin(degtorad(nearest_road .next_road.elevation)) * velocity / 60;
if (z > nearest_road.next_road.z + 100) {hp = 0;}

// move car in direction
if (!is_respawning) {
	turn_rate += -turn_rate * 0.1;
	turn_rate = clamp(turn_rate, -6, 6);
	
	direction += turn_rate;
	x += cos(degtorad(direction)) * vel;
	y -= sin(degtorad(direction)) * vel;
	image_angle = direction;
}

velocity += acceleration * global.deltatime;// * gear_ratio[gear-1];