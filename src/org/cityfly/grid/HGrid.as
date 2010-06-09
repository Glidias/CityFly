package org.cityfly.grid 
{
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class HGrid
	{
		public var occupiedCells:Array;	// The list of occupied HGridCells
		public var cells:Vector.<HGridCell>;
		public var level:int;
		
		// Precompute
		public var offset_array:Array; // = refer to grid settings based on current level, global offset array for all inner cells
		
		public function HGrid(level:int) 
		{
			this.level = level;
			var maxSize:int = 1<<GridSettings.MAX_LEVEL;
			var dirSize:int = maxSize >> (GridSettings.BASE_LEVEL + level - 1);
			cells = new Vector.<HGridCell>( dirSize*dirSize  , false);
		}
		
		public function addGridObject(val:HGridObject):void {
			var gridIndex:int; // get grid index based off current position of grid object
			var gridCell:HGridCell = cells[gridIndex];
			gridCell.add(val);
			val.lastGridCellIndex = gridIndex;
		}
		public function removeGridObject(val:HGridObject):void {
			var gridIndex:int = val.lastGridCellIndex; // get grid index based off current position of grid object
			var gridCell:HGridCell = cells[gridIndex];
			gridCell.remove(val);
			val.lastGridCellIndex = -1;
		}
		
	}

}