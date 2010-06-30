/**
 * @author Andre Michelle
 * 
 * Ported over to Haxe:
 * 
 * Test with Andre Michelle's Casual Raycaster ported over to Haxe, using world/camera 
 * Haxe inline globals from CityFly to allow refactoring + writing to Alchemy memory.
 * 
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting.andre;

import flash.Error;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Memory;
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;
import flash.utils.Endian;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.Vector;

import org.cityfly.view.raycasting.WorldGlobals;
import org.cityfly.view.raycasting.CameraGlobals;
import org.cityfly.common.MATH;

class AndreRaycasterAlchemy extends BitmapData
{

	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var angle:Float;
	public var roll:Float;
	
		// ANDRE Implementation
		private var map: BitmapData;
		private var iceil: BitmapData;
		private var ifloor: BitmapData;
		private var iwall: BitmapData;
		
				
		public static inline var CAMERA_WIDE:Int = CameraGlobals.CAMERA_RES_WIDE;
		public static inline var CAMERA_HIGH:Int = CameraGlobals.CAMERA_RES_HIGH;

		//-- PRE COMPUTE --//
		private static inline var fov:Float = CameraGlobals.CAMERA_FOV * MATH.ppDeg2Rad;
		private static inline var BUFFER_BYTES:Int = CAMERA_WIDE * CAMERA_HIGH * 4;
		private var eyeDistance:Float;
		private var subRayAngle:Float;
		private var p_center:Float;
		
		private static var sin:Vector<Float> = MATH.instance.sinTable;
		private static var cos:Vector<Float> = MATH.instance.cosTable;
		private static var tan:Vector<Float> = MATH.instance.tanTable;
		
		
		public var bitmapMemory:ByteArray;
		

		
		private function setTBmp(tbmp:Bitmap = null):Void {
			if (tbmp == null) return;
			var textures:BitmapData = tbmp.bitmapData;
			
			ifloor = new BitmapData( 64, 64, false, 0xffcc00 );
			iceil  = new BitmapData( 64, 64, false, 0xff0000 );
			iwall  = new BitmapData( 64, 64, false, 0xcccccc );
			ifloor.copyPixels( textures, new Rectangle( 0, 0, 64, 64 ), new Point( 0, 0 ) );
			iceil.copyPixels( textures, new Rectangle( 64, 0, 64, 64 ), new Point( 0, 0 ) );
			iwall.copyPixels( textures, new Rectangle( 128, 0, 64, 64 ), new Point( 0, 0 ) );
		}
		
	
	public function new() 
	{
		super(CAMERA_WIDE, CAMERA_HIGH, false, 0);
		bitmapMemory = new ByteArray();
		bitmapMemory.endian = Endian.LITTLE_ENDIAN;
		bitmapMemory.length = BUFFER_BYTES;
		Memory.select(bitmapMemory);
	}
	
	private inline function setPixelMem(xVal:Int, yVal:Int, color:UInt):Void {
		Memory.setI32( ( yVal * CAMERA_WIDE + xVal ) << 2, color);
	}
	
	
	/**
	 * Initialises the raycaster with required dependencies
	 * @param	tBmp
	 * @param	map
	 */
	public function init(tBmp:Bitmap, map:BitmapData=null):Void {
		// setup dependencies
		this.map  = map;
		setTBmp(tBmp);
		// PRECOMPUTE
		eyeDistance = ( CAMERA_WIDE / 2 ) / Math.tan( fov / 2 );
		subRayAngle = fov / CAMERA_WIDE;	
		// Random start if no map dependency supplied
		if (map == null) randomStart();
	}
	
	public function randomStart():Void {
		// fill map randomly
		map = new BitmapData( WorldGlobals.MAP_TILES_X, WorldGlobals.MAP_TILES_Y, false, 0 );
		
		for(iy in 0...WorldGlobals.MAP_TILES_Y )
		{
			for(ix in 0...WorldGlobals.MAP_TILES_X)
			{
				map.setPixel( ix, iy, Math.random() < .1 ? 1 : 0 );
			}
		}
	}
	

	public function render():Void {
		
		ApplicationDomain.currentDomain.domainMemory.position = 0;
		lock();
		
		
		
		//-- LOCAL VARIABLES --//
		var rx: Int = WorldGlobals.DIVGRID(x);
		var ry: Int = WorldGlobals.DIVGRID(y); 
		
		var tx: Int = rx;
		var ty: Int = ry;
		
		var ax: Float;
		var ay: Float;
		var dx: Float;
		var dy: Float;
		var distance: Float;
		
		var offset: Float = 0;
		var nearest: Float;
		var beta: Float;
		var ht: Float;
		var tn: Float;
		var cs: Float;
		var sn: Float;
		
		var distort: Float;
		var cf: Float;
		var ff: Float;
		var c0: Int;
		var c1: Int;
		var dg: Int;
		
		var color: Int;
		
		//-- clamp angle for lookup tables
		if( angle < 0 ) angle += MATH.pp2PI;
		if( angle > MATH.pp2PI) angle -= MATH.pp2PI;
		
		var a: Float = angle + fov * .5;
		if( a > MATH.pp2PI ) a -= MATH.pp2PI;
		
		var sx: Int = CAMERA_WIDE - 1;
		var sy: Int;
		
		//-- PRECOMPUTE --//
		p_center = CAMERA_HIGH / 2 - roll;
		var oz: Float = 64 - z;
		
		var ang: Int = Std.int( angle * ( 3600 / MATH.ppPI ) ) | 0;

		while( --sx > -1 )
		{
			nearest = Math.POSITIVE_INFINITY;
			
			dg = Std.int( a * ( 3600 / MATH.ppPI ) ) >> 0;
			
			tn = tan[ dg ];
			sn = sin[ dg ];
			cs = cos[ dg ];

			rx = tx;
			ry = ty;
			
			if ( sn < 0 )
			{
				while( ry > -1 && rx > -1 && rx < WorldGlobals.MAP_TILES_X )
				{
			ay = WorldGlobals.MULGRID(ry); //ry << 6;
			ax = x + ( ay - y ) / tn;
			rx =  WorldGlobals.DIVGRID(ax); //ax >> 6;
			
			ry--;
			
			if ( map.getPixel( rx, ry ) != 0 )
			{
				dx = ax - x;
				dy = ay - y;
				
				nearest = dx * dx + dy * dy;
				offset = WorldGlobals.OFFSET_NORTH(ax);   // hit north
				break;
			}
				}
			}
			else
			{
				while( ry < WorldGlobals.MAP_TILES_Y && rx > -1 && rx < WorldGlobals.MAP_TILES_X )
				{
				++ry;
			
			ay = WorldGlobals.MULGRID(ry); 
			ax = x + ( ay - y ) / tn;
			rx =  WorldGlobals.DIVGRID(ax); 
			
			if ( map.getPixel( rx, ry ) != 0 )
			{
				dx = ax - x;
				dy = ay - y;
				
				nearest = dx * dx + dy * dy;
				offset = WorldGlobals.OFFSET_SOUTH(ax);	// hit south
				break;
			}
				}
			}
			rx = tx;
			ry = ty;
			if ( cs < 0 )
			{
				while( rx > -1 && ry > -1 && ry < WorldGlobals.MAP_TILES_Y )
				{
			ax = WorldGlobals.MULGRID(rx); 
			ay = y + ( ax - x ) * tn;
			ry = WorldGlobals.DIVGRID(ay); 
			
			rx--;
			
			if ( map.getPixel( rx, ry ) != 0 )
			{
				dx = ax - x;
				dy = ay - y;
				
				distance = dx * dx + dy * dy;
				
				if ( distance < nearest )
				{
					nearest = distance;
					offset = WorldGlobals.OFFSET_WEST(ay);  // hit west
				}
				break;
			}
				}
			}
			else
			{
				while( rx < WorldGlobals.MAP_TILES_X && ry > -1 && ry < WorldGlobals.MAP_TILES_Y )
				{
			++rx;
			ax = WorldGlobals.MULGRID(rx); 
			ay = y + ( ax - x ) * tn;
			ry = WorldGlobals.DIVGRID(ay);
			
			if ( map.getPixel( rx, ry ) != 0 )
			{
				dx = ax - x;
				dy = ay - y;
				
				distance = dx * dx + dy * dy;
				
				if ( distance < nearest )
				{
					nearest = distance;
					offset = WorldGlobals.OFFSET_EAST(ay);	// hit east
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
			
			ht = Math.isFinite(nearest) ? distort / Math.sqrt( nearest ) : 0;
			
			cf = oz * distort;
			ff =  z * distort;

			c0 = Std.int( p_center - ht * oz );
			c1 = Std.int( p_center + ht * z + .5 );
			
			sy = CAMERA_HIGH;
			
			while( --sy > c1 )
			{
				if( sy < 0 ) break;
				
				//-- FLOOR TILES --//
				distance = ff / ( sy - p_center );
				
				color = ifloor.getPixel( Std.int( x + cs * distance ) & 63, Std.int( y + sn * distance ) & 63 );
				
				
				setPixelMem( sx, sy, color );
			}

			while( --sy > c0 )
			{
				if( sy < 0 ) break;
				
				//-- BLOCKS --//
				color = iwall.getPixel( Std.int(offset), Std.int(( sy - c0 ) / ht) );
				
				setPixelMem( sx, sy, color );
			}
			
			while( --sy > -1 )
			{
				if( sy < 0 ) break;
				
				//-- CEILING --//
				distance = cf / ( p_center - sy );
				
				color = iceil.getPixel( Std.int( x + cs * distance ) & 63, Std.int( y + sn * distance ) & 63 );
				
				
				setPixelMem( sx, sy, color );
			}
			
			a -= subRayAngle;
			
			if( a < 0 ) a += MATH.pp2PI;
		}
		
		
		setPixels( rect, ApplicationDomain.currentDomain.domainMemory);
		unlock();	
	}
	

}