﻿package org.cityfly.commands.tests
{
	import co.uk.swft.core.IEntityMap;
	import org.robotlegs.mvcs.Command;
	import org.cityfly.entity.camera.*;
	import org.cityfly.view.raycasting.andre.*;

	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class TestAndreRaycaster extends Command
	{

		[Inject]
		public var entityMap:IEntityMap;
		
		public function TestAndreRaycaster() 
		{
			
		}
		
		override public function execute():void {
			injector.mapValue(Camera3DEntity, entityMap.createEntity(Camera3DEntity) );
			injector.mapSingleton(AndreRaycaster);
			contextView.addChild( injector.instantiate(AndreViewTest));
		}
		
		
	}

}