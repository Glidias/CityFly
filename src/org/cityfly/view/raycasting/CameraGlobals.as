package org.cityfly.view.raycasting 
{
	/**
	 *  Camera parameter constants and static methods (meant to be pushed inline...i wished..)
	 * @author Glenn Ko
	 */
	public class CameraGlobals
	{
		// Enable camera roll (will produce extra render resolution dimensions)
		public static const CAMERA_ROLL:Boolean = false;	
		
		public static const MAX_ROLL:Number			= 0.33; //(ppPI/8)
		public static const MAX_PITCH:Number  = 0.33;
		
		public static const CAMERA_RES_WIDE		= 300;
		public static const CAMERA_RES_HIGH		= 240;

		public static const CAMERA_FOV:Number	 = 60; // Field of view - 60 degrees
		public static const CAMERA_HEIGHT:Number = 16;	// How high off the ground to keep the camera
		public static const CAMERA_CLEARANCE:Number	= 16;	// How close to ceiling we can get
		
		public static const DARKNESS_DISTANCE:Number = 500; // FOG DISTANCE
		
		
	}

}