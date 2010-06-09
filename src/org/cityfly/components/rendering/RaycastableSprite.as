package org.cityfly.components.rendering 
{
	import co.uk.swft.base.EntityComponent;
	import flash.display.BitmapData;
	import org.cityfly.components.spatial.Position3D;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	
	
	public class RaycastableSprite extends EntityComponent
	{
		[Inject]
		public var bitmapSrc:IBitmapSource;
		
		[Inject]
		public var position:Position3D;
		
		public function RaycastableSprite() 
		{
			
		}

		
	}

}