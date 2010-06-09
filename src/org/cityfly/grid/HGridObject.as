package org.cityfly.grid 
{
	import org.cityfly.components.spatial.*
	import co.uk.swft.base.EntityComponent;


	/**
	 * H-grid object to support narrow-phase collision detection/avoidance within 2-dimensional hash grids.
	 * @author Glenn Ko
	 */
	public class HGridObject extends EntityComponent
	{
		[Inject]
		public var position:Position;
		
		
		public var radius:Radius;
		public var bounds:Bounds;
		[Inject]
		public function setRadius(val:Radius=null):void {
			radius  = val;
		}
		[Inject]
		public function setBounds(val:Bounds=null):void {
			bounds = val;
		}
		
		
	
		
		// precompute/save
		public var level:int = 0;
		public var lastGridCellIndex:int = -1;  
		
		public function HGridObject() 
		{
			
		}
		
		[PostConstruct]
		public function validateSize():void {	// this should also be called everytime the size updates.
			if (bounds == null && radius == null) radius = new Radius();
			
			var curLevel:int;
			var MAX_LEVEL:int = GridSettings.MAX_LEVEL;
	
			
			if (bounds !=null) {
				//using spatial box/convex solid calculation to determine leel
			}
			else {
				// else use bounding radius to determine level
				var diameter:int = (radius.value << 1);
				curLevel = GridSettings.BASE_LEVEL;
				while( 1<<curLevel < diameter) {
					if (level > MAX_LEVEL) {
						throw new Error("Grid object diameter exceeded maximum size of tile!");
					}
					level++;
					curLevel++;
				}
			}
		}
		
	}

}