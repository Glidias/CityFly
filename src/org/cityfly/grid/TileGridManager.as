package org.cityfly.grid 
{

	/**
	 * A HGrid (hierachical hash grid) system manager for broadphase colision detection.
	 * Manages tiles, active tiles for rendering/simulating, grid objects registered to tiles, etc. on a large scale
	 * with the ability to subdivide each tile into recursive sub grids to accomodate different unit sizes.
	 * 
	 * Not done. Just a concept which might/might not work depending on the nature of the game.
	 * 
	 * @author Glenn Ko
	 */
	public class TileGridManager 
	{
		
		private var tiles:Vector.<HGridTile>;
		
		
		public function TileGridManager() 
		{
			
		}
		
		public function setupTiles(w:int, h:int):void {
			
		}
		
		public function registerGridObj(gridObj:HGridObject):void {
			
		}
		public function removeGridObj(gridObj:HGridObject):void {
			
		}
		
		public function simulate():void {
			//HGridTile(rw).getGrid().
		}
		
		
		
		
	}

}