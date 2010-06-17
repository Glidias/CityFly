package org.cityfly.commands.tests
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.Command;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import org.cityfly.serialization.fcss.EntityXMLSpawn;
	import org.cityfly.ClassList;
	
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class TestEntitySpawner extends Command
	{

		
		public function TestEntitySpawner() 
		{
			ClassList;
		}
		
		override public function execute():void {
			// Test entity spawner
			var loader:URLLoader = new URLLoader();
			loader.addEventListener("complete", onLoadComplete);
			loader.load( new URLRequest("xml/entities.xml") );
		}
		
		// Test entity spawner
		private function onLoadComplete(e:Event):void  {
			var entitySpawner:EntityXMLSpawn = new EntityXMLSpawn(injector);
			
			entitySpawner.initXML(XML(e.target.data), false);
			var vec:* = entitySpawner.testSpawnAllTemplates();

			
			throw new Error(vec);
		}
	}

}