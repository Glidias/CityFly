package org.cityfly.components.spatial 
{
	import co.uk.swft.base.EntityComponent;
	/**
	 * Standard rotation holder in all 3 directions.
	 * This class (or extended classes thereof) should not have any dependencies.
	 * @author Glenn Ko
	 */
	public class Rotation3D extends EntityComponent
	{
		public var rotationX:Number = 0;
		public var rotationY:Number = 0;
		public var rotationZ:Number = 0;
		
		public function Rotation3D() 
		{
			
		}
		
		
	}

}