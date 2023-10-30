function torque_lookup(rpm) {
	var torque_table = [
		0,
		400,
		420,
		500,
		510,
		520,
		490,
		450,
		400,
		300,
		250,
	]
	var index = max(1, min(array_length(torque_table)-2, rpm div 1000));
	var lerp_value = (rpm - (rpm div 1000)) / 1000;
	return lerp(torque_table[index-1], torque_table[index], lerp_value) * 4;
}