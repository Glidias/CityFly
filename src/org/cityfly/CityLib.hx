/**
 * All precompiled stuff to be compiled to SWC library from Haxe, core game engines, 
 * static inline variables/methods, etc. The reason for using Haxe to compile any game engines is obvious,
 * you get better raw performance.
 * 
 * Just run citylib.hxml in the src folder to compile updates.
 * 
 * Until Haxe supports compiling meta-data (hopefully, in future releases), 
 * you must manually inject the necessary raw values into Haxe-compiled classes 
 * through CityFly's mediators, managers, etc, and call the necessary functions to execute them,
 * rather than allowing them to interact with Swft/CityFly directly.
 * 
 * As such, all Haxe-based engines are ignorant of the Swft framework or what's going on in the CityFly game.
 * 
 * @author Glenn Ko
 */

package org.cityfly;

// Core lib

import org.cityfly.common.MATH;
import org.cityfly.view.raycasting.WorldGlobals;
import org.cityfly.view.raycasting.CameraGlobals;

// Raycaster implementations

// andre 
import org.cityfly.view.raycasting.andre.AndreRaycaster;
// half-baked ra
import org.cityfly.view.raycasting.hbrc.HBRCGlobals;
import org.cityfly.view.raycasting.hbrc.HBRCView;


class CityLib 
{
	
	
	static function main():Void {
		
	}
	

	
}