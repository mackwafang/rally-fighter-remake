if (other != self) {
	if (abs(other.z - z) < 16) {
		if (!other.is_respawning) {
			var deg = angle_difference(image_angle, point_direction(x,y,other.x,other.y));
			push_vector.x += abs(other.velocity - velocity) * dcos(deg) * other.mass * 4;
			push_vector.y += abs(other.velocity - velocity) * dsin(deg) * other.mass * 4;
			hp -= max(1, push_vector.length() / 25000);
	
			turn_rate = push_vector.y / (mass * 1000);
			move_contact_solid(point_direction(other.x,other.y,x,y),8);
			hp_regen_delay = -3;
		}
	}
}