function pnpoly(nvert, vertx, verty, testx, testy) {
	///@param {int}		nvert number of vertices
	///@param {array}	vertx list of x coordinate
	///@param {array}	verty list of y coordinate
	///@param {float}	testx x coordinate to check
	///@param {float}	testx y coordinate to check
	var i = 0;
	var j = nvert-1;
	var c = false;
	
	for (i = 0; i < nvert; j=i++) {
		if ( ((verty[i]>testy) != (verty[j]>testy)) && (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) ) {
			c = !c;
		}
	}
	return c;
}