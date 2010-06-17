package org.cityfly.view.raycasting
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.cityfly.components.spatial.Position3D;
	import org.cityfly.components.spatial.Rotation;
	import org.cityfly.entity.cameras.Camera3DEntity;
	import org.cityfly.entity.cameras.CameraEntity;
	/**
	 * Half-Baked Raycaster View component implementation
	 * @author Glenn Ko
	 */
	public class HBRCView extends Sprite
	{
		// COMMON CITY-FLY 
		private var _cam3D:Camera3DEntity;
		
		[Inject]
		public function set camera(entity:Camera3DEntity):void {
			_cam3D = entity;
		}
		
		// COMMON VIEW
		
		/** Place to render onto */
		private var bmd:BitmapData;
		/** Clipping parameters for possibly rotated view */
		private var bitmap:Bitmap;
		
		
		// HALF-BAKED RAYCASTER IMPLEMENTATION
	
		// Set fade distance in world coordinates 
		public var 	distanceClip:uint;// = 400;
		public var 	fadeColor:uint = 0x000000;	// Fade value
		public var  gamma:Number = 1.0;		// Brightness of stuff before fade is applied
		public var 	shaded:Number = 0.50;	// How deep shadows are
		
		// Layer to put the sprites in; easily 'nuked' to remove all sprites 
		private var spriteLayer:Sprite;
		
		// Everything is contained by this, and then by translated. 
		private var translated : Sprite;

		// Clipping parameters for possibly rotated view, and to keep sprites in bounds
		private var clipping:Shape;

		// Z Map for sprite clipping (vertical run-lengths of {depth,top,bottom})
		private var zmask : Array;

		// Sorted list of sprites that are currently visible 
		//[ArrayElementType("WorldSprite")]
		private var spriteList : Array;
		
	
		
		[PostConstruct]
		public function init():void {
			
		}
		
		
		public function HBRCView() 
		{
		
		}

		
		public function render():void {
			
		}
		
	}

}