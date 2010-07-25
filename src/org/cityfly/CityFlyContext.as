package org.cityfly 
{
	import co.uk.swft.base.GameContext;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import org.cityfly.*;
	import org.cityfly.components.*;
	import org.cityfly.components.spatial.*;
	import org.cityfly.entity.*;
	import org.cityfly.grid.*;
	import org.cityfly.commands.*;
	import org.cityfly.commands.tests.*;
	import org.cityfly.serialization.*;
	import org.cityfly.serialization.fcss.*;

	import org.cityfly.view.raycasting.andre.*;
	import org.cityfly.entity.camera.Camera3DEntity;
	
	import org.cityfly.view.raycasting.andre.AndreRaycaster;

	
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class CityFlyContext extends GameContext
	{
		
		public function CityFlyContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			// Map core managers ...
			// ....
	
			
			// Perform a test below..
			//injector.instantiate(TestEntitySpawner).execute();
			//injector.instantiate(TestAndreRaycaster).execute();
			//injector.instantiate(TestAndreRaycasterAlchemy).execute();
			injector.instantiate(TestCityRaycaster).execute();
				
			// Or start the main game instead
			injector.instantiate(GameStartupCommand).execute();

			
		}	
		

	}

}