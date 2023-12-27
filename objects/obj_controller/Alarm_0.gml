array_foreach(participating_vehicles, function(car) {
	car.can_move = true;
});
global.race_started = true;