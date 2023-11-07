ai_behavior.desired_lane = 1 + irandom(on_road_index.get_lanes_right()-1);
show_debug_message($"change lane to {ai_behavior.desired_lane}");
alarm[1] = 60 + (irandom_range(3,10) * 60);