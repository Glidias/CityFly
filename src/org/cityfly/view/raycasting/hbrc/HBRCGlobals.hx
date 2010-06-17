/**
 * ...
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting.hbrc;

class HBRCGlobals 
{
	// Texture indexes
	public static inline var TEXI_INSIDE:Int= -1; // Ray began inside bounding box
	public static inline var TEXI_EAST:Int	= 0;
	public static inline var TEXI_NORTH:Int	= 1;
	public static inline var TEXI_WEST:Int	= 2;
	public static inline var TEXI_SOUTH:Int= 3;
	public static inline var TEXI_TOP:Int = 4;
	public static inline var TEXI_BOTTOM:Int = 5;
	
	
//
 // Map mask access wrappers 
 // This mask represents terrain height, shape and blocking
 // Since it's a BitmapData, we only have 24 reliable bits to work with
 //
	public static inline var MAP_SHAPE_MASK		=		0x0000003f;
	public static inline var MAP_FILL_MASK		=		0x00000040;
	public static inline var MAP_UNUSED			=		0x00000080;
	public static inline var MAP_BASE_MASK		=		0x0000ff00;
	public static inline var MAP_HEIGHT_MASK	=			0x00ff0000;
// Get cell shape mask
	public static inline function MAP_SHAPE_GET(val)	{ return ((val) & MAP_SHAPE_MASK); }
// Change shape mask
	public static inline function MAP_SHAPE_SET(val, newval)	{ return ((val) = ((val) & ~MAP_TYPE_MASK) | ((newval) & MAP_SHAPE_MASK)  ) ; }
// Get cell fill type
	public static inline function MAP_FILL_GET(val)	{ return uint(0 != ((val) & MAP_FILL_MASK)); }
// Set cell fill type
	public static inline function MAP_FILL_SET(val, newval) { return val = newval ? (val & ~MAP_FILL_MASK) : (val | MAP_FILL_MASK); }
// Get map cell base
	public static inline function MAP_BASE_GET(val)			{ return (((val) & MAP_BASE_MASK) >> 8); }
// Get map cell base
	public static inline function MAP_BASE_SET(val, newval)	{ return ((val) = ((val) & ~MAP_BASE_MASK) | (((newval) << 8) & MAP_BASE_MASK));
	 }
// Get map cell height
	public static inline function MAP_HEIGHT_GET(val)	{ return 	(((val) & MAP_HEIGHT_MASK) >> 16);
	 }
// Get map cell height
	public static inline function MAP_HEIGHT_SET(val, newval) { return 	((val) = ((val) & ~MAP_HEIGHT_MASK) | (((newval) << 16) & MAP_HEIGHT_MASK)); 
	}
// See if there's anything in map cell
	public static inline function MAP_IS_FLAT(val)		{ return 	((0 == ((val) & (MAP_BASE_MASK | MAP_HEIGHT_MASK))) || (0 == ((val) & MAP_SHAPE_MASK))); 
	}
// Initialize map cell mask from given values
	public static inline function MAP_INIT_VAL(base, height, fill, shape) { 
		( (((height) << 16) & MAP_HEIGHT_MASK) | (((base) << 8) & MAP_BASE_MASK) | (((fill) << 6) & MAP_FILL_MASK) | ((shape) & MAP_SHAPE_MASK) );
	 }
	

/*



// CELL Shape edges (0x3f would be a box with an X inside [X])
#define MAP_E	0x01	//   ]
#define MAP_N	0x02	//  -
#define MAP_W	0x04	// [
#define MAP_S	0x08	//  _
#define MAP_DNW	0x10	//  \ 
#define MAP_DNE	0x20	//  /
#define MAP_BLOCK	(MAP_E|MAP_N|MAP_W|MAP_S)
#define MAP_NE		(MAP_E|MAP_N|MAP_DNW)
#define MAP_SE		(MAP_E|MAP_S|MAP_DNE)
#define MAP_NW		(MAP_W|MAP_N|MAP_DNE)
#define MAP_SW		(MAP_W|MAP_S|MAP_DNW)

// Map block identifiers - MAP_TYPE_MASK
#define MAP_FILL_STRETCH		0	// Texture stretches to fit
#define MAP_FILL_WALLPAPER		1	// Texture repeats



//
// WorldSprite flags
//
#define WS_FLAG_DESTROYME	0x00000001
	 
	 */
	
}	