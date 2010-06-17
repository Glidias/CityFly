package org.cityfly.entity.camera 
{
	import org.cityfly.components.spatial.PitchRoll;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class Camera3DEntity extends CameraEntity
	{
		
		
		public var pr:PitchRoll;
		
		public function setPitchRoll(prr:PitchRoll = null):void {
			pr = prr;
		}
		
		public function Camera3DEntity() 
		{
			
		}
		
		override public function onRegister():void {
			super.onRegister();
			pr = pr || new PitchRoll();
		}
		
		
	}

}