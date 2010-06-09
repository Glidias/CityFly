package org.cityfly.grid 
{
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class GridSettings
	{


		public static const MAX_LEVEL:int = 11;	// 2048		//inline
		public static function get MAX_SIZE():int {			//inline
			return 1<<MAX_LEVEL;
		}
		public static const BASE_LEVEL:int = 6; // 64 		// inline
		public static function get BASE_SIZE():int {			//inline
			return 1<<BASE_LEVEL;
		}
		
		// precomputed grid offsets for all levels.
		public static var GRID_OFFSETS:Array = [
			
		];
		
	}

}