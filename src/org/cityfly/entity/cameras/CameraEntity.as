package org.cityfly.entity.cameras 
{
	import org.cityfly.components.spatial.Position;
	import org.cityfly.components.spatial.Rotation;
	/**
	 * Basic camera entity for 3D/pseudo3D-based views.
	 * @author Glenn Ko
	 */
	public class CameraEntity
	{
		
		public var position:Position;	// camera position
		
		[Inject]
		public function setPosition(val:Position=null):void {
			position = val || new Position();
		}
		
		public var rotation:Rotation;  // camera yaw
		
		[Inject]
		public function setRotation(val:Rotation=null):void {
			rotation = val || new Rotation();
		}
		
		public function CameraEntity() 
		{
			
		}
		
	}

}