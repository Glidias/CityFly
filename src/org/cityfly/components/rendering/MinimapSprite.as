package org.cityfly.components.rendering 
{
	import co.uk.swft.base.EntityComponent;
	import org.cityfly.components.spatial.Position;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class MinimapSprite extends EntityComponent
	{
		[Inject]
		public var position:Position;
		
		public var color:uint = 0xFF0000;
		
		
		
		public function MinimapSprite() 
		{
			
		}
		
	}

}