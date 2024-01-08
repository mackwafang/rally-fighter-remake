if (global.game_state_paused) {exit;}
var vel = (velocity) * global.deltatime / global.WORLD_TO_REAL_SCALE;
var vec_to_road = point_to_line(
	new Point(on_road_index.x, on_road_index.y),
	new Point(on_road_index.next_road.x, on_road_index.next_road.y),
	new Point(x, y)
);
var lerp_value = point_distance(on_road_index.x, on_road_index.y, vec_to_road.x, vec_to_road.y) / on_road_index.length;
zlerp = lerp(on_road_index.z, on_road_index.next_road.z, lerp_value);
vertical_on_road = (z+(zspeed/2) >= zlerp);
if (vertical_on_road) {
	drive_force -= sin(on_road_index.elevation) * global.gravity_3d * mass;
	z = zlerp;
	if (zspeed > global.gravity_3d) {
		zspeed *= -1/3;
		turn_rate *= 3;
	}
}
else {
	// FREE FALLING
	zspeed += global.gravity_3d * global.deltatime;
}
z += zspeed;
z = clamp(z, -500, zlerp);
// z -= sin(degtorad(nearest_road.next_road.elevation)) * velocity / 60;
if (z > on_road_index.next_road.z + 100) {hp = 0;}

// move car in direction
if (!is_respawning) {
	turn_rate += -turn_rate * 0.1;
	turn_rate = clamp(turn_rate, -6, 6);
	if (vertical_on_road) {
		direction += turn_rate;
	}
}
x += cos(degtorad(direction)) * vel;
y -= sin(degtorad(direction)) * vel;
image_angle = direction;

velocity += acceleration * global.deltatime;// * gear_ratio[gear-1];