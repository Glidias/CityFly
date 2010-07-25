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
	
	public var cHeight:Float;

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
		
		cHeight = 72 * .5 * .5;  // <- this is a hardcoded temporary and needs a proper setting
	}
	
	inline function getMyCorners(x:Float, y:Float):Void {
			// find corner points
			var downY:Int = Std.int((y+cHeight-1)/CityGlobals.GRIDSIZE);
			var upY:Int = Std.int((y-cHeight)/CityGlobals.GRIDSIZE);
			var leftX:Int =Std.int((x-cHeight)/CityGlobals.GRIDSIZE);
			var rightX:Int = Std.int((x+cHeight-1)/CityGlobals.GRIDSIZE);
	
			cUpLeft =  ( pZ>MapInfoGlobals.getStoreyInfo(leftX, upY)*CityGlobals.GRIDSIZE ) ;
			cDownLeft =   ( pZ>MapInfoGlobals.getStoreyInfo(leftX, downY)*CityGlobals.GRIDSIZE );
			cUpRight =   ( pZ>MapInfoGlobals.getStoreyInfo(rightX, upY)*CityGlobals.GRIDSIZE ); 
			cDownRight =   ( pZ>MapInfoGlobals.getStoreyInfo(rightX, downY)*CityGlobals.GRIDSIZE );
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
			
			pZs= MapInfoGlobals.getStoreyInfo(CityGlobals.DIVGRID(pX), CityGlobals.DIVGRID(pY) );

		}
		
		
	}
	
	
