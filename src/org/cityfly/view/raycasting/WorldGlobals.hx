/**
 * ...
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting;

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

		
		public static var world:Dynamic = { };
		
		
		// -- ADVANCED LOW-LEVEL CITY-BASED RENDERING MACROS (may be transfered to specialized BitmapData classes)
		
		/*
		 * StoreyMap 
			--------------
			1 block/gap is equailavent to 1 color/alpha channel. Thus, given a uint pixel, there are 32 bits to work with, which gives 4 blocks/gaps to use for each building tile. As long as all block/gap heights are of base 2 dimensions (which will 
			definitely be the case given the use of bit shifts), all possible values are accounted for below the maximum possible building height.

			Each full storey is ~512 units. (higher ceiling levels)
			A low storey is ~256 units. (lower ceiling levels)

			Total maximum building surface height ~128 full storeys (without gaps) and ~64~96 full storeys (with gaps).
			Each block height ~32 full storeys, Maximum 4 blocks/gaps for building. Thus, the maximum building height can go up to 
			128*512 = 65536 units.
			3 bits -> 0-7 (base 2 step addition) of up to 512 units
			4 bits -> 0-15  (base multiplier of 1024 units)
			1 bit -> 0-1  (got wall? If true, means it's a block, else, it's a gap).
			
			1) A gap will draw a ceiling at the end of the gap if player is below the ceiling surface.
			2) A block without any blocks above it (such as out of channel index bounds or another gap), will draw a floor if
			player is above the floor surface. THe floor that belongs to the last highestmost block is known as the "roof".
			3) Generally, the last channel result index should not be a gap, as this would prevent a "roof" from being drawn, 
				however, in some cases, this rule can be ignored if a roof may never be seen in such a case. (such as preventing
				the player from flying higher than the ceiling level of that gap.)
			
			A combination of alternating blocks and gaps can support "roof over room" or "roof over room over groundlevel/ground-room" (such as bridge overpasses). There may be the possibility of extending this to support optional hash-based lookups to another uint value (for extensions to allow more block/gap combinations, and thus allow for an infinite number of inner room-over room storeys, or just more..). In some cases, gaps might still draw textures, but usually alpha transprency textures are used so the inner room ceilings/floor can be seen.
		*/
			
			
		public static inline function getBlockChannelIndexOfAltitude(color:UInt, altitude:Float):Int {
			return 0;
		}
		

		
		public static inline function getBlockChannelResult(channelIndex:Int, color:UInt):UInt {
			return 0;
		}
		
		/**
		 * Retrieves height of block/gap above current ground level.
		 * @param	storeyChannel
		 * @param	color
		 * @return
		 */
		public static inline function getBlockOrGapHeight(channelResult:UInt):UInt {
			//bitmask based on storey channel index by RGBA (up to length of 4)
			// building gap height:
			 
			// building block height:
			//bitmask 5 bits for intended value (~32dec), 3 bits for downsample subtractions (~8dec)
			
			return 0;
		}

		
		public static inline function getIsBlock(channelResult:UInt):Bool {
			return false;
		}
		public static inline function setBlockOrGap(index:UInt, storeys:UInt, stepValue:UInt=0, isBlock:Bool=true):Void {
			
		}
		
		
		/*
		 GroundMap  
		 ------------
		 A ground map consist of textures a texture index reference for the ground floor, middle floor (for each intermediary storey block), the roof and the ceiling. Other than, it consist of ground multiplier skips (if applicable) over specific areas of the map that are known to have no higher buildings, allowing raycasts to skip jumps at increasing base 2 levels.
		
			(Allocation of bit masks between different ground/ceiling types can change as time goes by)
			512 qty - for grounds	9 bits
			128 qty - for middle grounds 	7 bits
			128 qty  - for roofs 7 bits
			64 qty - for ceilings  6 bits
			
			2 bits -> 0-3 ground level skips of 2^(6 + {0 to 3}), providing a maximum span of 64 to 512 units raycast jumps.
			(which leaves 1 extra bit...for what?? Possible to use 0 or 1 to downsample 64 skip to 32 skip for finer resolution zones)
			or 
			3 bits 	 -> 0-7 ground level skips of 2^(6 + {0 to 7}), providing a maximum span of 64 to 8192 units raycast jumps.
			
			
			This  migth change as time goes by..
		
		 */
		 
		 
		 /*
		  WallMap
		  ----------
		  A wall map consist of texture-sceheme index references for the left/top/right/bottom edges of a block respectively.
		  Thus a combination of 256 wall texture-sceheme index referneces is provided for each channel from 0-255 for each pixel tile.
		  
		  256 qty - 0-255 lookup indexes of 8 bits each for each side (N,E,S,W). This is standard. A texture-sceheme index lookup
		  often refers to another seperate table which consist of per storey channel block textures, where the actual color is finally
		  picked based on the given ray hit tile offset, current ray altitude and other settings. (see TruthTextureTable for
		  more info).
		  
		  Botht the TruthTextureTable and WallMap are tightly coupled.
		*/
		  
		
		/*
		 TruthTextureTable
		 -------------------
		 A truth texture table provides a definite lookup table to refer to a given texture and it's pixel color to use
		 given a specific ray hit situation. Since each building tile is unique and can consist of multiple storeys/gaps/blocks/etc.
		 we need a seperate reference for a more precise texture lookup and it's details.
		 
		   For CityFly:
			Each lookup pixel
		   16 bits for base 32 texture dimensions, position and number of storeys. (Got extra 16 bits)
		   
		   
		   For CityNightFly:
		    Each lookup pixel row.
			
			
			Bit vector reference for column to determine on/off states of windows
		     
		*/
		  
		
		
	
}