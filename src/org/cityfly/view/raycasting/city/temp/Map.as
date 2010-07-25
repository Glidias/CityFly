package org.cityfly.view.raycasting.city.temp
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Old legacy stuff from very old demo...Temp.
	 */
	public class Map
	{
		[ArrayElementType("int")]
		public var map0:Array;
		[ArrayElementType("int")]
		public var mapBuildings:Array;
		[ArrayElementType("int")]
		public var mapStorey:Array;
		
		private var groundMap:BitmapData;
		private var blockMap:BitmapData;
		private var storeyMap:BitmapData;
		
		public function Map()
		{
			include "demo0.as";
			include "demobuildings.as";
			include "demostorey.as";
			
			var ix:int;
			var iy:int;
			
			//Create groundmap
			groundMap=new BitmapData(128,128,false,117);
			for (iy=0; iy<map0.length; iy++) {
				for (ix=0; ix<map0[0].length; ix++) {
					groundMap.setPixel(ix, iy, map0[iy][ix]);
				}
			}
			
			//Create blockmap
			blockMap=new BitmapData(128,128,false,0);
			for (iy=0; iy<mapBuildings.length; iy++) {
				for (ix=0; ix<mapBuildings[0].length; ix++) {
					blockMap.setPixel(ix, iy, mapBuildings[iy][ix]);
				}
			}
			
			//Create StoreyMap from blockMap
			storeyMap = new BitmapData(128, 128, false, 0);
			
			for (iy=0; iy<storeyMap.height; iy++) {
				for (ix=0; ix<storeyMap.width; ix++) {
					if ( blockMap.getPixel(ix,iy) > 0 ) storeyMap.setPixel( ix,iy,2 ) ;
				}
			}
			
			//reupdate Storey Map with actual storey map
			for (iy=0; iy<storeyMap.height; iy++) {
				for (ix=0; ix<storeyMap.width; ix++) {
					if ( mapStorey[iy][ix] > 0 ) storeyMap.setPixel( ix, iy, mapStorey[iy][ix] - 192 ) ;
					
				}
			}
			
			
			//Readjust blockmap for 3d engine
			for (iy=0; iy<blockMap.height; iy++) {
				for (ix=0; ix<blockMap.width; ix++) {
					var col:int=blockMap.getPixel(ix, iy) %128;
					blockMap.setPixel( ix, iy, col  );
				}
			}
			
			


			
		}
		
		public function disposeAll():void {
			groundMap.dispose();
			blockMap.dispose();
			storeyMap.dispose();
			map0 = null;
			mapStorey = null;
			mapBuildings = null;
			groundMap = null;
			blockMap = null;
			storeyMap = null;
		}
		
		public function getGroundMap(): BitmapData 
		{
			return groundMap;
		}
		
		public function getBlockMap(): BitmapData 
		{
			return blockMap;
		}
		
		public function getStoreyMap(): BitmapData 
		{
			return storeyMap;
		}
	}
		
}