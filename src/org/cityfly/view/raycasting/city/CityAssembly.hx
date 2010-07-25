/**
 * Central source of starting memory addresses in bytes
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting.city;
import flash.utils.ByteArray;
import org.cityfly.view.raycasting.CameraGlobals;
import flash.utils.Endian;
import flash.Memory;

class CityAssembly 
{
	public static var MEMORY:ByteArray;
		
	public function new() {
		MEMORY = new ByteArray();
		MEMORY.endian = Endian.LITTLE_ENDIAN;
		MEMORY.length = TOTAL_MEMORY_SIZE;
		MEMORY.position = 0;
		Memory.select(MEMORY);
	}

	public static inline var CAMERA_ADDRESS:Int = 0;
	public static inline var TEXTURES_ADDRESS:Int = CAMERA_ADDRESS + CameraGlobals.TOTAL_MEMORY_SIZE;
	public static inline var MAPINFO_ADDRESS:Int =  TEXTURES_ADDRESS + TextureGlobals.TOTAL_MEMORY_SIZE;
	
	public static inline var TOTAL_MEMORY_SIZE:Int = CameraGlobals.TOTAL_MEMORY_SIZE +
													TextureGlobals.TOTAL_MEMORY_SIZE +
													 MapInfoGlobals.TOTAL_MEMORY_SIZE
													;
													
}