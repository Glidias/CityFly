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
	public class HoverCycle extends BaseRaySprite
	{
		[Inject] public var rotation:Rotation;
		[Inject] public var raycastSprite:SpriteSheetComponent;
		
		public function HoverCycle() 
		{
			
		}
		
		override public function mapComponents():void {
			super.mapComponents();
			_injector.mapSingleton(Rotation);
			_injector.mapSingleton(Radius);
			_injector.mapRule(IBitmapSource, _injector.mapSingleton(SpriteSheetComponent) );
		}
		
	}

}