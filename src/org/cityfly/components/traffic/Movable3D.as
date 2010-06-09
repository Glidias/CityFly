package org.cityfly.components.traffic 
{
	import co.uk.swft.base.EntityComponent;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class Movable3D extends EntityComponent
	{
		private var _collidable:Collidable3D;
		public function setCollidable(collidable:Collidable3D=null):void {
			_collidable = collidable;
		}
		
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var vz:Number = 0;
		
		public function Movable3D() 
		{
			
		}
		
		public function move(vx:Number = 0; vy:Number = 0; vz:Number = 0):void {
			
		}
		
	}

}