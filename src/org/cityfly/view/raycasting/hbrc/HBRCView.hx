/**
 * Half-Baked Raycaster View component implementation by David Mace. (uses C-preprocessor to compile stuff)
 * http://hbrc.sourceforge.net/
 * @author David Mace
 *
 * - WHat's different about this raycaster is that it does per-floor-tile shading, and variable
 * support for floating storey blocks.
 * 
 * -WIP port to Haxe-
 * 
 * @author Glenn Ko
 */

package org.cityfly.view.raycasting.hbrc;

import flash.display.PixelSnapping;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import org.cityfly.view.raycasting.CameraGlobals;
import org.cityfly.view.raycasting.WorldGlobals;
import org.cityfly.common.MATH;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.Vector;

import org.cityfly.view.raycasting.hbrc.HBRCGlobals;


class HBRCView extends Sprite
{
	public function new() 
	{
		super();
		pX  = 0; pY = 0; pZ = 0; pPitch = 0; pRoll = 0; pHeading = 0;
		distanceClip = 0;
	}
	
	public var  pX:Float;
	public var  pY:Float;
	public var  pZ:Float;
	public var  pPitch:Float;
	public var  pRoll:Float;
	public var  pHeading:Float;
							
			
	
	// Proprocessor settings
	private static var GOT_ROLL:Bool = true;
	private static var USE_LIGHTING_EFFECTS:Bool = true;
	
	
	// COMMON CAMERA VIEW
		private static inline var fovStraight:Float = MATH.ppRadians(CameraGlobals.CAMERA_FOV);		// How wide a view angle
		private static inline var hFOVStraight:Float = .5 * fovStraight;

#if GOT_ROLL
		private static inline var FOV:Float = MATH.ppRadians(CameraGlobals.CAMERA_FOV * MATH.ppSQRT2);		// How wide a view angle
#else		
		private static inline var FOV:Float = MATH.ppRadians(CameraGlobals.CAMERA_FOV);		// How wide a view angle
#end

		private static inline var hFOV:Float = .5 * FOV;

		private static inline var projectionPlaneDistance:Float = ( CameraGlobals.CAMERA_RENDER_WIDE / 2 ) / Math.tan(hFOV );		// Projection plane distance
		private static inline var projectionPlaneScale:Float = 1/projectionPlaneDistance;			// Shortcut to turn divisions Int multiplications
		private static inline var fovLineAngle:Float = FOV / CameraGlobals.CAMERA_RENDER_WIDE;	// Field of view - pixels to radians
		private static inline var ifovLineAngle:Float = CameraGlobals.CAMERA_RENDER_WIDE / FOV;	// Field of view - radians to pixels
		
		// COMMON VIEW
		
		/** Place to render onto */
		private var bmd:BitmapData;
		/** Clipping parameters for possibly rotated view */
		private var bitmap:Bitmap;
		
		
		// HALF-BAKED RAYCASTER IMPLEMENTATION
	
		// Set fade distance in world coordinates 
		public var 	distanceClip:UInt; // = 400;
		private static inline var fadeColor:UInt = 0x000000;	// Fade value
		public static inline var  gamma:Float = 1.0;		// Brightness of stuff before fade is applied
		public static inline var 	shaded:Float = 0.50;	// How deep shadows are
		
		// Layer to put the sprites in; easily 'nuked' to remove all sprites 
		private var spriteLayer:Sprite;
		
		// Everything is contained by this, and then by translated. 
		private var translated : Sprite;

		// Clipping parameters for possibly rotated view, and to keep sprites in bounds
		private var clipping:Shape;

		// Z Map for sprite clipping (vertical run-lengths of {depth,top,bottom})
		// TODO: Convert to vector
		private var zmask: Vector<Sliver>;

