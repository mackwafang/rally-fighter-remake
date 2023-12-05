if (other != self) {
	if (abs(other.z - z) < 16) {
		if (!other.is_respawning) {
			var rad = degtorad(angle_difference(image_angle, point_direction(x,y,other.x,other.y)));
			push_vector.x += abs(other.velocity - velocity) * cos(rad) * mass;
			push_vector.y += abs(other.velocity - velocity) * sin(rad) * mass;
			hp -= max(1, push_vector.length() / 100000);
	
			turn_rate = push_vector.y / (mass * 10000);
			// move_contact_solid(point_direction(other.x,other.y,x,y),1);
		}
	}
}