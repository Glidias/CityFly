package org.cityfly.serialization 
{
	import co.uk.swft.core.IEntity;
	
	/**
	 * Class-Specific interface to support spawning with explicitly defined paramters 
	 * @author Glenn Ko
	 */
	public interface IEntityXMLSpawn 
	{
		function initXML(xml:XML = null, parseAll:Boolean=false):void;
		
		function spawnFromTemplate(id:String, styleObj:Object=null):IEntity;
		function spawnFromSelect(id:String, option:*= null):IEntity;
		function spawnFromRandom(id:String):IEntity;
		
		function spawnTemplate(node:XML):IEntity;
		function spawnSelect(node:XML, option:*=null):IEntity;
		function spawnRandom(node:XML):IEntity;	
	}
	
}