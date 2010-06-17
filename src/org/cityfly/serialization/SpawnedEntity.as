package org.cityfly.serialization 
{
	import co.uk.swft.base.Entity;
	import co.uk.swft.core.IEntityComponent;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class SpawnedEntity extends Entity
	{
		[Inject(name="spawnId")]
		public var spawnId:String;
		
		public function SpawnedEntity() 
		{
			
		}

		
		public function toString():String {
			return "***"+spawnId+": "+_components + "***\n";
		}
		
	}

}