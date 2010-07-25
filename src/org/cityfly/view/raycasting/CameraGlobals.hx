/**
 * ...
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting;

//import org.cityfly.common.MATH;

class CameraGlobals 
{
	// Enable camera roll (will produce extra render resolution dimensions)
	public static inline var CAMERA_ROLL:Bool = false;	
		
	public static inline var MAX_ROLL:Float			= 0.33; //(ppPI/8)
	public static inline var MAX_PITCH:Float  = 0.33;
		
	public static inline var CAMERA_RES_WIDE:Int		= 640;
	public static inline var CAMERA_RES_HIGH:Int		= 320;
	public static inline var TOTAL_MEMORY_SIZE:Int = (CAMERA_RES_WIDE * CAMERA_RES_HIGH) << 2;
	
	public static inline var CAMERA_FOV:Float	 = 60; // Field of view - 60 degrees
	
	//  Unused parameters
	public static inline var CAMERA_RENDER_WIDE:Int		= CAMERA_RES_WIDE;
	public static inline var CAMERA_RENDER_HIGH:Int		= CAMERA_RES_HIGH;
	
	public static inline var CAMERA_HEIGHT:Float = 16;	// How high off the ground to keep the camera
	public static inline var CAMERA_CLEARANCE:Float	= 16;	// How close to ceiling we can get	
	public static inline var DARKNESS_DISTANCE:Float = 500; // FOG DISTANCE
	public static inline var  EPSILON:Float	=	0.00000001; // Near enough to zero
		
	/*
	public static inline var CAMERA_RES_WIDE_B2:Int		= 512;
	public static inline var CAMERA_RES_HIGH_B2:Int		= 256;
	public static inline var CAMERA_RES_WIDE_POW2:Int = MATH.ppLog2(CAMERA_RES_WIDE_B2);
	public static inline var CAMERA_RES_HIGH_POW2:Int = MATH.ppLog2(CAMERA_RES_HIGH_B2);
	public static inline var CAMERA_RES_WIDE_POW2_MINUS1:Int = CAMERA_RES_WIDE_POW2 -1;
	public static inline var CAMERA_RES_HIGH_POW2_MINUS1:Int = CAMERA_RES_HIGH_POW2 -1;
	*/

	
}