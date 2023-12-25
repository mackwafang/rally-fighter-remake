global.deltatime = delta_time / 1000000;
for (var rank = 0; rank < array_length(global.car_ranking); rank++) {
	global.car_ranking[rank].race_rank = rank+1;
}
// car ranking
array_sort(global.car_ranking, function(car1, car2) {
	return car2.dist_along_road - car1.dist_along_road;
});

