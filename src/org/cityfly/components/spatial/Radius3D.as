package org.cityfly.components.spatial 
{
	/**
	 * Radius settings on both axis supported here for full 3D radius (for spheres and such..).
	 * This class (or extended classes thereof) should not have any dependencies.
	 * @author Glenn Ko
	 */
	public class Radius3D extends Radius
	{
		private var _value2:Number = 0; // this provides an alternate radius value on the other axis
		
		public function Radius3D() 
		{
			
		}
		
		// if value2 is lower than zero, it uses the first value instead, which works great for spheres.
		public function get value2():Number {			
			return  _value2 < 0 ? _value2 : value;
		}
		public function set value2(val:Number):void {  
			_value2 = val;
		}
		
		
	}

}