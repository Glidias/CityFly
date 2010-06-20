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
		
		
		// -- LOW-LEVEL CITY-BASED RENDERING MACROS 
		//  (may be transfered to specialized BitmapData classes). Handling lego blocks on 2d tile maps.
		
		/*
		 * StoreyMap  
			--------------
			1 block/gap is equailavent to 1 color/alpha channel. Thus, given a uint pixel, there are 32 bits to work with, which gives 4 blocks/gaps to use for each building tile. As long as all block/gap heights are of base 2 dimensions (which will 
			definitely be the case given the use of bit shifts), all possible values are accounted for below the maximum possible building height.

			Each full storey is ~512 units. (high ceiling level)
			A shorter storey is ~256 units. (low ceiling level)

			Total maximum building surface height ~128 full storeys (without gaps) and ~64~96 full storeys (with gaps).
			Each block height ~32 full storeys, Maximum 4 blocks/gaps for building. Thus, the maximum building height can go up to 
			128*512 = 65536 units. This provides a maximum building height that can go up to 2 times the height of the world's tallest building.
			3 bits -> 0-7 (base 2 step addition) of up to 512 units
			4 bits -> 0-15  (base multiplier of 1024 units)
			1 bit -> 0-1  (got wall? If true, means it's a block, else, it's a gap).
			
			1) A gap will draw a ceiling at the end of the gap if player is below the ceiling surface.
			2) A block without any blocks above it (such as out of channel index bounds or another gap), will draw a floor if
			player is above the floor surface. THe floor that belongs to the last highestmost block is known as the "roof".
			3) Generally, the last channel result index should not be a gap, as this would prevent a "roof" from being drawn, 
				however, in some cases, this rule can be ignored if a roof may never be seen in such a case. (such as preventing
				the player from flying higher than the ceiling level of that gap.)
			
			A combination of alternating blocks and gaps can support "roof over room" or "roof over room over groundlevel/ground-room" (such as bridge overpasses). There may be the possibility of extending this to support optional hash-based lookups to another uint value (for extensions to allow more block/gap combinations, and thus allow for an infinite number of inner room-over room storeys, or just more..).
			In some cases, gaps might still draw textures, but usually alpha transprency textures are used so the inner room ceilings/floor can be seen.
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
		 A ground map consist of textures a texture index reference for the ground floor, middle floor (for each intermediary storey block), the roof and the ceiling. Other than, it consist of ground multiplier skips/or downsamples (if applicable) over specific areas of the map that are known to have no higher buildings or require finer grid resolutions,
		 allowing raycasts to skip jumps at increasing base 2 levels or have smaller grid tiles for finer raycasting calculations. 
		 A ground map is used for both the main grid and any assigned subgrids within each tile of a main grid.
		
			(Allocation of bit masks between different ground/ceiling types can change as time goes by)
			256 qty - for grounds	8 bits
			128 qty - for middle grounds 	7 bits
			128 qty  - for roofs 7 bits
			64 qty - for ceilings  6 bits
			
			For grid resolutions, allocation has turned out exceedingly generous in order to support grid resolutions
			below 32 units (which is smaller than the player's collision diameter hull).
			
			For main grid (assuming it's callibrated to 256 units per tile)
			1 bit -> determines whether to refer to a higher resolution subgrid (value 1) or use current grid (value 0)
			3 bits -> 0-7 ground level skips of 2^(8 +|- {0 to 7}), providing a maximum span of 256 to 32768 unit jumps  for current grid 
			and resolutions down 2 to for sub grids . 
			
			For subgrids
			4 bits -> 0-15 ground level skips of  2^(1 +|- {0 to 15}), providing a maximum span of 2 to 65536 unit jumps.
			
			Note that for subgrid resolutions, it's advised to only go down to no lower than 16 units to keep memory at bay,
			since sub grids are repsented as hash allocated dense tables (additional bitmapdatas). A 16 unit cap will be used in the map editor.
			Generally. one should use subgrids sparingly only over small portions of a map, particuarly for grid resolutions lower than 64.
			Additionally, skips would seldom go up to exceedingly high levels (65535, lol) for most densely populated areas, and would most likely
			reach 1024 units in most circumstances. 
			
			As you can see, the use of subgrid resolution provides the ability to render finer details of static blocks
			such as narrow ledges, rooftop props, etc, yet still providing skips over large distances, together
			with the main grid skips. This is integral to gameplay which involves fine detailed
			experiences such as climbing of buildings/infiltration vs. broad-experiences like 
			flying/driving over large cities/expanses.
		
		 */
		 
		 
		 /*
		  WallMap
		  ----------
		  A wall map consist of texture-sceheme index references for the left/top/right/bottom edges of a block respectively.
		  Thus a combination of 256 wall texture-sceheme index referneces is provided for each channel from 0-255 for each pixel tile.
		  
		  256 qty - 0-255 lookup indexes of 8 bits each for each side (N,E,S,W). This is standard. A texture-sceheme index lookup
		  often refers to another seperate table which consist of per storey channel block textures, where the actual color is finally
		  picked based on the given ray hit tile offset, current ray altitude and other settings. (see TextureLookupTable for
		  more info).
		  
		  For SubGridBitmapDatas, an additional wall-map is created known as the "textureAlignmentMap" to account
		  for custom texture-alignments for all 4 sides of a given block. 2 sets of custom texture alignments
		  are provided per tile, though if that isn't enough, an additional "textureAlignmentMap" is created if required.
		  All SubGridBitmapDatas composes the resultant (higher resolution) WallMap, GorundMap, StoreyMap and other relavant
		  maps in 1 single bitmapdata with custom methods to retrieve pixels from these 4(or more) maps.
		  
		  Each pixel in the textureAlignmentMap has the following combination of bits:
		  16 bits -> 4 bits for each side texture alignment offset (base 16. 16x{(0-15)}=240)
		  Additional 16 bits for 2nd texture alignment (if any). Usuually, there won't be much
		  need to dynamically allocate a 2nd pair, but if required, more space is allocated 
		  by the SubGridBitmapData by increasing it's dimensions (diposing off the previous bitmapdata).
		  
		  Because not all tiles of a WallMap/TextureAlignmentMap is useful ( since some areas have no walls), 
		  some is "wasted" since a dense array (of uints) is used via a bitmapdata. A sparse array with dynamic hash indexing 
		  can be used, but lookup would be much slower.
		  
		*/
		  
		
		/*
		 TextureLookupTable
		 -------------------
		 A texture table provides a definite lookup table to refer to a given texture and it's pixel color to use
		 given a specific ray hit situation. Since each building tile (and stack block combinations) can be unique and 
		 can consist of multiple storeys/gaps/blocks/etc. we need a seperate reference for a more precise texture lookup and it's details.
		 This is dynamically generated per map load.
		 
		   For CityFly:
			Each lookup pixel  
		   5 bits -> texture x position (base 32) ( a texture sheet of 1:2 dimensions, 1024x2048)
		   6 bits -> texture y position (base 32)
		   2 bits -> texture width (2^5+{(0-3)}) 32 - 256 pixels base-2 dimensions (4 combinations)
		   2 bits -> texture height (2^5+{(0-3)}) 32 - 256 pixels base-2 dimensions (4 combinations)
		   2 bits -> No. of storey channels used (0-3, for values 1-4)
		   Total 17 bits used. 15 bits unused. Actually, can use more..See how, 
		   consider lowering bases for smaller texture sizes, and providing texture sizes larger than grid
		   provided that there's a way to resolve texture alignments easily given the default grid
		   size of 256...
		   
		   For CityNightFly:
		   6 bits -> texture x position (base 16)  ( a texture sheet of 1:2 dimensions, 1024x2048)
		   7 bits -> texture y position (base 16)
		   3 bits ->  texture width (2^4+{(0-7)}) 16 - (max 256)2048 pixels base-2 dimensions (5-8 combinations)
		   3 bits ->  texture height (2^4+{(0-7)}) 16 - (max 256)2048 pixels base-2 dimensions (5-8 combinations)
		   2 bits -> No. of storey channels used (0-3, for values 1-4)
		   4 bits -> skipV (base 16) 0- 240
		   4 bits -> skipH (base 16) 0 - 240 *
		   1 bit -> initialSkipH ?	whether to skip for initial start (gap) *
		   1 bit -> initialSkipV ?  whether to skip for initial start (gap) *
		  Total 31 bits used. 1 bit unused. Consider providing additional bits for skipH and skipV,
		  though that means this would work under same assumption as above that texture alignments
		  can be easily resolved for texture sizes/skips higher than the current main grid size
		  of 256. (eg. 512, 1024, etc.), and perhaps skipH,initialSkipH, and initialSkipV can simply
		  be handled via another pre-calculated truth table to determine whether to skip or render,
		  saving 6 bits of info. I prefer the latter because it can allow the user to define the exact
		  table layout of window arrangement of buildings, without using fixed gaps.
		*/
		  
		
		
	
}