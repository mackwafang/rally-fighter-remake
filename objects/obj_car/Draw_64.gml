if (is_player) {
	draw_text(0,0,$"engine: {engine_rpm} rpm");
	draw_text(0,20,$"{velocity} kmh");
	draw_text(0,40,$"{gear} gear");
	draw_text(0,60,$"engine: {engine_power}");
}