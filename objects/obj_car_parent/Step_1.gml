zlerp = lerp(on_road_index.z, on_road_index.next_road.z, (dist_along_road+(velocity / 60) - on_road_index.length_to_point) / on_road_index.length);
vertical_on_road = (z+zspeed >= zlerp);
if (vertical_on_road) {
	drive_force *= cos(on_road_index.elevation);
	z = zlerp;
}
else {
	// FREE FALLIN
	zspeed += global.gravity_3d / 40;
}
z += zspeed;
z = clamp(z, -500, zlerp);
// z -= sin(degtorad(on_road_index.next_road.elevation)) * velocity / 60;
if (z > on_road_index.next_road.z + 100) {hp = 0;}

// move car in direction
if (!is_respawning) {
	turn_rate += -turn_rate * 0.1;
	turn_rate = clamp(turn_rate, -4, 4);
	
	direction += turn_rate;
	x += cos(degtorad(direction)) * velocity / 60;
	y -= sin(degtorad(direction)) * velocity / 60;
	// if (vertical_on_road) {z -= tan(degtorad(on_road_index.elevation)) * velocity / 60;}
	image_angle = direction;
}