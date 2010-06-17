package org.cityfly 
{

	import flash.Boot;
	import flash.display.MovieClip;

	

	/**
	 * ...
	 * @author Glenn Ko
	 */
	[SWF( backgroundColor='0x222222', frameRate='120', width='800', height='600')]
	public class CityFly extends MovieClip
	{
		
		private var _context:CityFlyContext;
		
		public function CityFly() 
		{
			new Boot(this);
			_context = new CityFlyContext(this);
			
			
		}
		
	}

}