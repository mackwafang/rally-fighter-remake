/// @description post creation "script"
switch(vehicle_type) {
	case VEHICLE_TYPE.CAR:
		sprite_index = spr_car;
		vehicle_detail_index = spr_car_detail;
		break;
	case VEHICLE_TYPE.BIKE:
		sprite_index = spr_bike;
		vehicle_detail_index = spr_bike_detail;
		break;
}
z = on_road_index.z;
image_blend = vehicle_color;