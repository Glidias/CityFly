package org.cityfly.view.raycasting.andre 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import org.cityfly.common.FPS;
	import org.cityfly.components.spatial.PitchRoll;
	import org.cityfly.components.spatial.Position3D;
	import org.cityfly.components.spatial.Rotation;
	import org.cityfly.entity.camera.Camera3DEntity;
	import org.cityfly.view.raycasting.WorldGlobals;
	/**
	 * Test to run/mediate Andre's CasualRaycaster which was compiled in Haxe
	 * @author Glenn Ko
	 */
	public class AndreViewAlchemyTest extends Sprite
	{
		private var bounds: Rectangle;
		private const origin: Point = new Point();
		private var mouseDown:Boolean = false;
		
		// COMMON CITYFLY
		private var _camPosition:Position3D;
		private var _camYaw:Rotation;
		private var _camPR:PitchRoll;
		[Inject]
		public function set camera(entity:Camera3DEntity):void {
			_camPosition = entity.position;
			_camYaw = entity.rotation;
			_camPR = entity.pr;
			
			_camPosition.x = WorldGlobals.GRIDSIZE * WorldGlobals.GRIDSIZE + WorldGlobals.GRIDSIZE*.5;
			_camPosition.y = WorldGlobals.GRIDSIZE * WorldGlobals.GRIDSIZE + WorldGlobals.GRIDSIZE*.5;
			_camPosition.z = 32;
			
			// This shuold be updated on every frame loop in real non-test versions		
			engine.x = _camPosition.x;
			engine.y = _camPosition.y;
			engine.z = _camPosition.z;
			engine.roll = _camPR.pitch;
			engine.angle = _camYaw.value;
			
		}
		public var bmp:Bitmap; //
		public var engine: AndreRaycasterAlchemy = new AndreRaycasterAlchemy();
		
	
		
		[Embed(source='/assets/textures.gif')] public var TBmp:Class;
		
		
		
		public function AndreViewAlchemyTest() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		[PostConstruct]
		public function init():void {
			engine.init( new TBmp() );
			
			
			bmp= new Bitmap( engine );
			bounds = new Rectangle(0,0,bmp.width, bmp.height);
			
			addChild( bmp );
		}
		
		// STAND ALONE Tests...
		
		private function onAddedToStage(e:Event):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			bmp.x = ( stage.stageWidth - bmp.width ) / 2;
			bmp.y = ( stage.stageHeight - bmp.height ) / 2;
			
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			var timer: Timer = new Timer( 1 );
			timer.addEventListener( TimerEvent.TIMER, enterFrame );
			timer.start();
			//addEventListener(Event.ENTER_FRAME, enterFrame);	// 
			
			addChild( new FPS() );
		}
		
		private function onMouseDown( event: Event ): void
		{
			mouseDown = true;
		}
		
		private function onMouseUp( event: Event ): void
		{
			mouseDown = false;
		}
		
		private function enterFrame( event: Event ): void
		{
			
			// test engine internally only
			engine.angle += ( mouseX - stage.stageWidth / 2 ) / 4000;
			
			engine.roll += ( mouseY - stage.stageHeight / 2 ) / 32;
			engine.roll = engine.roll > 80 ? 80 : engine.roll < -80 ? -80 : engine.roll;
			
			if( mouseDown )
			{
				engine.x += Math.cos( engine.angle ) * 6;
				engine.y += Math.sin( engine.angle ) * 6;
				
				engine.z -= engine.roll / 50;
				engine.z = engine.z > 60 ? 60 : engine.z < 4 ? 4 : engine.z;
			}
			
			engine.z += ( 32 - engine.z ) / 128;

			engine.render();
			
			

		}
		
		
		
		
	}

}