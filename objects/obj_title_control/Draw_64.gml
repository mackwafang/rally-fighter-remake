draw_set_font(fnt_game);

var port_width = view_wport[0];
var port_height = view_hport[0];

draw_set_font(fnt_game);

draw_set_valign(fa_middle);
draw_set_halign(fa_center);
var anic = animcurve_get(anic_flash);
var flash_freq = global.display_freq div 3;
var alpha = animcurve_channel_evaluate(animcurve_get_channel(anic, 0), (wait_timer % flash_freq) / flash_freq);
draw_set_alpha(alpha);
draw_text(port_width / 2, port_height / 2, $"Level {round(level+1)}");
draw_set_alpha(1);


draw_text(port_width / 2, port_height * 0.65, $"Left / Right - Turn\nC - Accelerate\nX - Boost\nZ - Brake\n\nPress <Space> to begin");

draw_set_valign(fa_bottom);
draw_set_halign(fa_center);
draw_text(port_width / 2, port_height, "created by meekuwufang");