		// Sorted list of sprites that are currently visible 
		//[ArrayElementType("WorldSprite")]
		//private var spriteList : Array<Dynamic>;
		
		
		// inlines...
		static inline var GRIDSIZE:Int = WorldGlobals.GRIDSIZE;
		static inline var TEXI_WEST:Int = HBRCGlobals.TEXI_WEST;
		static inline var TEXI_NORTH:Int = HBRCGlobals.TEXI_NORTH;
		static inline var TEXI_SOUTH:Int = HBRCGlobals.TEXI_SOUTH;
		static inline var TEXI_EAST:Int = HBRCGlobals.TEXI_EAST;
		static inline var  xCenter:Int = Std.int(CameraGlobals.CAMERA_RENDER_WIDE * .5);

		
		static var  cellMapShape:BitmapData ;	// Map of world geometry shapes
		
		static var  mapHighest:Int = WorldGlobals.world.highest;		// Highest point in map
		static var  cellWidth : Int = WorldGlobals.world.cellbounds.width;
		static var  cellLut : Array<Dynamic> = WorldGlobals.world.cells;	// Shortcut to cells array
		
		
		public function init(mapShape:BitmapData):Void {
			// or generaterandom
			
			cellMapShape = mapShape;
			translated = new Sprite();
			addChild(translated);
			bmd = new BitmapData(CameraGlobals.CAMERA_RENDER_WIDE,CameraGlobals.CAMERA_RENDER_HIGH,false,0xff000000);
			bitmap = new Bitmap(bmd, PixelSnapping.AUTO, true);
			//bitmap.filters = [new BlurFilter(2,2,flash.filters.BitmapFilterQuality.LOW)];
			translated.addChildAt(bitmap,0);
			spriteLayer = new Sprite();
			translated.addChildAt(spriteLayer,1);
			clipping = new Shape();
			clipping.visible = false;
			zmask = new Vector<Sliver>(CameraGlobals.CAMERA_RENDER_WIDE); // true, see how to sweep this aside without destoying length
#if GOT_ROLL
			// We want to be able to roll the camera, so Bitmap must be centered
			bitmap.x = -CameraGlobals.CAMERA_RENDER_WIDE*.5;
			bitmap.y = -CameraGlobals.CAMERA_RENDER_HIGH*.5;
			spriteLayer.x = -CameraGlobals.CAMERA_RENDER_WIDE*.5;
			spriteLayer.y = -CameraGlobals.CAMERA_RENDER_HIGH*.5;
			clipping.graphics.beginFill(0);
			clipping.graphics.drawRect(-CameraGlobals.CAMERA_RES_WIDE*.5,-CameraGlobals.CAMERA_RES_HIGH*.5,CameraGlobals.CAMERA_RES_WIDE,CameraGlobals.CAMERA_RES_HIGH);
			clipping.graphics.endFill();
			
#else
			clipping.graphics.beginFill(0);
			clipping.graphics.drawRect(0,0,CameraGlobals.CAMERA_RES_WIDE,CameraGlobals.CAMERA_RES_HIGH);
			clipping.graphics.endFill();	
#end
			addChild(clipping);
			translated.mask = clipping;
			SetScreenPos();
		}
		

		/**
		 * Set screen position
		**/
		private inline function SetScreenPos( x:Int = 0, y:Int = 0 ) : Void
		{
			// Sprite's model of position is based on its contents.
			// Its contents are centered on the Bitmap
			// Positon by upper, left corner, accordingly
#if GOT_ROLL
			translated.x = x + (CameraGlobals.CAMERA_RES_WIDE*.5);
			translated.y = y + (CameraGlobals.CAMERA_RES_HIGH*.5);
			clipping.x = x + (CameraGlobals.CAMERA_RES_WIDE*.5);
			clipping.y = y + (CameraGlobals.CAMERA_RES_HIGH*.5);
#else
			translated.x = x;
			translated.y = y;		
#end
		}
		
		
		
		private function ClipListNew():Void {
			
		}
		
		private function ClipListCleanup():Void {
			
		}
		
		private function ClipListAdd(callbackMethod, newZ, light, newTop, newBottom):Void {
			
		}
		
		private function drawFunc(rsliver):Void {
			
		}
		
		private function BreakIfClipListSolid():Void {
			
		}
		
