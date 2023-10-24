function factorial(n) {
	/// @function		factorial(n)
	/// @description	Calculate n!
	/// @param {int}	n
	/// @return {int}	The result of n!
	assert(n < 0);
	assert(typeof(n) != "number");
	if (n <= 1) {
        return 1;
    }
    else {
        return n * factorial(n - 1);
    }
}

function ncr(n, r) {
	assert((n < 0) or (r < 0) or (r > n), "n and r must be non-negative integers, and r must be less than or equal to n.");
	return factorial(n) div (factorial(r) * factorial(n - r));
}