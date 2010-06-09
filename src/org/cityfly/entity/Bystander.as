package org.cityfly.entity 
{
	import co.uk.swft.base.Entity;
	import org.cityfly.components.rendering.*;
	import org.cityfly.components.spatial.*;
	import org.cityfly.entity.base.*;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class Bystander extends BaseRaySprite
	{
		[Inject] public var radius:Radius;
		[Inject] public var raycastSprite:SpriteSheetAnimComponent;
		
		public function Bystander() 
		{
			
		}
		
		override public function mapComponents():void {
			super.mapComponents();
			_injector.mapSingleton(Radius);
			_injector.mapRule(IBitmapSource, _injector.mapSingleton(SpriteSheetAnimComponent) );
		}
	}

}