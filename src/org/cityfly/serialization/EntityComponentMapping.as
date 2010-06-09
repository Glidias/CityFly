package org.cityfly.serialization 
{
	import org.robotlegs.core.IInjector;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class EntityComponentMapping extends BaseClassNameMapping
	{
		public var rules:Vector.<BaseClassNameMapping>;
		
		public function EntityComponentMapping(classe:Class, name:String="") 
		{
			super(classe, name);
		}
		
		
		public function setup(entityInjector:IInjector):* {  // inline
			var rule:* = entityInjector.mapSingleton(classz, name);
			if (rules) {
				var len:int = rules.length;
				for (var i:int = 0 ; i <len; i++) {
					entityInjector.mapRule(rules[i].classz, rule, rules[i].name);
		
				}
			}
			
			return rule;
		}
		
		
	}

}