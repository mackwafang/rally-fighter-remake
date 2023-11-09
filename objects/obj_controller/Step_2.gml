
// car ranking
array_copy(car_ranking, 0, participating_vehicles, 0, array_length(participating_vehicles));
array_sort(car_ranking, function(car1, car2) {
	return car1.dist_along_road < car2.dist_along_road;
});