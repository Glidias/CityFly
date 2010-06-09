package org.cityfly 
{
	import co.uk.swft.base.GameContext;
	import flash.display.DisplayObjectContainer;
	import org.cityfly.*;
	import org.cityfly.components.*;
	import org.cityfly.components.spatial.*;
	import org.cityfly.entity.*;
	import org.cityfly.grid.*;
	import org.cityfly.commands.*;
	import org.cityfly.serialization.*;
	import org.cityfly.serialization.fcss.*;

	
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
			
			// Start the ball rolling
			//injector.instantiate(GameStartupCommand).execute();
			
			// Test Entity spawner
			injector.instantiate(TestEntitySpawner).execute();
			
		}	
		

	}

}