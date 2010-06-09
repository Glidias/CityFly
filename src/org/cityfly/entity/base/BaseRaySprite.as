package org.cityfly.entity.base 
{
	import co.uk.swft.base.Entity;
	import org.cityfly.components.rendering.RaycastableSprite;
	import org.cityfly.components.spatial.*;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class BaseRaySprite extends Entity
	{
		[Inject] public var position:Position3D;
		[Inject] public var raycast:RaycastableSprite;
		
		
		public function BaseRaySprite() 
		{
			
		}
		
		override public function mapComponents():void {
			injector.mapRule(Position, injector.mapSingleton(Position3D));
			injector.mapSingleton(RaycastableSprite);
		}
		
	}

}