		public function render():Void {

			
			
			var  yCenter:Float = (CameraGlobals.CAMERA_RENDER_HIGH * .5) + (GRIDSIZE * projectionPlaneScale) + (Math.tan(pPitch) * CameraGlobals.CAMERA_RENDER_HIGH);
		

			
			/*
			// Copy previous render values and wrap yaw/pitch/roll
			XYZ_Copy( posprev, pos );
			YPR_Copy( yprprev, ypr );
			*/
			// Projection details filled out by last render
			// Center of field of view
			

	
			// Nasty little kludge: Don't sit on edges  (this should be factored out elsewhere by world)
			/*
			if( Math.abs(Math.floor(pX)-pX) < 0.001 )
				pX += .001;
			if( Math.abs(Math.floor(pY)-pY) < 0.001 )
				pY += .001;
			*/
			 var  xStart:Float = pX;
			 var  yStart:Float = pY;
			 var  clipRect:Rectangle = WorldGlobals.world.getWorldBounds();			// Boundary for cell iteration
			//var clipRectExit:Object = {};  // todo: what does clipRectExit do???		
			 var  cColorTransform:ColorTransform = new ColorTransform();
			
			
//#ifdef CAMERA_ROLL


			 var  xrayLeft:Int = 0 == translated.rotation ? Std.int((CameraGlobals.CAMERA_RENDER_WIDE-CameraGlobals.CAMERA_RES_WIDE)*.5) : 0;
			 var  xrayRight:Int = 0 == translated.rotation ? Std.int( CameraGlobals.CAMERA_RENDER_WIDE - ((CameraGlobals.CAMERA_RENDER_WIDE-CameraGlobals.CAMERA_RES_WIDE)*.5) ) : CameraGlobals.CAMERA_RENDER_WIDE;
			var fovLeft:Float = 0 == translated.rotation ? MATH.ppRadianWrapPI(pHeading - hFOVStraight) : MATH.ppRadianWrapPI(pHeading - (hFOV));	// Camera field of view; left edge relative to viewing angle
			//inline var  fovRight:Float = 0 == translated.rotation ? MATH.ppRadianWrapPI(pHeading + hFOVStraight) : MATH.ppRadianWrapPI(pHeading + hFOV); 	// Camera field of view; right edge relative to viewing angle
//#else
/*
			inline var  fovLeft:Float = ppRadianWrapPI(pHeading(ypr) - hFOV);		// Camera field of view; left edge relative to viewing angle
			//inline var  fovRight:Float = ppRadianWrapPI(pHeading(ypr) + hFOV); 	// Camera field of view; right edge relative to viewing angle
			inline var  xrayLeft:Float = 0;
			inline var  xrayRight:Float = CAMERA_RENDER_WIDE;
			*/
//#endif


			var xray:Int;							// Current ray x - screen coordinate
			var ray:Float;							// Currently rendered ray angle
			var rcos:Float;						// Cosine of current ray
			var rsin:Float;						// Sine of current ray

			// Don't bother iterating cells beyond this boundary; they're faded invisible
			
			if( 0 != distanceClip )
			{
				clipRect.left = MATH.ppMax(WorldGlobals.ROUNDGRID(pX-distanceClip), Std.int(clipRect.left));
				clipRect.top = MATH.ppMax(WorldGlobals.ROUNDGRID(pY-distanceClip),Std.int(clipRect.top));
				clipRect.right = MATH.ppMin(WorldGlobals.ROUNDGRID(pX+distanceClip)+GRIDSIZE,Std.int(clipRect.right));
				clipRect.bottom = MATH.ppMin(WorldGlobals.ROUNDGRID(pY+distanceClip)+GRIDSIZE,Std.int(clipRect.bottom)); 
			}
			
			
			// Sweep old zmask aside
			zmask.length = 0;
			zmask.length = CameraGlobals.CAMERA_RENDER_WIDE;

			// Texture variables
			var rSliver:Rectangle = new Rectangle(0,0,1,0); 	// Box around Sliver for functions that need it (could be two ints, but hope for better 2D primitives)
			var row:Int;					// Current on-screen row
			var remain:Int;					// Working var for countdowns
			var texcol:Float;				// Current texel column
			var texrow:Float;				// Current texel row
			var texstep:Float;				// Stepping value for flat textures
			var drow:Float;				// Delta-row
			var pixel:UInt;					// Currently painted texel/pixel
			var distance:Float;			// How far away...
			var distorted:Float;			// Cosine-distorted distance (fishbowl filter)
			var scale:Float;				// Scaling value to apply to something
			var findroofpoint:Float;		// Partialy cooked search value for rooftop/ceiling points
			var findfloorpoint:Float;		// Partially cooked, distorted value for floor pixel-finding renderings
			var highGround:Int;				// Last rendered ground Sliver offset from bottom of window
			var enterGround:Int;			// Where current cell exits at ground level
			var exitGround:Int;				// Where current cell exits at ground level
			var bmpFrom:BitmapData;			// Cache source bitmapData used to do pixel operations
			var hmodmask:Int;				// Size of ground tile textures; assumed to be square and a power of 2
			var vmodmask:Int;				// Size of ground tile textures; assumed to be square and a power of 2
			
			// Z clipping list.  Collects previously drawn things in z-indexed strips
			// For each strip of new 'something' added to display, mask it with clipping list
			// When the input list is done, we have a z map of the display
			// This will be applied to sprites as an intersection with sprite bounding box and Z strips
			var zlistCurr:Sliver;	// Current Z strip (singly linked list)

			// Variables used in ClipListAdd, BreakIfClipListSolid
			var currslice:Sliver;	/* Current slice */
			var sliceprev:Sliver;	/* Previous slice */
			var slicenext:Sliver;	/* Next slice */
			var newtop:Int;			/* Top of new slice being considered */
			var newbottom:Int;		/* Bottom of new slice being considered */
			var newz:Float;		/* Distance from camera of new slice being considered */
			var lighting:Float;	/* Lighting effect to apply */
			
			// Iterate rays with our cell handler list
			bmd.lock();
			ray = fovLeft;
			xray++;
			
			for( xray in xrayLeft...xrayRight )
			{
				
				// Set up Sliver clipping for this ray
				ClipListNew();
				
				rSliver.x = xray;
				rSliver.width = 1;
				
				// Precalculate some things that are used a lot
				findfloorpoint = pZ*projectionPlaneDistance/distorted; /* Precalculate floor searching value */
				distorted = Math.cos( ray - pHeading );	/* Precalculate 'fishbowl' */
				highGround = CameraGlobals.CAMERA_RENDER_HIGH;	/* Last rendered ground height */
				rcos = Math.cos(ray);
				rsin = Math.sin(ray);

			
				
				// Find cells that current ray intersects and callback cell renderer
				/**
				 * Iterate each cell along a ray to edge of map in order.
				 * Quick, but a little complicated.  
				 * 'Typical' implementation does x, then y, but you get two lists.
				 * We go through this to remove a merge/sort needed for non-solid objects.
				**/
				var xEnd:Float = pX+rcos;
				var yEnd:Float = pY+rsin;

				// Iteration parameters
				var cellx:Int = WorldGlobals.ROUNDGRID(xStart);
				var celly:Int = WorldGlobals.ROUNDGRID(yStart);
				var cellxNext:Int;
				var cellyNext:Int;
				var dx:Float = xEnd-xStart;
				var dy:Float = yEnd-yStart;

				// Exit
				var xExit:Float;	// Where the ray exits
				var yExit:Float;
				var edgeExit:Int;
				var texelNext:Float;	// Where textel will hit next time
				var edgeNext:Int;	// What edge will hit next time

				// Entry
				var xEnter:Float = xStart;	// Where the ray enters; initially INSIDE
				var yEnter:Float = yStart;
				var edgeEnter:Int = HBRCGlobals.TEXI_INSIDE;
				var texelHit:Float = -1;		// Where a generic, flat wall texel hits
				
	
				
				while( cellx >= clipRect.left && celly >= clipRect.top && cellx < clipRect.right && celly < clipRect.bottom )
				{
					
						// Find entry/exit points
					if( MATH.ppAbs(dx) > MATH.ppAbs(dy) ) 
					{
						if( dx < 0 )
						{	// Should exit left edge
							xExit = cellx;
							yExit = yStart + ((xExit-xStart) * dy / dx);
							if( yExit < celly )
							{	// Exits top
								yExit = celly;
								xExit = xStart + ((yExit-yStart) * dx / dy);
								edgeExit = TEXI_NORTH;
								edgeNext = TEXI_SOUTH;
								texelNext = (xExit%GRIDSIZE);
								cellxNext = cellx;
								cellyNext = celly - GRIDSIZE;
							}
							else if( yExit > celly+GRIDSIZE )
							{	// Exits bottom
								yExit = celly + GRIDSIZE;
								xExit = xStart + ((yExit-yStart) * dx / dy);
								edgeExit = TEXI_SOUTH;
								edgeNext = TEXI_NORTH;
								texelNext = GRIDSIZE-(xExit%GRIDSIZE);
								cellxNext = cellx;
								cellyNext = celly + GRIDSIZE;
							}
							else
							{	// First shot was right; calculate the rest
								edgeExit = TEXI_WEST;
								edgeNext = TEXI_EAST;
								texelNext = GRIDSIZE-(yExit%GRIDSIZE);
								cellxNext = cellx - GRIDSIZE;
								cellyNext = celly;
							}
						}
						else //if( dx > 0 )
						{	// Should exit right edge
							xExit = cellx + GRIDSIZE;
							yExit = yStart + ((xExit-xStart) * dy / dx);
							if( yExit < celly )
							{	// Exits top
								yExit = celly;
								xExit = xStart + ((yExit-yStart) * dx / dy);
								edgeExit = TEXI_NORTH;
								edgeNext = TEXI_SOUTH;
								texelNext = (xExit%GRIDSIZE);
								cellxNext = cellx;
								cellyNext = celly - GRIDSIZE;
							}
							else if( yExit > celly+GRIDSIZE )
							{	// Exits bottom
								yExit = celly + GRIDSIZE;
								xExit = xStart + ((yExit-yStart) * dx / dy);
								edgeExit = TEXI_SOUTH;
								edgeNext = TEXI_NORTH;
								texelNext = GRIDSIZE-(xExit%GRIDSIZE);
								cellxNext = cellx;
								cellyNext = celly + GRIDSIZE;
							}
							else
							{	// First shot was right; calculate the rest
								edgeExit = TEXI_EAST;
								edgeNext = TEXI_WEST;
								texelNext = (yExit%GRIDSIZE);
								cellxNext = cellx + GRIDSIZE;
								cellyNext = celly;
							}
						}
					}
					else // Math.abs(dy) >= Math.abs(dx) - More likely to strike top/bottom first
					{
						if( dy < 0 )   
						{	// Exits top
							yExit = celly;
							xExit = xStart + ((yExit-yStart) * dx / dy);
							if( xExit < cellx )
							{	// Exit left edge
								xExit = cellx;
								yExit = yStart + ((xExit-xStart) * dy / dx);
								edgeExit = TEXI_WEST;
								edgeNext = TEXI_EAST;
								texelNext = GRIDSIZE-(yExit%GRIDSIZE);
								cellxNext = cellx - GRIDSIZE;
								cellyNext = celly;
							}
							else if( xExit > cellx + GRIDSIZE )
							{	// Exit right edge
								xExit = cellx + GRIDSIZE;
								yExit = yStart + ((xExit-xStart) * dy / dx);
								edgeExit = TEXI_EAST;
								edgeNext = TEXI_WEST;
								texelNext = (yExit%GRIDSIZE);
								cellxNext = cellx + GRIDSIZE;
								cellyNext = celly;
							}
							else
							{	// First shot was right; calculate the rest
								edgeExit = TEXI_NORTH;
								edgeNext = TEXI_SOUTH;
								texelNext = (xExit%GRIDSIZE);
								cellxNext = cellx;
								cellyNext = celly - GRIDSIZE;
							}
						}
						else // if( dy >= 0 )
						{	// Exits bottom
							yExit = celly + GRIDSIZE;
							xExit = xStart + ((yExit-yStart) * dx / dy);
							if( xExit < cellx )
							{	// Exit left edge
								xExit = cellx;
								yExit = yStart + ((xExit-xStart) * dy / dx);
								edgeExit = TEXI_WEST;
								edgeNext = TEXI_EAST;
								texelNext = GRIDSIZE-(yExit%GRIDSIZE);
								cellxNext = cellx - GRIDSIZE;
								cellyNext = celly;
							}
							else if( xExit > cellx + GRIDSIZE )
							{	// Exit right edge
								xExit = cellx + GRIDSIZE;
								yExit = yStart + ((xExit-xStart) * dy / dx);
								edgeExit = TEXI_EAST;
								edgeNext = TEXI_WEST;
								texelNext = (yExit%GRIDSIZE);
								cellxNext = cellx + GRIDSIZE;
								cellyNext = celly;
							}
							else
							{	// First shot was right; calculate the rest
								edgeExit = TEXI_SOUTH;
								edgeNext = TEXI_NORTH;
								texelNext = GRIDSIZE-(xExit%GRIDSIZE);
								cellxNext = cellx;
								cellyNext = celly + GRIDSIZE;
							}
						}
					}
			

					// Cell working variables
					var umask:UInt;			/* Cell's basic property mask */
					var cx:Int;				/* Cell's info coordinate */
					var cy:Int;				/* Cell's info coordinate */
					var cellID:Int;			/* Lookup into cell detail table */
					var cellDetails:Dynamic;	/* Details about texture/color/etc. */   // todo: must be factored
					var cellbottom:Int;		/* Bottom of cell in world coordinates */
					var celltop:Int;		/* Top of cell in world coordinates*/
					var cellbase:Int;		/* Bottom of cell, adjusted by pZ */
					var celloffset:Int;		/* Height of cell subtracted off cellbase for screen coordinate work */
					var cell:Dynamic;		/* Details about current map cell */		// todo: must be factored
					var enterDistance:Float; /* Distance at ray entrance of cell */
					var enterDistanceDistorted:Float; /* Distance at ray entrance of cell, cos distorted */
					var enterLighting:Float;	/* Lighting to apply to entrance */
					var enterScale:Float;	/* Scaling value to apply to enter coordinates */
					var enterBottom:Int;	/* Bottom of visible enter */
					var enterTop:Int;		/* Top of visible entry */
					var exitDistance:Float;/* Distance at ray exit of cell */
					var exitDistanceDistorted:Float;/* Distance at ray exit of cell, cos distorted */
					var exitLighting:Float;/* Lighting to apply at exit */
					var exitScale:Float;	/* Scaling value to apply to enter coordinates */
					var exitBottom:Int;		/* Bottom of visible exit */
					var exitTop:Int;		/* Top of exit */
					
					
				var  DrawGround = drawFunc; //	groundwallpaper(rsliver)
				var  DrawCeiling	= drawFunc;  //ceilingsliver(rsliver)
				var  DrawRoof 	= drawFunc;	  //roofsliver(rsliver)
				var  DrawWall		= drawFunc;  //wallsliver(rsliver)
				var  DrawWallpaper	= drawFunc; // wallpapersliver(rsliver)
				var  DrawFill		= drawFunc;  //bmd.fillRect(rsliver, pixel)
				var  DrawSky		= drawFunc;  //skysliver(rsliver)
					
				
					
					// Draw walls, ceiling if top < camera height, floor if bottom < camera height
					// Floor, ceiling, wall
					cx = WorldGlobals.DIVGRID(cellx);
					cy = WorldGlobals.DIVGRID(celly);
					cellID = (cellWidth * cy) + cx;
					cellDetails = cellLut[cellID];
					umask = cellMapShape.getPixel(cx, cy);
					
				
					if( HBRCGlobals.MAP_IS_FLAT(umask) )
					{	// Fill ground at each Z
#if USE_LIGHTING_EFFECTS
						if( distanceClip!=0 )
						{
							// Note: don't do any of this and there's a nifty reflective effect on the ground
							exitDistance = Math.sqrt( ((xStart-xExit)*(xStart-xExit))+((yStart-yExit)*(yStart-yExit)) ) * distorted;
							exitScale = projectionPlaneDistance / exitDistance;
							exitGround = yCenter + (pZ * exitScale);
							exitLighting = gamma-(exitDistance/distanceClip);
							if( exitLighting <= 0 )
							{	// Can't see any further?  Stop iterating
								break;
							}
							if( exitGround < highGround )
							{	// Fill in ground up to change in altitude
								bmpFrom = WorldGlobals.Resource.ground;
								
								ClipListAdd( DrawGround, exitDistance, exitLighting, exitGround, highGround );
								highGround = exitGround;
							}
						}
#end
					}
					
					else
					{
						cellbottom = HBRCGlobals.MAP_BASE_GET(umask);
						celltop = HBRCGlobals.MAP_BASE_GET(umask) + HBRCGlobals.MAP_HEIGHT_GET(umask);
						cellbase = Std.int(pZ - cellbottom);
						celloffset = Std.int(pZ - celltop);
						if( edgeEnter == HBRCGlobals.TEXI_INSIDE )
						{	// First cell with camera in it
							enterDistanceDistorted = enterDistance = 0;
							enterScale = distorted;
							if( HBRCGlobals.MAP_BASE_GET(umask) > pZ )
							{
								enterBottom = 0;
								enterTop = 0;
							}
							else
							{
								enterBottom = CameraGlobals.CAMERA_RENDER_HIGH;
								enterTop = CameraGlobals.CAMERA_RENDER_HIGH;
							}
							enterGround = CameraGlobals.CAMERA_RENDER_HIGH;
						}
						else
						{	// Note - undistorted distance makes better shader
							enterDistance = Math.sqrt( ((xStart-xEnter)*(xStart-xEnter))+((yStart-yEnter)*(yStart-yEnter)) );
							enterDistanceDistorted = enterDistance*distorted;
							if( distanceClip!=0 && enterDistance >= distanceClip )
							{	// Can't see this far
								break;
							}
							enterScale = Std.int(projectionPlaneDistance / enterDistanceDistorted);
							enterBottom = Std.int(yCenter + Math.ceil(cellbase * enterScale));
							enterTop = Std.int(yCenter + (celloffset * enterScale));
							enterGround = Std.int(yCenter + Math.ceil(pZ * enterScale));
						}
						exitDistance = Math.sqrt( ((xStart-xExit)*(xStart-xExit))+((yStart-yExit)*(yStart-yExit)) );
						exitDistanceDistorted = exitDistance * distorted;
						if( distanceClip!=0)
						{
							enterLighting = gamma-(enterDistance/distanceClip);
							exitLighting = gamma-(exitDistance/distanceClip);
							if( enterLighting <= 0 )
								break;
						}
						else
						{
							enterLighting = exitLighting = 1;
						}

						if( 0 != exitDistance )
						{
							var checkType = cellDetails.walls[edgeEnter];  // todo: factor
							exitScale = projectionPlaneDistance / exitDistanceDistorted;
							exitBottom = Std.int(yCenter + (cellbase * exitScale));
							exitTop = Std.int(yCenter + (celloffset * exitScale));
							exitGround = Std.int(yCenter + (pZ * exitScale));
							if( Std.is(checkType, Int) )
							{
								pixel = checkType;
								ClipListAdd( DrawFill, enterDistanceDistorted, enterLighting, enterTop, enterBottom );
							}
							/*
							else if( MAP_FILL_STRETCH == MAP_FILL_GET(umask) )
							{
								bmpFrom = checkType;
								ClipListAdd( DrawWall, enterDistanceDistorted, enterLighting, enterTop, enterBottom );
							}
							*/
							else
							{
								bmpFrom = checkType;
								ClipListAdd( DrawWallpaper, enterDistanceDistorted, enterLighting, enterTop, enterBottom );
							}
							if( pZ < cellbottom && exitBottom > enterBottom )
							{	// Draw ceiling if above camera
								bmpFrom = cellDetails.b;
								ClipListAdd( DrawCeiling, exitDistanceDistorted, distanceClip ? enterLighting : shaded, enterBottom,exitBottom );
							}
							if( pZ > celltop && exitTop < enterTop )
							{	// Draw roof if below camera
								bmpFrom = cellDetails.t;
								ClipListAdd( DrawRoof, exitDistanceDistorted, exitLighting, exitTop, enterTop );
							}
							if( distanceClip )
							{
								bmpFrom = WorldGlobals.Resource.ground;
								ClipListAdd( DrawGround, exitDistance, exitLighting, exitGround, enterGround );
								highGround = exitGround;
							}
							else
							{
								if( 0 != cellbottom )
								{
									bmpFrom = WorldGlobals.Resource.ground;
									ClipListAdd( DrawGround, exitDistance, shaded, exitGround, enterGround );
								}
							}
						}
						// Stop iterating blocks if whole Sliver is drawn
						BreakIfClipListSolid();
					}
					
				
					
					// Next iteration
					cellx = cellxNext;
					celly = cellyNext;
					xEnter = xExit;
					yEnter = yExit;
					edgeEnter = edgeNext;
					texelHit = texelNext;
				}
				
				// Make sure extra fill has 'bogus' cell id
//#ifdef USE_LIGHTING_EFFECTS
				cellID = -1;
				if( 0 == distanceClip )
				{
//#endif
					// Fill in sky; make it very distant so it doesn't clip sprites
					pixel = 0xff80B0ff;
					ClipListAdd( DrawFill, Int.MAX_VALUE,1, 0, yCenter );
	
					// Fill in undrawn ground; make it very distant so it doesn't clip sprites
					bmpFrom = WorldGlobals.Resource.ground;
					ClipListAdd( DrawGround, Int.MAX_VALUE,1, yCenter, CameraGlobals.CAMERA_RENDER_HIGH );
//#ifdef USE_LIGHTING_EFFECTS
				}
				else
				{
//#if 0
					// Fill in leftover sky/ground
					bmpFrom = WorldGlobals.Resource.panorama;
					ClipListAdd( DrawSky, Int.MAX_VALUE,1, 0, CameraGlobals.CAMERA_RENDER_HIGH );
//#else
					pixel = 0xff000000|fadeColor;
					ClipListAdd( DrawFill, Int.MAX_VALUE,1, 0, CameraGlobals.CAMERA_RENDER_HIGH );
//#endif
				}
//#endif
				// Clean up redundant slices in z clip for this strip
				ClipListCleanup();
				
			
				ray += fovLineAngle;
			}   // end For loop
			
//#ifdef USE_LIGHTING_EFFECTS
			// Apply lighting effexts to image in one go
			// Easy to turn off, dyke out, and it's a smaller loop on data
			rSliver.width = 1;
			
			xray++;
			for( xray in xrayLeft...xRayRight )
			{
				rSliver.x = xray;
				currslice = zmask[xray];
				while( null != currslice )
				{
					lighting = currslice.lighting;
					if( 1 != lighting )
					{
						rSliver.top = currslice.ytop;
						rSliver.bottom = currslice.ybottom;
						cColorTransform.redMultiplier = lighting;
						cColorTransform.greenMultiplier = lighting;
						cColorTransform.blueMultiplier = lighting;
						bmd.colorTransform( rSliver, cColorTransform );
					}
					currslice = currslice.next;
				}
			}
//#endif
			bmd.unlock();
		
		}

	
}


class Sliver {
	
	public var depth:Float;
	public var ytop:Float;
	public var ybottom:Float;
	public var cell:Float;
	public var lighting:Float;
	public var next:Sliver;
	
	function new( depth:Float, top:Float, bottom:Float, cell:Float, lighting:Float, next:Sliver )
	{
		this.depth = depth;
		this.ytop = top;
		this.ybottom = bottom;
		this.cell = cell;
		this.lighting = lighting;
		this.next = next;
	}
}