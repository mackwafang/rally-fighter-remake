function assert(expression, msg=""){
	/// @function			assert(epxression, msg="")
	/// @description		An assertion guard. Abort the game when expression is true
	/// @param {boolean}	expression
	/// @param {str}		msg (optional)
	if (!expression) {
		show_error($"Assertion failed. {msg}", true);
	}
}