
for (var rank = 0; rank < array_length(car_ranking); rank++) {
	car_ranking[rank].race_rank = rank+1;
}
// car ranking
array_sort(car_ranking, function(car1, car2) {
	return car2.dist_along_road - car1.dist_along_road;
});

