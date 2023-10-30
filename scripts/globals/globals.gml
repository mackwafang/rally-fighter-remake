global.DEBUG_ROAD_DRAW_CONTROL_POINTS = false;
global.DEBUG_ROAD_DRAW_ROAD_POINTS = false;
global.DEBUG_ROAD_DRAW_ROAD_LANES_POINTS = false;

global.DEBUG_FREE_CAMERA = false;

global.WORLD_TO_REAL_SCALE = 10;
global.REAL_TO_WORLD_SCALE = 1/global.WORLD_TO_REAL_SCALE;

// player_input
global.player_input = {
	accelerate: ord("C"),
	boost: ord("X"),
	brake: ord("Z"),
	turn: {
		left: vk_left,
		right: vk_right,
	}
}