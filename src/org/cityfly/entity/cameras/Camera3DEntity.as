package org.cityfly.entity.cameras 
{
	/**
	 * Extended camera entity to support pitch/roll values for full 3D-based camera-control.
	 * @author Glenn Ko
	 */
	public class Camera3DEntity extends CameraEntity
	{
		
		public var pitch:Number = 0;
		public var roll:Number = 0;
		
		public function Camera3DEntity() 
		{
			
		}
		
	}

}