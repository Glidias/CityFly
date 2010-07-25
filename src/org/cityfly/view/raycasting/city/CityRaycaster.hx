/**
 * @author Andre Michelle
 * @author Glenn Ko (aka. Glidias)
 * 
 * Modified casual raycaster engine (did up long ago) to render cities ported over to Haxe.
 * Everything is read/written though memory assemblies.
 * 
 */

package org.cityfly.view.raycasting.city;

import flash.Error;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Memory;
import flash.system.ApplicationDomain;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.Vector;

import org.cityfly.view.raycasting.city.CityGlobals;
import org.cityfly.view.raycasting.CameraGlobals;
import org.cityfly.common.MATH;

class CityRaycaster extends BitmapData
{
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var angle:Float;
	public var roll:Float;

	static inline var CAMERA_WIDE:Int = CameraGlobals.CAMERA_RES_WIDE;
	static inline var CAMERA_HIGH:Int = CameraGlobals.CAMERA_RES_HIGH;
	static inline var H_CAMERA_WIDE:Int = Std.int(CAMERA_WIDE * .5);
	static inline var H_CAMERA_HIGHF:Int = Std.int(CAMERA_HIGH * .5);

	//-- PRE COMPUTE --//
	private static inline var fov:Float = CameraGlobals.CAMERA_FOV * MATH.ppDeg2Rad;
	private static inline var h_fov:Float = fov * .5;
	private static inline var eyeDistance:Float = H_CAMERA_WIDE / Math.tan( h_fov );
	private static inline var subRayAngle:Float = fov / CAMERA_WIDE;

	var p_center:Float;
		
	static var sin:Vector<Float> = MATH.instance.sinTable;
	static var cos:Vector<Float> = MATH.instance.cosTable;
	static var tan:Vector<Float> = MATH.instance.tanTable;

	
	var mapG: BitmapData;
	var mapB: BitmapData;
	var mapS: BitmapData;
	

	
	public function new(  ) 
	{
		super(CAMERA_WIDE, CAMERA_HIGH, false, 0);	
		x = 0; y = 0; z = 0; angle = 0; roll = 0;
	}
	

	
	inline function setPixelMem(xVal:Int, yVal:Int, color:UInt):Void {

		Memory.setI32(  ( yVal * CAMERA_WIDE + xVal ) << 2, color);

	}
	
