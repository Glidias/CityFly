package org.cityfly.entity 
{
	import org.cityfly.entity.base.*;
	import org.cityfly.components.rendering.*;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class Bus extends BaseBoundVehicle
	{
		
		public function Bus() 
		{
			
		}
		
		override public function mapComponents():void {
			super.mapComponents(); 
			_injector.mapRule(IBitmapSource, _injector.mapSingleton(SpriteSheetComponent) );
		}
		
	}

}