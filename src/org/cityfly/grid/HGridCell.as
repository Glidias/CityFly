package org.cityfly.grid 
{
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class HGridCell
	{
		public static const ALLOC_SIZE:int = 3;
		
		private var HGridObjects:Vector.<HGridObject> = new Vector.<HGridObject>(ALLOC_SIZE); // inline
		private var _numObjects:int = 0;  													 // inline
		
		// Precompute
		public var offset_array:Array;  // offset array for unique neighbouring border cells // - refer to grid settings
		
		public function HGridCell(offset_array:Array=null) 
		{
			this.offset_array = offset_array;
		}
		
		public function remove(gridObj:HGridObject):Boolean {	// inline
			var index:int = HGridObjects.indexOf(gridObj);
			if (index > -1) {
				var lastIndex:int = _numObjects - 1;
				if (index < lastIndex) {
					var pushBackitem:HGridObject = HGridObjects[lastIndex];
					HGridObjects[index] = pushBackitem;
					HGridObjects[lastIndex] = null;
				}
				else {
					HGridObjects[lastIndex] = null;
				}
				_numObjects--;
				return true
			}
			return false;
		}
		
		
		public function add(gridObj:HGridObject):void {		// inline
			HGridObjects[_numObjects] = gridObj;
			_numObjects++;
		}
		
		
		public function get numObjects():int {
			return _numObjects;
		}
		
	}

}