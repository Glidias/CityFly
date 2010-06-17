package org.cityfly.serialization.fcss
{
	import co.uk.swft.core.IEntity;
	import co.uk.swft.core.IEntityComponent;
	import com.flashartofwar.fcss.applicators.IApplicator;
	import com.flashartofwar.fcss.applicators.StyleApplicator;
	import com.flashartofwar.fcss.stylesheets.FStyleSheet;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import org.robotlegs.core.IInjector;
	import org.cityfly.serialization.*;
	
	
	/**
	 * Swft component-based game framework with XML entity/component serialization together with F*CSS stylesheet support.
	 * Allows spawning of entities given a xml+css template. This is still a work in progress.
	 * 
	 * @author Glenn Ko
	 */
	
	[Inject]
	public class EntityXMLSpawn implements IEntityXMLSpawn, IDEntitySpawn
	{
		
		private var injector:IInjector;
		private var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;

		// Cached maps
		private var templateMap:Dictionary = new Dictionary();
		private var templateNodeMap:Dictionary = new Dictionary();
		private var selectNodeMap:Dictionary = new Dictionary();
		private var randomNodeMap:Dictionary = new Dictionary();
		private var _idMap:Dictionary = new Dictionary();
		// fcss
		private var styleMap:Dictionary = new Dictionary();
		private var fStylesheet:FStyleSheet;
		private var applicator:IApplicator = new StyleApplicator();
		

	
		
		private static const DEFAULT_ENTITY_CLASS:String = "org.cityfly.serialization::SpawnedEntity"; //co.uk.swft.base::Entity
		
		public function EntityXMLSpawn(injector:IInjector) 
		{
			SpawnedEntity;
			this.injector = injector;
		}
		
		[Inject]
		public function setApplicationDomain(domain:ApplicationDomain = null):void {
			appDomain = domain || ApplicationDomain.currentDomain;
		}
		
		
		protected var entityClassPathPrefix:String = "";
		protected var componentClassPathPrefix:String = "";
		
		public function set entityClassPath(val:String):void {
			entityClassPathPrefix = val != null && val != "" ? val + "." : "";
		}
		
		public function set componentClassPath(val:String):void {
			componentClassPathPrefix = val != null && val != "" ? val + "." :  "";
		}
		
		/**
		 * Sets up configuration by XML. 
		 * @param	xml
		 * @param	parseAll	Will attempt to pre-parse all templates if set to true. This is good for testing 
		 * 						the validity of the XML templates and ensuring all classes are available to be
		 * 						instantiated.
		 */
		public function initXML(xml:XML = null, parseAll:Boolean=false):void {
			if (xml == null) return;
			
			if (xml.hasOwnProperty("settings")) setSettings(xml.settings[0]);
			
			if ( xml.hasOwnProperty("stylesheet") ) {
				fStylesheet = new FStyleSheet();
				fStylesheet.parseCSS( xml.stylesheet[0].toString() );
				
			}
			else throw new Error("Could not find stylesheet node in xml!");
			var list:XMLList
			var i:int;
			var node:XML;
			var len:int;
			
			list = xml.base;
			len = list.length();
			for ( i = 0; i < len; i++) {
				registerBaseNode(list[i]);
			}
			
			list = xml.template;
			len = list.length();
			for ( i = 0; i < len; i++) {
				node = list[i];
				registerTemplateNode(node);
				if (parseAll) parseTemplateNode( node );
				_idMap[node.@id.toString()] = node;
		
			}
			list = xml.random;
			len = list.length();
			for ( i = 0; i < len; i++) {
				node = list[i];
				registerRandomNode( node );
				_idMap[node.@id.toString()] = node;
			}
			list = xml.select;
			len = list.length();
			for ( i = 0; i < len; i++) {
				node = list[i];
				registerSelectNode( node );
				_idMap[node.@id.toString()] = node;
			}
			

		}
		
		public function registerBaseNode(node:XML):void {
			if (node.@id == undefined) throw new Error("No id specified for node to register!:" + node.toXMLString());
			extendNode(node);
			_idMap[node.@id.toString()] = node;
		}
		
		public function testSpawnAllTemplates():Vector.<IEntity> {
			var vec:Vector.<IEntity> = new Vector.<IEntity>();
			var i:int = 0;
			for (var key:String in templateNodeMap) {

				
				vec[i++] = spawnFromTemplate(key);
			}
			return vec;
		}
		public function testSpawnAllIDNodes():Vector.<IEntity> {
			var vec:Vector.<IEntity> = new Vector.<IEntity>();
			var i:int = 0;
			for (var key:String in _idMap) {
				vec[i++] = spawn(key);
			}
			return vec;
		}
		public function testSpawnAllNodes():Vector.<IEntity> {
			var vec:Vector.<IEntity> = new Vector.<IEntity>();
			var i:int = 0;
		
			return vec;
		}
		
		
		/**
		 * Registers a template spawn node given id of node.
		 * @param	node
		 */
		public function registerTemplateNode(node:XML):void {   //inline
			if (node.@id == undefined) throw new Error("No id specified for node to register!:" + node.toXMLString());
			extendNode(node);
			var id:String = node.@id.toString();
			templateNodeMap[id] = node;
		}
		
		/**
		 * Registers a random spawn node given id of node.
		 * @param	node
		 */
		public function registerRandomNode(node:XML):void {   //inline
			if (node.@id == undefined) throw new Error("No id specified for node to register!:" + node.toXMLString());
			var id:String = node.@id.toString();
			randomNodeMap[id] = node;
		}
		
		/**
		 * Registers a select spawn node given id of node.
		 * @param	node
		 */
		public function registerSelectNode(node:XML):void {   //inline
			if (node.@id == undefined) throw new Error("No id specified for node to register!:" + node.toXMLString());
			extendNode(node);
			var id:String = node.@id.toString();
			selectNodeMap[id] = node;
		}
		
		
		
		private function extendNode(node:XML):Boolean {  //inline
			if (node["@extends"] != undefined) {
				var extendClasses:Array = node["@extends"].toString().split(" ");
				
				var len:int = extendClasses.length;
				for (var i:int = 0; i < len; i++) {
					var childNode:XML = _idMap[ extendClasses[i] ];
					if (childNode == null) throw new Error("Could not find node to extend from id:" + extendClasses[i] + " under " + node.toXMLString());
					
					// check for id attributes being used and run id case if so to prevent id collisions
					var idList:XMLList = node.*.(hasOwnProperty("@id"));
					if (idList.length() > 0) {
						var copyList:XMLList = childNode.children().copy();
						var gotIdList:XMLList = copyList.(hasOwnProperty("@id"));
						for each (var idNode:XML in idList) {
							var delList:XMLList = gotIdList.(@id == idNode.@id);
							var d:int = delList.length();
							while (--d > -1) {
								delete delList[d];
							}
						}
						node.appendChild(copyList);
						continue;
					}
					// else use direct extension
					node.appendChild(childNode.children());
				}
				return true;
			}
			return false;
		}
		
		private function getDefinitionClass(def:String, prefix:String = ""):Class {	// inline
			def = def.indexOf("::") > -1 ? def : prefix + def;
			if (!appDomain.hasDefinition(def)) throw new Error("Couldnt find class definition: "+def);
			return appDomain.getDefinition(def) as Class;
		}
		
		
		/**
		 * Bakes a node as a template node (given it's id) and caches all styles/component classes under this template node definition
		 * for quick spawnings.
		 * @param	node
		 */
		public function parseTemplateNode(node:XML):void {
			if (node.@id == undefined) throw new Error("No id specified for node to register parse!:" + node.toXMLString());
			var id:String = node.@id.toString();
			
			var list:XMLList = node.component;
			
			var i:int = list.length();
			var classesArray:Array = new Array(i+1);
			var styleObjs:Array = new Array(i+1);
			
			while (--i > -1) {
				var compNode:XML = list[i];
				var u:int;
				var rulesVec:Vector.<BaseClassNameMapping>;
				if (compNode["@class"] == undefined) throw new Error("No class attribute defined for component! "+compNode.toXMLString());
				var mapping:EntityComponentMapping = new EntityComponentMapping( getDefinitionClass(compNode["@class"], componentClassPathPrefix), compNode.@name );
			
				if (compNode.@rules != undefined) {
					var ruleDefs:Array = compNode.@rules.split(" ");
					u = ruleDefs.length;
					rulesVec = new Vector.<BaseClassNameMapping>(u, true);
					while (--u > -1) {
						rulesVec[u] = new BaseClassNameMapping( getDefinitionClass(ruleDefs[u], componentClassPathPrefix) );
					}
					mapping.rules = rulesVec;
				}
				var ruleList:XMLList = compNode.rule;
				if (ruleList.length() ) {
					if (rulesVec) throw new Error("Inline rules already defined! Only either inline attributes or node rules declarations are allowed, no mixing both!");
					u = ruleList.length();
					rulesVec = new Vector.<BaseClassNameMapping>(u, true);
					while ( --u > -1) {
						rulesVec[u] = new BaseClassNameMapping( getDefinitionClass(ruleList[u].toString(), componentClassPathPrefix), ruleList[u].@name);
					}
					mapping.rules = rulesVec;
				}
				
				var styleClassName:String = compNode["@class"].toString();
				styleClassName = styleClassName.indexOf("::") > -1 ? "." + styleClassName.split("::").pop() : "." + styleClassName.split(".").pop();
				styleClassName = "#"+id+"~"+styleClassName;
				if (fStylesheet.hasStyle(styleClassName) || ( compNode.@id != undefined && fStylesheet.hasStyle("#"+id+"~"+"#"+compNode.@id)) )  {
					styleObjs[i + 1] = compNode.@id != undefined ? fStylesheet.getStyle("#"+id+"~"+"#"+ compNode.@id.toString(), styleClassName) : fStylesheet.getStyle(styleClassName);   // todo: add base node style support
						
				}
				
				classesArray[i+1] = mapping;
			
			}
			
	
			
			var customEntityClassValue:String = node.hasOwnProperty("class") ? node["class"][0] : null;
			classesArray[0] =  customEntityClassValue!= null ? getDefinitionClass(customEntityClassValue, entityClassPathPrefix) : getDefinitionClass(DEFAULT_ENTITY_CLASS);
			styleClassName = customEntityClassValue!=null ? customEntityClassValue.indexOf("::") > -1 ? "." + customEntityClassValue.split("::").pop() : "." + customEntityClassValue.split(".").pop() : null;
			if (styleClassName  && (fStylesheet.hasStyle(styleClassName) ) )  {  // todo: add base node style support
				styleObjs[0] =	fStylesheet.getStyle(styleClassName);
			}
			
			templateMap[id] = classesArray;
			styleMap[id] = styleObjs;
			
		
		}
		
		
		/**
		 * Spawns an entity from a cached template by given id. If no cached template is found, attempts to bake 
		 * a template first.
		 * @param	id
		 * @param  styleObj  (Optional, usually used internally). An additional style object to merge over base style.
		 * @return
		 */
		public function spawnFromTemplate(id:String, styleObj:Object = null):IEntity {  //inline
			if (templateMap[id]) {  // spawn from cached component map 
				
				var mappingsToSpawn:Array = templateMap[id];
					
				var stylesToApply:Array = styleMap[id];
				
				var entityClass:Class = mappingsToSpawn[0];
				var compClass:Class;
				var name:String;
				
				var entity:IEntity = new entityClass();
				var entityInjector:IInjector = injector.createChild();
				
				entity.injector = entityInjector;
				entity.mapComponents();
				entityInjector.mapValue(String, id, "spawnId");
				entityInjector.mapValue(IEntity, entity);
				
				// comment off try/catch blocks when no longer needed
				try {
					entityInjector.injectInto(entity);
				}
				catch (err:Error) {
					throw new Error("Failed entity injection: "+id + "\n"+err.message );
				}
				
				// FOR REFERENCE ONLY:
				/*  //duplicate from entity map above
					var entity:IEntity = new entityClass();
					var entityInjector:IInjector = _injector.createChild();
					entity.injector = entityInjector;
					entity.mapComponents();
					entityInjector.mapValue(IEntity, entity);
					entityInjector.injectInto(entity);
					registerEntity(entity);
				*/
				
				// Add extra styles and xml-defined components
				var baseStyle:Object = stylesToApply[0];
				if (styleObj || baseStyle) {
					styleObj = styleObj ?  baseStyle ?  mergeObjects(styleObj, baseStyle) : styleObj : baseStyle;
					if (styleObj) applicator.applyStyle(entity, styleObj );
				}
				
				var len:int = mappingsToSpawn.length;
				for (var i:int = 1; i < len; i++) {
					mappingsToSpawn[i].setup(entityInjector);
				}
				
				i = len;
				var count:int = 0;
				var entityComp:IEntityComponent;
				while (--i > 0) {
					count++;
					
					//comment off try/catch blocks when no longer needed
					try {		
						entityComp = entityInjector.getInstance( mappingsToSpawn[i].classz );
					}
					catch (err:Error) {
						throw new Error("Failed component instance for spawned entity: "+id + "\n"+err.message );
					}
					
					baseStyle = stylesToApply[i];
					if (styleObj || baseStyle) {
						styleObj = styleObj ?  baseStyle ?  mergeObjects(styleObj, baseStyle) : styleObj : baseStyle;
						if (styleObj)  applicator.applyStyle(entityComp, styleObj );
					}
				}
				
				
				return entity;
			}
			else {
				parseTemplateNode( templateNodeMap[id] ); // bake it!
				return spawnFromTemplate(id, styleObj);
			}
		
			return null;
		}
		
		private function mergeObjects(newObj:Object, baseObj:Object):Object { // inline
			for (var i:String in baseObj) {
				newObj[i] = baseObj[i];
			}
			return newObj;
		}
		
		
		public function spawnFromSelect(id:String, option:*= null):IEntity {	//inline
			var node:XML = selectNodeMap[id];
			return spawnSelect(node, option);
		}
		
		public function spawnFromRandom(id:String):IEntity {	//inline
			var node:XML = randomNodeMap[id];
			return spawnRandom(node);
		}
		
		/**
		 * Currently not implemented. Spawns an entity immediatey given node without caching it..
		 * @param	node
		 * @return
		 */
		public function spawnTemplate(node:XML):IEntity {	
			return null;
		}
		
		/**
		 * Spawns directly from a given random node, using currently available registered templates.
		 * @param	node
		 * @return
		 */
		public function spawnRandom(node:XML):IEntity {  // inline 
			var templateId:String = node.@useTemplate;
			var count:int = int(node.@count);
			
			// todo: consider add extra args under each option for additional styles to merge over base
			return spawnFromTemplate(templateId);		
		}
		
		
		/**
		 * Spawns directly from a given select node, using currently available registered templates.
		 * @param	node	
		 * @param	option	(Currently not implemented yet) Does random selection by default. 
		 * 					Intended to be a string id or uint/int/Number index to determine selection.
		 * @return
		 */
		public function spawnSelect(node:XML, option:*= null):IEntity {  // inline 
			var chosen:XML;
			var len:int;
			var optionList:XMLList;
			var baseTemplateId:String = node.@useTemplate != undefined ? node.@useTemplate : null;
			var templateId:String;
			//if (option==null) {  // do random selection
				optionList = node.option;
				len = optionList.length();
				chosen = optionList[ int( Math.random() * len ) ];
				templateId = chosen.@useTemplate != undefined ? chosen.@useTemplate : baseTemplateId;
				if (templateId == null) throw new Error("Could not find template id attribute:" + chosen.toXMLString());
				// todo: consider add extra args under each option for additional styles to merge over base
				return spawnFromTemplate(templateId);
			//}
			//else {  // consider option
				
			//}
			return null;
		}
		
		/**
		 * Generic spawn given current xml configuration
		 * @param	id
		 * @return
		 */
		public function spawn(id:String):IEntity {
			var node:XML = _idMap[id];
			if (node == null) throw new Error("Could not find inited xml node by id:"+id);
			var nodeName:String = node.name().toString();
			switch ( nodeName) {
				case "base":	throw new Error("Sorry! You can't spawn from a base node:"+node.toXMLString());
				case "template": return spawnFromTemplate(id);
				case "select":	return spawnFromSelect(id);
				case "random": return spawnFromRandom(id);
				default: return null;
			}
		}
		
		
		public function setSettings(node:XML):void {
			if (node.hasOwnProperty("entityClassPath")) entityClassPath = node.entityClassPath;
			if (node.hasOwnProperty("componentClassPath")) componentClassPath = node.componentClassPath;
		}

		

		
	}

}