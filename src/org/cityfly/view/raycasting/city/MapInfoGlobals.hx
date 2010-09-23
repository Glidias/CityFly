/**
 * Useful retrieval/setting of map data. Nothing needs to be configured here at this time.
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting.city;
import flash.errors.Error;
import flash.Memory;
import flash.Vector;
import flash.utils.Endian;
import flash.system.ApplicationDomain;

class MapInfoGlobals 
{
	public static inline var MAP_SIZE:Int =  CityGlobals.TOTAL_TILES  * 4;	
	
	public static inline var GROUND_MAP_OFFSET:Int = 0;
	public static inline var WALL_MAP_OFFSET:Int =   MAP_SIZE ;
	public static inline var STOREY_MAP_OFFSET:Int =  MAP_SIZE*2 ;
	
	public static inline var TOTAL_MEMORY_SIZE:Int = MAP_SIZE * 3;
	

	public static inline function getGroundInfo(tx:Int, ty:Int):Int {
		return Memory.getI32( GROUND_MAP_OFFSET +  getMapInfoAddressAt(tx,ty)  );
	}
	public static  function getWallInfo(tx:Int, ty:Int):Int {
		
		return Memory.getI32( WALL_MAP_OFFSET +  getMapInfoAddressAt(tx,ty)  );
	}
	public static  function getStoreyInfo(tx:Int, ty:Int):Int {
		return Memory.getI32( STOREY_MAP_OFFSET +  getMapInfoAddressAt(tx,ty)  );
	}
	static  function getMapInfoAddressAt(tx:Int, ty:Int):Int {
		return CityAssembly.MAPINFO_ADDRESS + ( (ty * CityGlobals.MAP_TILES_X + tx) << 2 );
	}
	
	static inline function populateVector(offset:Int, vec:Vector<UInt> ):Void { 
		var len:Int = vec.length;
		var counter:Int = CityAssembly.MAPINFO_ADDRESS + offset;
		for ( i in 0...len) {
			
			Memory.setI32( counter, vec[i] & 0x00FFFFFF );
		
			counter += 4;
		}
	}
	
	static inline function populateAddressArr2d(offset:Int, arr:Array<Dynamic>):Void {
		var len:Int = arr.length;
		var counter:Int = CityAssembly.MAPINFO_ADDRESS + offset;
		for (y in 0...len) {
			var len2:Int = arr[y].length;
			for (x in 0...len2) {
				Memory.setI32( counter, arr[y][x] );
				counter+=4;
			}
		}
	}
	public static function populateGroundInfoVector(arr:Vector<UInt>):Void {
		populateVector(GROUND_MAP_OFFSET, arr);
	}
	public static function populateWallInfoVector(arr:Vector<UInt>):Void {
		populateVector(WALL_MAP_OFFSET, arr);
		
	}
	public static  function populateStoreyInfoVector(arr:Vector<UInt>):Void {
		populateVector(STOREY_MAP_OFFSET, arr);
		for (y in 0...128) {
			
			for (x in 0...128) {
				if ( getStoreyInfo(x, y) < 0) throw new Error("SORRY");
			}
		}

	}
	
	public static function populateGroundInfoArr2d(arr:Array<Dynamic>):Void {
		populateAddressArr2d(GROUND_MAP_OFFSET, arr);
	}
	public static function populateWallInfoArr2d(arr:Array<Dynamic>):Void {
		populateAddressArr2d(WALL_MAP_OFFSET, arr);
	}
	public static function populateStoreyInfoArr2d(arr:Array<Dynamic>):Void {
		populateAddressArr2d(STOREY_MAP_OFFSET, arr);
	}
	
}