package org.cityfly.components.spatial 
{
	import co.uk.swft.base.EntityComponent;
	import flash.geom.Rectangle;
	import org.robotlegs.core.IInjector;
	/**
	 * Bounding box sizing and information in 2d x/y direction
	 * @author Glenn Ko
	 */
	public class Bounds extends EntityComponent
	{
		private var _rotation:Rotation;
		[Inject]
		public function setRotation(val:Rotation = null):void {
			_rotation = val;
		
		}
		

		public var x:Number = 0;
		public var y:Number = 0;
		
		public function Bounds() 
		{
			
		}
		
		
	}

}