	inline function fillAll(color:UInt):Void { 
		var i:Int = 0;
		
		while( i < (CAMERA_HIGH*CAMERA_WIDE) ) {
			Memory.setI32(  i <<  2, color);
			i++;
		}
	}	

	
	public function render():Void {
		
		lock();
		ApplicationDomain.currentDomain.domainMemory.position = CityAssembly.CAMERA_ADDRESS;
		
		/*
		ApplicationDomain.currentDomain.domainMemory.position = CityAssembly.TEXTURES_ADDRESS + 0*TextureGlobals.GROUNDCEIL_TEXTURE_BASE_BYTES;
		setPixels( new Rectangle(0,0,128,400), ApplicationDomain.currentDomain.domainMemory);
		unlock();
		return;
		*/
		
		//-- LOCAL VARIABLES --//
		
		var rx: Int = CityGlobals.DIVGRID(x);
		var ry: Int = CityGlobals.DIVGRID(y); 
		
		var tx: Int = rx;
		var ty: Int = ry;
		
					
		var bxr: Int;
		var bxl: Int;
		var byu: Int; 
		var byd: Int; // boundaries
		
		var ax: Float;
		var ay: Float;
		var dx: Float;
		var dy: Float;
		var distance: Float;
		
		var offset: Int = 0;
		var nearest: Float;
		var ht: Float;
		var tn: Float;
		var cs: Float;
		var sn: Float;
		
		var distort: Float;
		var cf: Float;
		var ff: Float;
		var c0: Int; // floor limit
		var c1: Int;  // wall limit
		var ch: Int;// current height of scanner at column
		var dg: Int;
		
		var color: Int;
		var oz: Float;
		
		var zs: Int = 0;		//storyey position of ray hit
		var pzs: Int; 	 //prev-curr storey position of ray
		var zt:Float;  // actual distance from current floor ray is standing on

		
		 // extra  vars
		var cx: Int;  
		var cy: Int; // last known ray hit position
					
		var wX: Float;
		var wY: Float;
		var no: Int = 0;
		
		// -- Reset stuff
		ch = CAMERA_HIGH;	
		// Upper and lower tile limits (visible distance of 64 for now)
		// This inlined statements could be optmised
		byu=ry-64<1 ? 1 : ry-64;
		byd=ry+64> CityGlobals.MAP_TILES_Y ? CityGlobals.MAP_TILES_Y : ry+64;
		bxl=rx-64<1 ? 1 : rx-64;
		bxr = rx + 64 > CityGlobals.MAP_TILES_X ? CityGlobals.MAP_TILES_X : rx + 64;
		
		
		//-- clamp angle for lookup tables
		angle -= angle < 0 ? -MATH.pp2PI : angle > MATH.pp2PI ?  MATH.pp2PI : 0;
		
		
		var a: Float = angle + h_fov;
		a -= a > MATH.pp2PI ? MATH.pp2PI : 0;
		
		
		// Camera scanner variables
		var sx: Int = CAMERA_WIDE - 1;
		var sy: Int;
		
		//-- PRECOMPUTE --//
		p_center = CAMERA_HIGH * .5 - roll;
		var ang: Int = Std.int( angle * ( 3600 / MATH.ppPI ) ) | 0;
		
		fillAll(0xD3DFDD);
		//fillRect(rect, 0xD3DFDD);	// Fill Background Color first for the camera screens

		while( --sx > -1 )
		{
			// Reset our stuff
			nearest = Math.POSITIVE_INFINITY;
			cx=999;
			cy=999;
			dg = Std.int( a * ( 3600 / MATH.ppPI ) ) >> 0;
			tn = tan[ dg ];
			sn = sin[ dg ];
			cs = cos[ dg ];

			// Start ray at player tile-position
			// Begin raycasting for intersection for walls along x-axis
			rx = tx;
			ry = ty;
			pzs = MapInfoGlobals.getStoreyInfo(rx,ry);
			
			if ( sn < 0 )  // Ray is going upwards
			{
				while( ry > byu )
				{
					ay = CityGlobals.MULGRID(ry);
					ax = x + ( ay - y ) / tn;
					rx =  CityGlobals.DIVGRID(ax); 
				
					ry--;
					
				//if (  rx < 0 || rx > CityGlobals.MAP_TILES_X -1 || ry < 0 || ry > CityGlobals.MAP_TILES_Y-1 ) break;
				
					if ( rx < bxl  ||  rx > bxr  ) break;  // visible distance break
					
					zs = MapInfoGlobals.getStoreyInfo(rx,ry);	
					no = MapInfoGlobals.getWallInfo(rx, ry); //MapInfoGlobals.getWallInfo(rx,ry);
					
				
					if (  zs != pzs ) {
						cx = rx; 			
						cy = ry; 
					
						offset = CityGlobals.OFFSET_NORTH(ax); 
						dx = ax - x;
						dy = ay - y;
						nearest = dx * dx + dy * dy;
						break; // break out of loop, go straight to y-axis intersection calculation
					}
				}
			}
			else	// ray is going downwards
			{
				while( ry < byd   )
				{
					++ry;
			
					ay = CityGlobals.MULGRID(ry); 
					ax = x + ( ay - y ) / tn;
					rx =  CityGlobals.DIVGRID(ax); 
					
					if ( rx < bxl || rx > bxr) break;  // visible distance break
					
					zs=MapInfoGlobals.getStoreyInfo(rx,ry);
					no=MapInfoGlobals.getWallInfo(rx,ry);
			
					if (  zs != pzs ) {
						cx=rx; 
						cy = ry;
						offset = CityGlobals.OFFSET_SOUTH(ax);	
						
						dx = ax - x;
						dy = ay - y;
						nearest = dx * dx + dy * dy; 
						break; // break out of loop, go straight to y-axis intersection calculation
					}
				}
			}
			
			// Start ray at player tile-position
			// Begin raycasting for intersection for walls along y-axis
			rx = tx;
			ry = ty;
			pzs = MapInfoGlobals.getStoreyInfo(rx,ry);
			if ( cs < 0 )   // ray is going leftwards
			{
				while(  rx > bxl )
				{
					ax = CityGlobals.MULGRID(rx); 
					ay = y + ( ax - x ) * tn;
					ry = CityGlobals.DIVGRID(ay); 
			
					rx--;
					
					if (ry < byu || ry > byd) break;  // visible distance break
			
					if ( MapInfoGlobals.getStoreyInfo(rx,ry) != pzs  ) // hit wall along y-axis
					{
						dx = ax - x;
						dy = ay - y;
						distance = dx * dx + dy * dy;
						
						if ( distance < nearest )
						{
							nearest = distance;
							offset = CityGlobals.OFFSET_WEST(ay);  
							
							no=MapInfoGlobals.getWallInfo(rx,ry);
							zs=MapInfoGlobals.getStoreyInfo(rx,ry); 
							cx=rx; 
							cy=ry;
						}
						break;
					}
				}
			}
			else	// ray is going rightwards 
			{
				while( rx < bxr )
				{
					++rx;
					ax = CityGlobals.MULGRID(rx); 
					ay = y + ( ax - x ) * tn;
					ry = CityGlobals.DIVGRID(ay);
					
					if (ry < byu || ry > byd ) break; // visible distance break
					
					if ( MapInfoGlobals.getStoreyInfo(rx,ry) != pzs )
					{
						dx = ax - x;
						dy = ay - y;
						
						distance = dx * dx + dy * dy;
						
						
						if ( distance < nearest )
						{
							nearest = distance;
							offset = CityGlobals.OFFSET_EAST(ay);	
							
							no=MapInfoGlobals.getWallInfo(rx,ry);
							zs=MapInfoGlobals.getStoreyInfo(rx,ry); 
							cx=rx; 
							cy=ry;
						}
						break;
					}
				}
			}
			
			if( dg < ang )
			{
				distort = eyeDistance / cos[ 7200 + dg - ang ];
			}
			else
			{
				distort = eyeDistance / cos[ dg - ang ];
				
			}
			
	
			ht = Math.isFinite(nearest) ? distort / Math.sqrt( nearest ) : 0; // forego method call?
			
				
			oz = zs * CityGlobals.GRIDSIZE - z;
			//cf = oz * distort / 16; //cf is distance to ceiling
			zt = z - pzs * CityGlobals.GRIDSIZE; // actual distance from current floor ray is standing on
			ff =  zt * distort; // ff is distance to floor
				
			c1 = Std.int( p_center + ht * zt + .5); //limit for floor // why + .5?? need to check
			c0 = Std.int( p_center - ht * oz ); //limit for wall 
			
			sy = ch;
			
			
			while( --sy > c1 )
			{
				if( sy < 0 ) break;
				
				//-- DRAW FLOOR --//
				distance = ff / ( sy - p_center ); 
				if ( sy > ch ) break;
				
				wX= x + cs * distance;
				wY = y + sn * distance;
				var gTx:Int = CityGlobals.DIVGRID(wX);
				var gTy:Int = CityGlobals.DIVGRID(wY);
				if (  gTx < 0 || gTx > CityGlobals.MAP_TILES_X -1 || gTy < 0 || gTy > CityGlobals.MAP_TILES_Y-1 ) break;
	
				setPixelMem( sx, sy, TextureGlobals.getGroundColor( MapInfoGlobals.getGroundInfo(gTx,gTy) - 1, CityGlobals.MODGRID(wX), CityGlobals.MODGRID(wY) ) ); 
			
				ch=sy;
			}
			
			distance = ff / ( c1 + 1 - p_center) ; // find out again why this is required
			sy++;  // < - and this..

			while( sy-- > c0  )
				{
					if( sy < 0 || sy > ch  ) break;
					//-- DRAW BLOCK --//
					var Sh:Int= Std.int( ( sy - c0 ) / ht ) & 127 ;
					var She:Int = Std.int(  zs * 128 - ( sy - c0 ) / ht );  
						
					color = She  < CityGlobals.GRIDSIZE ? TextureGlobals.getWallColor(no - 1, offset, Sh) :  TextureGlobals.getWallColor( no + (TextureGlobals.WALL_TEXTURE_SIZE >> 1) - 1, offset, Sh );
					// Do the coloring
					setPixelMem( sx, sy, color );  
				
					ch=sy;
				}
				sy++;
				
				// Reupdate position
				sy=c0+1;  
				//sy=c0;
				/*
				while( --sy > -1 )
				{
					if( sy < 0 ) break;
					
					//-- CEILING --//
					distance = cf / ( p_center - sy );
					wX= (x + cs * distance);
					wY= (y + sn * distance);
					color = iceil.getPixel( wX&127, wY&127 );
					setPixel( sx, sy, color );
				}
				*/
				
				// Ending 
				if ( c0 < 2 || ch < 2 || cx==999 || cy==999) {
					tx = CityGlobals.DIVGRID(x);
					ty = CityGlobals.DIVGRID(y);
					a -= subRayAngle;
					if( a < 0 ) a += Math.PI * 2;
					ch=height;
				}
				else {
					sx++;
					tx = cx;
					ty = cy;
				}

			}

		
			setPixels( rect, ApplicationDomain.currentDomain.domainMemory);
			unlock();
			
	}
	

}