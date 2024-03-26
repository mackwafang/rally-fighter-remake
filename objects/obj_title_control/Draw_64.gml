draw_set_font(fnt_game);

var port_width = view_wport[0];
var port_height = view_hport[0];

draw_set_font(fnt_game);

draw_set_valign(fa_middle);
draw_set_halign(fa_center);
draw_text(port_width / 2, port_height / 2, $"Level {round(level+1)}");


draw_text(port_width / 2, port_height * 0.65, $"Left / Right - Turn\nC - Accelerate\nX - Boost\nZ - Brake");