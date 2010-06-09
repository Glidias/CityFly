package org.cityfly.components.rendering 
{
	import co.uk.swft.base.EntityComponent;
	import flash.display.BitmapData;
	import org.cityfly.components.spatial.Rotation;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class SpriteSheetComponent extends EntityComponent implements IBitmapSource
	{
		
		private var _bitmapData:BitmapData;
		
		public var rotationSteps:Number = 8;
		private var _rotation:Rotation;

		[Inject(name="SpriteSheetComponent")]
		public function setRotation(val:Rotation=null):void {
			_rotation = val;
		}
		
	
		[Inject(name="SpriteSheetComponent")]
		public function setBitmapData(bmpData:BitmapData = null):void {
			if (bmpData) bitmapData = bmpData;
		}
		
		public function set bitmapData(bmpData:BitmapData):void {
			_bitmapData =  bmpData;
			
		}
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		
		public function SpriteSheetComponent() 
		{
			
		}
		
	}

}