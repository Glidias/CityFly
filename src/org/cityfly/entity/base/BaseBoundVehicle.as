package org.cityfly.entity.base
{
	import co.uk.swft.base.Entity;
	import org.cityfly.components.spatial.*;
	import org.cityfly.grid.HGridObject;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class BaseBoundVehicle extends BaseRaySprite
	{
		[Inject] public var rotation:Rotation;
		[Inject] public var radius:Radius;
		[Inject] public var bounds3D:Bounds3D;

		
		[Inject] public var gridObj:HGridObject;
		

		
		
		public function BaseBoundVehicle() 
		{
			
		}
		
		override public function mapComponents():void {
			super.mapComponents();
			injector.mapRule(Bounds, injector.mapSingleton(Bounds3D));
			injector.mapSingleton(Rotation);
			injector.mapSingleton(HGridObject);
			injector.mapSingleton(Radius);
		}
		
	}

}