package org.cityfly.serialization 
{
	import co.uk.swft.core.IEntity;
	
	/**
	 * Generic interface to spawn an IEntity given an id.
	 * @author Glenn Ko
	 */
	public interface IDEntitySpawn 
	{
		function spawn(id:String):IEntity;
	}
	
}