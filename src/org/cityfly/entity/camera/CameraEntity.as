package org.cityfly.entity.camera 
{
	import co.uk.swft.base.Entity;
	import org.cityfly.components.spatial.Position3D;
	import org.cityfly.components.spatial.Rotation;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class CameraEntity extends Entity
	{
		
		public var position:Position3D;
		public var rotation:Rotation;
		
		[Inject]
		public function setPosition(pos:Position3D = null):void {
			position = pos;
		}
		
		[Inject]
		public function setRotation(rot:Rotation = null):void {
			rotation = rot;
		}
		
	
		public function CameraEntity() 
		{
			
		}
		
		override public function onRegister():void {
			position = position || new Position3D();
			rotation = rotation || new Rotation();
		}
		
		
	}

}