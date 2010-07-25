/**
 * This is a monkey-patchable TileHeightMovement class in Haxe specific to the City Engine implementation.
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting.city;
import flash.display.BitmapData;

class TileHeightMovement 
{
	public var pX:Float;
	public var pY:Float;
	public var pZ:Float;
	public var pZs:Float;
		
	private var cUpLeft:Bool;
	private var cDownLeft:Bool;
	private var cUpRight:Bool;
	private var cDownRight:Bool;
	
	 static inline var cRadius:Int = 16;

	public function new() 
	{
		pX = 0;
		pY = 0;
		pZ = 0;
		pZs = 0;

		cUpLeft = false;
		cDownLeft = false;
		cUpRight = false;
		cDownRight = false;
	
	}
	
	inline function getMyCorners(x:Float, y:Float):Void {
			// find corner points
			var downY:Int =  CityGlobals.DIVGRID(y + cRadius - 1); 
			var upY:Int = CityGlobals.DIVGRID( y - cRadius);  
			var leftX:Int = CityGlobals.DIVGRID(x-cRadius);
			var rightX:Int = CityGlobals.DIVGRID(x+cRadius-1);
	
			cUpLeft =  ( pZ>MapInfoGlobals.getStoreyInfo(leftX, upY) << CityGlobals.GRIDSIZE_LOG2);
			cDownLeft =   ( pZ>MapInfoGlobals.getStoreyInfo(leftX, downY)<< CityGlobals.GRIDSIZE_LOG2 );
			cUpRight =   ( pZ>MapInfoGlobals.getStoreyInfo(rightX, upY)<< CityGlobals.GRIDSIZE_LOG2 ); 
			cDownRight =   ( pZ>MapInfoGlobals.getStoreyInfo(rightX, downY)<< CityGlobals.GRIDSIZE_LOG2 );
		}
		
		public function moveChar(dirx:Float, diry:Float):Void {
			// vertical movement
			// where are our edges?
			// first we look for y movement, so x is old
			getMyCorners(pX, pY+diry);
			// move got dammit... and check for collisions.
			// going up
			if (diry<-0.1) {
				if (cUpLeft && cUpRight) {
					// no wall in the way, move on
					pY += diry;
				}
			}
			// if going down
			if (diry>0.1) {
				if (cDownLeft && cDownRight) {
					pY += diry;
				} 
			}
			// horisontal movement
			// changing x with speed and taking old y
			getMyCorners(pX+dirx, pY);
			// if going left
			if (dirx<-0.1) {
				if (cDownLeft && cUpLeft) {
					pX += dirx;// take this away for collision detection
				} 
			}
			// if going right
			if (dirx>0.1) {
				if (cUpRight && cDownRight) {
					pX += dirx;
				}
			}
			
			pZs=  CityGlobals.MULGRID( MapInfoGlobals.getStoreyInfo(CityGlobals.DIVGRID(pX), CityGlobals.DIVGRID(pY) ) ) ;

		}
		
		
	}
	
	
