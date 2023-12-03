zlerp = lerp(on_road_index.z, on_road_index.next_road.z, (dist_along_road - on_road_index.length_to_point) / on_road_index.length);
vertical_on_road = (z+zspeed >= zlerp);
if (vertical_on_road) {
	//velocity *= cos(degtorad(on_road_index.elevation));
	z = zlerp;
}
else {
	// FREE FALLIN
	zspeed += global.gravity_3d / 40;
}
z += zspeed;
z = clamp(z+zspeed, -500, zlerp);
// z -= sin(degtorad(on_road_index.next_road.elevation)) * velocity / 60;
if (z > on_road_index.next_road.z + 100) {hp = 0;}