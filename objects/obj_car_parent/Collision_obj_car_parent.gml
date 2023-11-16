if (other != self) {
	var rad = degtorad(angle_difference(image_angle, point_direction(x,y,other.x,other.y)));
	push_vector = new vec2(
		other.velocity * cos(rad) * mass,
		other.velocity * sin(rad) * mass,
	);
	
	move_contact_solid(point_direction(x,y,other.x,other.y),8);
}