package org.cityfly.view.raycasting.city
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
	import org.cityfly.common.Stats;
	import org.cityfly.components.spatial.PitchRoll;
	import org.cityfly.components.spatial.Position3D;
	import org.cityfly.components.spatial.Rotation;
	import org.cityfly.entity.camera.Camera3DEntity;
	import org.cityfly.view.raycasting.city.TileHeightMovement;
	import org.cityfly.view.raycasting.city.temp.Map;
	import org.cityfly.view.raycasting.city.CityGlobals;
	
	
	
	/**
	 * Test to run/mediate CityRaycaster which was compiled in Haxe.  Uses old legacy content to be re-assembled
	 * into Haxe's memory registers for the engine.
	 * 
	 * @author Glenn Ko
	 */
	public class CityRaycasterTest extends Sprite
	{
		private var bounds: Rectangle;
		private const origin: Point = new Point();
		private var mouseDown:Boolean = false;
		
		private var movementController:TileHeightMovement;
		
		
		
		// COMMON CITYFLY
		private var _camPosition:Position3D;
		private var _camYaw:Rotation;
		private var _camPR:PitchRoll;
		[Inject]
		public function set camera(entity:Camera3DEntity):void {
			_camPosition = entity.position;
			_camYaw = entity.rotation;
			_camPR = entity.pr;

		
			_camPosition.x = 55 * 128  + 32;  
			_camPosition.y = 40 * 128  + 32; 
			_camPosition.z = 32;
			
			// This shuold be updated on every frame loop in real non-test versions		
			engine.x = _camPosition.x;
			engine.y = _camPosition.y;
			engine.z = _camPosition.z;
			engine.roll = _camPR.pitch;
			engine.angle = _camYaw.value;
			
		}
		public var bmp:Bitmap; 
		public var engine: CityRaycaster = new CityRaycaster();
		
		[Embed(source='/assets/groundceil.png')]
		public var GROUND_MAP:Class;
		
		[Embed(source = '/assets/walltextures.png')]
		public var BUILDING_MAP:Class;
		
		[Embed(source = '/assets/walltextures2.png')]
		public var BUILDING_MAP_2:Class;
		
		private var SW:int = 800;
		private var SH:int = 600;
		private static const ANGLE_RATIO:Number = 1 / 4000;
		private static const ROLL_RATIO:Number = 1 / 32;
		private static const SUB_ROLL_RATIO:Number = 1 / 50;
		
		public function CityRaycasterTest() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			
		}
		private function dataOf(bmp:Bitmap):BitmapData {
			return bmp.bitmapData;
		}
		
		[PostConstruct]
		public function init():void {
	
			var tempMap:Map = new Map();
			
			var groundMap:BitmapData =  dataOf(new GROUND_MAP());
			var buildingMap:BitmapData = dataOf(new BUILDING_MAP());
			var buildingMap2:BitmapData = dataOf(new BUILDING_MAP_2());
			TextureGlobals.parseGroundBitmapDataSheet(groundMap);
			TextureGlobals.parseWallBitmapDataSheet(buildingMap);
			TextureGlobals.parseWallBitmapDataSheet2(buildingMap2);
		
			movementController = new TileHeightMovement( );
			
			movementController.pX = _camPosition.x;
			movementController.pY = _camPosition.y;
			movementController.pZ = _camPosition.z;
			
			MapInfoGlobals.populateGroundInfoVector( tempMap.getGroundMap().getVector(tempMap.getGroundMap().rect) );
			MapInfoGlobals.populateWallInfoVector( tempMap.getBlockMap().getVector(tempMap.getBlockMap().rect) );
			MapInfoGlobals.populateStoreyInfoVector( tempMap.getStoreyMap().getVector(tempMap.getStoreyMap().rect) );

			bmp= new Bitmap( engine );
			bounds = new Rectangle(0, 0, bmp.width, bmp.height);
			
			groundMap.dispose();
			buildingMap.dispose();
			buildingMap2.dispose();
			tempMap.disposeAll();
			
			addChild( bmp );
		}
		
		// STAND ALONE Tests...
		
		private function onAddedToStage(e:Event):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			bmp.x = ( stage.stageWidth - bmp.width ) / 2;
			bmp.y = ( stage.stageHeight - bmp.height ) / 2;
			SW = stage.stageWidth;
			SH = stage.stageHeight;
			
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
		//	var timer: Timer = new Timer( 1 );
			//timer.addEventListener( TimerEvent.TIMER, enterFrame );
			//timer.start();
			addEventListener(Event.ENTER_FRAME, enterFrame);	// 
			
			addChild( new Stats() );
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
			engine.angle += ( mouseX - SW * .5 ) * ANGLE_RATIO;
			
			engine.roll += ( mouseY - SH * .5 ) * ROLL_RATIO;
			engine.roll = engine.roll > 120 ? 120 : engine.roll < -120 ? -120 : engine.roll;
			
			if( mouseDown )
			{
				movementController.moveChar( Math.cos( engine.angle ) * 6 , Math.sin( engine.angle ) * 6 );
				movementController.pZ -= engine.roll * SUB_ROLL_RATIO;
				movementController.pZ =  movementController.pZ < movementController.pZs+16 ? movementController.pZs+16: movementController.pZ;
			}
			
		//	movementController.pZ += ( 32 - movementController.pZ ) / 128 * 2;
			
			engine.x = movementController.pX;
			engine.y = movementController.pY;
			engine.z = movementController.pZ;

			engine.render();
			
		}
		
		
	}

}