function point() constructor {
	x = argument[0];
	y = argument[1];
}

function vec2() constructor
{
	#region Initialize Vector
		
		__IS_VEC_3 = false;
		
		#region Setup
		
			/// Set available parameters
			var paramArray = array_create(2,0);
			for ( var i=0; i<argument_count; i++ )
			{
				paramArray[@i] = argument[i];
			}
			
		#endregion
		#region Position[0] Handling
		
			var arg = argument[0];
			if ( argument_count==1 )
			{
				if ( is_struct(arg) )
				{
					paramArray = [ arg.x, arg.y ];
				}
				else
				{
					paramArray = [ arg, arg ];
				}
			}
			
		#endregion
		#region Set values
		
			x=paramArray[0]; 
			y=paramArray[1];
			
		#endregion
		
	#endregion
	#region Math Functions
		
		#region Arithmetical functions
		
			static multiply=function(val)
			{
				///@func mul(value_or_vec)
				var v = new vec2(val);
				return new vec2(x * v.x, y * v.y);
			}
			static add=function(val)
			{
				///@func add(value_or_vec)
				var v = new vec2(val);
				return new vec2(x + v.x, y + v.y);
			}
			static subtract=function(val)
			{
				///@func sub(value_or_vec)
				var v = new vec2(val);
				return new vec2(x - v.x, y - v.y);
			}
			static divide=function(val)
			{
				///@func divide(value_or_vec)
				var v = new vec2(val);
				return new vec2(x / v.x, y / v.y);
			}
			static modulo=function(val)
			{
				///@func modulo(value_or_vec)
				var v = new vec2(val);
				return new vec2(x % v.x, y % v.y);
			}
			
		#endregion
		#region Advanced functions
		
			static length_squared = function()
			{
				///@func length_squared()
				return x*x+y*y;
			}
			static length = function()
			{
				///@func length()
				return sqrt(length_squared());
			}	
			static normalize = function()
			{
				///@func normalize()
				var mag = length();
				if ( mag == 0 ) {
					x=0; y=0;
				}
				else
				{
					divide(mag);
				}
				return self;
			}
			static is_normalized = function()
			{
				///@func is_normalized()
				return ( length_squared() == 1 );
			}
			static inverse = function()
			{
				///@func inverse()
				return new vec2(1/x, 1/y);
			}		
			static dot = function(val)
			{
				///@func dot(value_or_vec)
				var v = new vec2(val);
				return dot_product(x,y,v.x,v.y);
			}
			static dot_normalized = function(val)
			{
				///@func dot_normalized(value_or_vec)
				var v = new vec2(val);
				return dot_product_normalized(x,y,v.x,v.y);
			}			
			static distance_to = function(val)
			{
				///@func distance_to(value_or_vec)
				var v = new vec2(val);
				var v2 = new vec2(x,y);
				
				v.subtract(v2);
				return v.length();
			}
			static angle_to = function(val)
			{
				///@func angle_to(value_or_vec)
				var v = new vec2(val);
				return point_direction(x,y,v.x,v.y);
			}
			static lerp_to = function(val,amt)
			{
				///@func lerp_to(value_or_vec, amount)
				var v = new vec2(val);
				x=lerp(x,v.x,amt);
				y=lerp(y,v.y,amt);
				return self;
			}
			static reflect = function(val)
			{
				///@func reflect(normal);
				var v = new vec2(val);
				v.normalize();
				
				var d = dot(v);
				v.multiply(2*d);
				v.subtract(new vec2(x,y));
				return v;
			}	
			static clamp_to = function(v1, v2)
			{
				///@func clamp_to(min, max)
				x = clamp(x, v1, v2);
				y = clamp(y, v1, v2);
				return self;
			}
			
			static vec_abs = function()
			{
				return new vec2(abs(x),abs(y));
			}
			static vec_floor = function()
			{
				return new vec2(floor(x),floor(y));
			}
			static vec_ceil = function()
			{
				return new vec2(ceil(x),ceil(y));	
			}
			static vec_sign = function()
			{
				return new vec2(sign(x),sign(y));	
			}
			static vec_round = function()
			{
				return new vec2(round(x),round(y));	
			}
			
		#endregion
	#endregion
	
	toString = function() {
		return $"({x}, {y})";
	}
	
}