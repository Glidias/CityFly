/**
 * Texture memory assembly
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting.city;
import flash.display.BitmapData;
import flash.errors.Error;
import flash.Vector;
import flash.Memory;
import org.cityfly.common.MATH;

class TextureGlobals 
{	
	public static inline var GROUNDCEIL_TEXTURE_OFFSET:Int = 0;
	public static inline var GROUNDCEIL_TEXTURE_SIZE:Int = ( 1024 * 2048 ) << 2;
	public static inline var GROUNDCEIL_TEXTURE_BASE_DIMENSION:Int = 128; // Basic square dimension
	public static inline var GROUNDCEIL_TEXTURE_BASE_DIMENSION_LOG2:Int = 7;
	// !important below:: Hard code manually with MATH.log2(GROUNDCEIL_TEXTURE_BASE_BYTES). See Formulas.
	public static inline var GROUNDCEIL_TEXTURE_BASE_SIZE_LOG2:Int = 16; 

	public static inline var WALL_TEXTURE_OFFSET:Int  = GROUNDCEIL_TEXTURE_OFFSET + GROUNDCEIL_TEXTURE_SIZE ;
	public static inline var WALL_TEXTURE_SIZE:Int = 2*( 1024 * 1024 ) << 2;
	public static inline var WALL_TEXTURE_BASE_DIMENSION:Int = 128;  // Basic square dimension
	public static inline var WALL_TEXTURE_BASE_DIMENSION_LOG2:Int = 7;  // Basic square dimension
	// !important below:: Hard code manually with MATH.log2(WALL_TEXTURE_BASE_BYTES). See Formulas.
	public static inline var WALL_TEXTURE_BASE_SIZE_LOG2:Int = 16;  
	
	
	// Everything from here below doesn't need to change...
	
	// Formulas
	public static inline var GROUNDCEIL_TEXTURE_BASE_BYTES:Int = GROUNDCEIL_TEXTURE_BASE_DIMENSION * GROUNDCEIL_TEXTURE_BASE_DIMENSION * 4;
	public static inline var WALL_TEXTURE_BASE_BYTES:Int = WALL_TEXTURE_BASE_DIMENSION * WALL_TEXTURE_BASE_DIMENSION * 4;
	/*  @see log2() method at org.cityfly.common.MATH  */
	
	// Other determined values
	public static inline var TOTAL_MEMORY_SIZE:Int = GROUNDCEIL_TEXTURE_SIZE + WALL_TEXTURE_SIZE;
	
	// Useful helper  methods
	
	public static inline function getGroundColor(index:Int, x:Int, y:Int):Int {
		return Memory.getI32( CityAssembly.TEXTURES_ADDRESS + GROUNDCEIL_TEXTURE_OFFSET + index*GROUNDCEIL_TEXTURE_BASE_BYTES + (( (y << GROUNDCEIL_TEXTURE_BASE_DIMENSION_LOG2) + x) << 2) );
	}
	public static inline function getWallColor(index:Int, x:Int, y:Int):Int {
		return Memory.getI32( CityAssembly.TEXTURES_ADDRESS + WALL_TEXTURE_OFFSET + index*WALL_TEXTURE_BASE_BYTES + (( (y << WALL_TEXTURE_BASE_DIMENSION_LOG2) + x) << 2) );
	}
	
	
	public static function parseGroundBitmapDataSheet(bmpData:BitmapData ):Void {
		if (!MATH.isPower2(bmpData.width) || !MATH.isPower2(bmpData.height)) throw new Error("Sorry, bitmapdata sheet must be of base 2 dimensions!");
		fillBitmapDataSheet(GROUNDCEIL_TEXTURE_OFFSET, bmpData, GROUNDCEIL_TEXTURE_BASE_DIMENSION, GROUNDCEIL_TEXTURE_BASE_DIMENSION_LOG2);
	}
	public static function parseWallBitmapDataSheet(bmpData:BitmapData):Void {
		if (!MATH.isPower2(bmpData.width) || !MATH.isPower2(bmpData.height)) throw new Error("Sorry, bitmapdata sheet must be of base 2 dimensions!");
		fillBitmapDataSheet(WALL_TEXTURE_OFFSET, bmpData, WALL_TEXTURE_BASE_DIMENSION, WALL_TEXTURE_BASE_DIMENSION_LOG2);
	}
	public static function parseWallBitmapDataSheet2(bmpData:BitmapData):Void {
		if (!MATH.isPower2(bmpData.width) || !MATH.isPower2(bmpData.height)) throw new Error("Sorry, bitmapdata sheet must be of base 2 dimensions!");
		fillBitmapDataSheet(WALL_TEXTURE_OFFSET + (WALL_TEXTURE_SIZE>>1), bmpData, WALL_TEXTURE_BASE_DIMENSION, WALL_TEXTURE_BASE_DIMENSION_LOG2);
	}
	
	static inline function fillBitmapDataSheet(offset:Int, bmpData:BitmapData, baseDimension:Int, logDimension:Int):Void {
		var iLen:Int = bmpData.height >> logDimension; 
		var iLen2:Int =  bmpData.width >> logDimension;
		var iTotalLen:Int = baseDimension * baseDimension;
		
		var counter:Int =  CityAssembly.TEXTURES_ADDRESS + offset;
		var mX:Int;
		var mY:Int;
		for (y in 0...iLen) {
			mY = y << logDimension;
			for (x in 0...iLen2) {
				mX = x << logDimension;
				for (i in 0...iTotalLen) {
					Memory.setI32( counter, bmpData.getPixel(mX + ( i & (baseDimension-1) ), mY+ (i >> logDimension) ) );
					counter+=4;
				}
			}
		}
		
	}


	
}