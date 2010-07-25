/**
 * ...
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting.andre;

class WorldGlobals 
{
	
		// -- BASIC COMMON RAYCASTING HELPERS
	
		// -- User settings
		public static inline var MAP_TILES_X:UInt = 128;		// Number of tiles in X directions for map (or pixels for bitmapData)
		public static inline var MAP_TILES_Y:UInt = 128;		// Number of tiles in Y direction for map (or pixels for bitmapData)
		public static inline var  GRIDSIZE:UInt	=	64;			// Size of (square) cell in map
		public static inline var GRIDSIZE_HALF:UInt = Std.int(64 / 2);
	
		// -- Derived settings
		public static inline var IGRIDSIZE:Float =	1/GRIDSIZE;			
		public static inline var GRIDMASK:UInt	=	GRIDSIZE-1;		// Mask for integer 'mod' operations (eg. 0x3f for 64-1) 
		public static inline var GRIDCENTER:UInt =	Std.int(GRIDSIZE/2);		// Mask for integer 'mod' operations  (half)
		public static function ROUNDGRID(val:Float):Int {	return Std.int(val)&~GRIDMASK;	}// UNSIGNED Get left or top world coordinate matching grid cell edge
		public static inline function  MODGRID(val:Float):Int	{ return Std.int(val)&GRIDMASK;	}	// UNSIGNED Wrap world coordinates within grid cell
		public static inline function  DIVGRID(val:Float):Int	{	return Std.int(val)>>6;		}	// Divide by map grid size
		public static inline function  MULGRID(val:Float):Int	{	return Std.int(val)<<6; 	}	// Multiply by map grid size
		//static const   assertGRIDSIZE():Boolean assert(ppIsPow2(GRIDSIZE)) // Make sure grid size is valid
	
		// Texture offset calculations
		public static inline function OFFSET_NORTH(val:Float):Int { return Std.int(val) & (GRIDSIZE - 1);  }
		public static inline function OFFSET_SOUTH(val:Float):Int { return GRIDSIZE - Std.int(val) & (GRIDSIZE - 1); }
		public static inline function OFFSET_WEST(val:Float):Int { return GRIDSIZE - Std.int(val) & (GRIDSIZE - 1);  } 
		public static inline function OFFSET_EAST(val:Float):Int { return Std.int(val) & (GRIDSIZE-1);  }
	
}