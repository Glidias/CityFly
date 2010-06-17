/**
 * ...
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting;

class CameraGlobals 
{
	// Enable camera roll (will produce extra render resolution dimensions)
	public static inline var CAMERA_ROLL:Bool = false;	
		
	public static inline var MAX_ROLL:Float			= 0.33; //(ppPI/8)
	public static inline var MAX_PITCH:Float  = 0.33;
		
	public static inline var CAMERA_RES_WIDE:Int		= 300;
	public static inline var CAMERA_RES_HIGH:Int		= 240;
		
	public static inline var CAMERA_RENDER_WIDE:Int		= CAMERA_RES_WIDE;
	public static inline var CAMERA_RENDER_HIGH:Int		= CAMERA_RES_HIGH;

	public static inline var CAMERA_FOV:Float	 = 60; // Field of view - 60 degrees
	public static inline var CAMERA_HEIGHT:Float = 16;	// How high off the ground to keep the camera
	public static inline var CAMERA_CLEARANCE:Float	= 16;	// How close to ceiling we can get
		
	public static inline var DARKNESS_DISTANCE:Float = 500; // FOG DISTANCE
		
	
	// Camera/3D paremeters
	public static inline var  EPSILON:Float	=	0.00000001; // Near enough to zero

	
}