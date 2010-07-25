package org.cityfly.commands.tests
{
	import co.uk.swft.core.IEntityMap;
	import org.robotlegs.mvcs.Command;
	import org.cityfly.entity.camera.*;
	import org.cityfly.view.raycasting.city.*;

	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class TestCityRaycaster extends Command
	{

		[Inject]
		public var entityMap:IEntityMap;
		
		public function TestCityRaycaster() 
		{
			
		}
		
		override public function execute():void {
			new CityAssembly();
			
			injector.mapValue(Camera3DEntity, entityMap.createEntity(Camera3DEntity) );
			injector.mapSingleton(CityRaycaster);
			contextView.addChild( injector.instantiate(CityRaycasterTest));
		}
		
		
	}

}