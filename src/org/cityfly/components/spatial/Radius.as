package org.cityfly.components.spatial 
{
	import co.uk.swft.base.EntityComponent;
	/**
	 * Standalone radius pointer. 
	 * This class (or extended classes thereof) should not have any dependencies.
	 * 
	 * @author Glenn Ko
	 */
	public class Radius extends EntityComponent
	{
		
		public var value:Number;
		
		public function Radius(val:Number=0) 
		{
			value = val;
		}

		
	}

}