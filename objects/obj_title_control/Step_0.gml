if (keyboard_check_pressed(vk_left)) {level -= 1;}
if (keyboard_check_pressed(vk_right)) {level += 1;}
if (level < 0) {level = 4;}
if (level > 4) {level = 0;}

if (keyboard_check_pressed(vk_space)) {
	proceed_to_level = true;
}

if (proceed_to_level) {
	wait_timer += 1;
	if (wait_timer >= 3 * global.display_freq) {
		global.difficulty = global.LEVEL_TO_DIFFICULTY[level];
		room_goto_next();
	}
}
else {
	if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)) {audio_play_sound(snd_menu_select, 0, false);}
}

global.display_freq = display_get_frequency();