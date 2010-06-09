package org.cityfly 
{

	import flash.display.Sprite;

	

	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class CityFly extends Sprite
	{
		
		private var _context:CityFlyContext;
		
		public function CityFly() 
		{
			
			_context = new CityFlyContext(this);
			
			
		}
		
	}

}