package org.cityfly.grid 
{
	import flash.utils.Dictionary;
	
	/**
	 * A grid tile that supports storage of hierachical grids, activation/deactivation etc.
	 * @author Glenn Ko
	 */
	public class HGridTile
	{
		public var grids:Array;  // The list of HGrids in priority order (internal)
		
		// flags and signals
		public var activated:Boolean = false;
		public var isSeen:Boolean = false;

		
		public function HGridTile() 
		{
			
		}
		
		private function addGrid(level:int):HGrid {	// inline
			return null;
		}
		
		private function getGrid(level:int):HGrid {	// inline
			return null;
		}
		
		public function addHGridObject(gridObj:HGridObject):void {
			var grid:HGrid = getGrid(gridObj.level) || addGrid(gridObj.level);
			grid.addGridObject(gridObj);
		}
		
		public function removeHGridObject(gridObj:HGridObject):void {
			var grid:HGrid = getGrid(gridObj.level); // assumed have grid
			grid.removeGridObject(gridObj);
		}
		
		

		
	}

}