if (keyboard_check_pressed(vk_left)) {level -= 1;}
if (keyboard_check_pressed(vk_right)) {level += 1;}
if (level < 0) {level = 4;}
if (level > 4) {level = 0;}

if (keyboard_check_pressed(vk_space)) {
	global.difficulty = global.LEVEL_TO_DIFFICULTY[level];
	room_goto_next();
}