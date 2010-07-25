/**
 * Core city map information and helpers.
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting.city;


class CityGlobals 
{
			
		// -- BASIC COMMON RAYCASTING HELPERS
	
		// -- User settings
		public static inline var MAP_TILES_X:Int = 128;		// Number of tiles in X directions for map (or pixels for bitmapData)
		public static inline var MAP_TILES_Y:Int = 128;		// Number of tiles in Y direction for map (or pixels for bitmapData)
		public static inline var TOTAL_TILES:Int = MAP_TILES_X * MAP_TILES_Y;
		public static inline var GRIDSIZE:Int	=	128;			// Size of (square) cell in map
		public static inline var GRIDSIZE_HALF:Int = Std.int(GRIDSIZE / 2);
		
		// -- Derived settings
		public static inline var IGRIDSIZE:Float =	1/GRIDSIZE;			
		public static inline var GRIDMASK:Int	=	GRIDSIZE-1;		// Mask for integer 'mod' operations (eg. 0x3f for 64-1) 
		public static inline var GRIDCENTER:Int =	Std.int(GRIDSIZE/2);		// Mask for integer 'mod' operations  (half)
		public static function ROUNDGRID(val:Float):Int {	return Std.int(val)&~GRIDMASK;	}// UNSIGNED Get left or top world coordinate matching grid cell edge
		public static inline function  MODGRID(val:Float):Int	{ return Std.int(val)&GRIDMASK;	}	// UNSIGNED Wrap world coordinates within grid cell
	
		// TODO: Calculate proper Log-base2 of bitshifts
		public static inline function  DIVGRID(val:Float):Int	{	return Std.int(val)>>7;		}	// Divide by map grid size
		public static inline function  MULGRID(val:Float):Int	{	return Std.int(val)<<7; 	}	// Multiply by map grid size
		
		
		// Texture offset calculations
		public static inline function OFFSET_NORTH(val:Float):Int { return Std.int(val) & (GRIDSIZE - 1);  }
		public static inline function OFFSET_SOUTH(val:Float):Int { return GRIDSIZE - Std.int(val) & (GRIDSIZE - 1); }
		public static inline function OFFSET_WEST(val:Float):Int { return GRIDSIZE - Std.int(val) & (GRIDSIZE - 1);  } 
		public static inline function OFFSET_EAST(val:Float):Int { return Std.int(val) & (GRIDSIZE - 1);  }
		
	
}