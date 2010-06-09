package org.cityfly.serialization 
{
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class BaseClassNameMapping
	{
		public var classz:Class;
		public var name:String = "";
		
		public function BaseClassNameMapping(classe:Class, name:String="") 
		{
			this.classz = classe;
			this.name = "";
		}
		
		public function toString():String {
			return "***"+myClassName+":"+classz+" ~ [name "+name + "]***\n";
		}
		
		protected function get myClassName():String {
			return getQualifiedClassName(this).split("::").pop();
		}
	}

}