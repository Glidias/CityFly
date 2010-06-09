package org.cityfly.components.spatial 
{
	import co.uk.swft.base.EntityComponent;
	/**
	 * Supports full rotational 3d in all directions for bounding box
	 * 
	 * @author Glenn Ko
	 */
	public class Bounds3DAdvanced extends EntityComponent
	{
		private var _rotation:Rotation3D;
		[Inject]
		public function setRotation(val:Rotation3D = null):void {
			_rotation = val;
		}
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		
		public function Bounds3DAdvanced() 
		{
			
		}
		
	}

}