package aw.utils.propertyinspector{
	import aw.data.BasicValue;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	

	/** 
	* Objects of this class contain information on the classes located in the system. 
	* Objects of this class can be instantiated directly with the constructor, but 
	* it’s recommended to do this with methods of PropertyInspector class where an 
	* information cashing mechanism is present.
	* @example Пример получения ссылки на объект PropertyInspectorItem
<listing version="3.0">
package {
	import aw.utils.PropertyInspector;
	import aw.utils.propertyinspector.PropertyInspectorItem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class Test extends Sprite{
		public function Test():void{
			super();
			var pii:PropertyInspectorItem = PropertyInspector.getInfo(MovieClip);
			// Is object dynamic
			trace(pii.isDynamic);
			// All methods that returns value of Rectangle type
			trace(pii.getMethodsByType(Rectangle));
			// Get object PropertyItem, containing information about the properties of the object
			pii.getByName('width');
		}
	}
}
</listing>
	* For information about static member of class, use methods in the static_ns namespace
	* 
	* @public 
	* @author Galaburda a_[w] Oleg	  http://www.actualwave.com
	* @see aw.utils.PropertyInspector
	* @see aw.utils.propertyinspector.static_ns
	*/
	public class PropertyInspectorItem extends Object{

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const VAR_NODE_NAME:String = 'variable';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const CONST_NODE_NAME:String = 'constant';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const GETSET_NODE_NAME:String = 'accessor';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const METHOD_NODE_NAME:String = 'method';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const PROTOTYPE_NODE_NAME:String = 'factory';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const NAME_ATTR_NAME:String = 'name';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ACCESS_ATTR_NAME:String = 'access';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const TYPE_ATTR_NAME:String = 'type';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const URI_ATTR_NAME:String = 'uri';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const RETURNTYPE_ATTR_NAME:String = 'returnType';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const VOID_RETURN_TYPE_NAME:String = 'void';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ANY_RETURN_TYPE_NAME:String = '*';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const READ_VALUE:String = 'readonly';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const WRITE_VALUE:String = 'writeonly';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const READWRITE_VALUE:String = 'readwrite';

		/** 
		* 
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected var _isDynamic:Boolean;

		/** 
		* Contains the names of all members of the class
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected var _names:Object;

		/** 
		* An array of objects PropertyItem, describing the properties
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		* @see aw.utils.propertyinspector.PropertyItem
		*/
		protected var _properties:Array;

		/** 
		* An array of objects PropertyItem, describing the methods
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		* @see aw.utils.propertyinspector.PropertyItem
		*/
		protected var _methods:Array;

		/** 
		* Contains the names of all static members of the class
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected var _staticNames:Object;

		/** 
		* An array of objects PropertyItem, describing the static properties
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		* @see aw.utils.propertyinspector.PropertyItem
		*/
		protected var _staticProperties:Array;

		/** 
		* An array of objects PropertyItem, describing the static methods
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		* @see aw.utils.propertyinspector.PropertyItem
		*/
		protected var _staticMethods:Array;

		/** 
		* Creates an object containing all the information about the class and its member
		* 
		* 
		* @public 
		* @param o 
		* @return void 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function PropertyInspectorItem(o:Class):void{
			super();
			_names = new Object();
			_properties = new Array();
			_methods = new Array();
			_staticNames = new Object();
			_staticProperties = new Array();
			_staticMethods = new Array();
			saveInfo(o);
		}

		/** 
		* Is class dynamic 
		* 
		* @public (getter) 
		* @return Boolean 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get isDynamic():Boolean{
			return this._isDynamic;
		}

		/** 
		* An array of objects PropertyItem, describing the properties
		* 
		* 
		* @public (getter) 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get properties():Array{
			return this._properties.concat();
		}

		/** 
		* 	An array of objects PropertyItem, describing the static properties
		* 
		* @copy #_staticProperties
		* @public (static_ns,getter) 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static_ns function get properties():Array{
			return this._staticProperties.concat();
		}

		/** 
		* Retrieve object PropertyItem, by name of a member of the class
		* 
		* 
		* @public 
		* @param name 
		* @return PropertyItem 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function getByName(name:*):PropertyItem{
			return this._names[String(name)];
		}

		/** 
		* Retrieve object PropertyItem, by name of a static member of the class
		* 
		* 
		* @public (static_ns) 
		* @param name 
		* @return PropertyItem 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static_ns function getByName(name:*):PropertyItem{
			return this._staticNames[String(name)];
		}

		/** 
		* Verifies the existence of a member of the class, by its name.
		* 
		* 
		* @public 
		* @param name 
		* @return Boolean 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function isExists(name:*):Boolean{
			return (String(name) in this._names);
		}

		/** 
		* Verifies the existence of a static member of the class, by its name.
		* 
		* 
		* @public (static_ns) 
		* @param name 
		* @return Boolean 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static_ns function isExists(name:*):Boolean{
			return (String(name) in this._staticNames);
		}

		/** 
		* Returns TRUE, if passed the name of the property and FALSE - if the name of the method.
		* 
		* 
		* @public 
		* @param name 
		* @return Boolean 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function isProperty(name:*):Boolean{
			var prop:PropertyItem = this._names[String(name)];
			return (prop && prop.access!=PropertyAccessType.METHOD);
		}

		/** 
		* Returns TRUE, if passed the name of the property and FALSE - if the name of the method. For static members only. 
		* 
		* 
		* @public (static_ns) 
		* @param name 
		* @return Boolean 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static_ns function isProperty(name:*):Boolean{
			var prop:PropertyItem = this._staticNames[String(name)];
			return (prop && prop.access!=PropertyAccessType.METHOD);
		}

		/** 
		* Separates properties by level of access
		* 
		* 
		* @public 
		* @param acc 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function getProperties(acc:int=-1):Array{
			return this.propertiesByAccess(this._properties, acc);
		}

		/** 
		* Separates static properties by level of access
		* 
		* 
		* @public (static_ns) 
		* @param acc 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static_ns function getProperties(acc:int=-1):Array{
			return this.propertiesByAccess(this._staticProperties, acc);
		}

		/** 
		* Separates properties by level of access from list
		* 
		* 
		* @private (protected) 
		* @param arr 
		* @param acc 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected function propertiesByAccess(arr:Array, acc:int=-1):Array{
			var ret:Array;
			if(acc<0){
				ret = arr.concat();
			}else{
				var len:int = arr.length;
				ret = new Array();
				var item:PropertyItem;
				for(var i:int=0; i<len; i++){
					item = arr[i] as PropertyItem;
					if(item.access==acc) ret.push(item);
				}
			}
			return ret;
		}

		/** 
		* Separates properties by the type of class member
		* 
		* 
		* @public 
		* @param cont 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function getPropertiesByContainer(cont:int=-1):Array{
			return this.propertiesByContainer(this._properties, cont);
		}

		/** 
		* Separates static properties by the type of class member
		* 
		* 
		* @public (static_ns) 
		* @param cont 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static_ns function getPropertiesByContainer(cont:int=-1):Array{
			return this.propertiesByContainer(this._staticProperties, cont);
		}

		/** 
		* Separates properties by the type of class member from list
		* 
		* 
		* @private (protected) 
		* @param arr 
		* @param cont 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected function propertiesByContainer(arr:Array, cont:int=-1):Array{
			var ret:Array;
			if(cont<0){
				ret = arr.concat();
			}else{
				var len:int = arr.length;
				ret = new Array();
				var item:PropertyItem;
				for(var i:int=0; i<len; i++){
					item = arr[i] as PropertyItem;
					if(item.container==cont) ret.push(item);
				}
			}
			return ret;
		}

		/** 
		* Separates the properties by value type
		* 
		* 
		* @public 
		* @param cls 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function getPropertiesByType(cls:Class):Array{
			return this.propertiesByType(this._properties, cls);
		}

		/** 
		* Separates the static properties by value type
		* 
		* 
		* @public (static_ns) 
		* @param cls 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static_ns function getPropertiesByType(cls:Class):Array{
			return this.propertiesByType(this._staticProperties, cls);
		}

		/** 
		* Separates the properties by value type from list
		* 
		* 
		* @private (protected) 
		* @param arr 
		* @param cls 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected function propertiesByType(arr:Array, cls:Class):Array{
			var len:int = arr.length;
			var ret:Array = new Array();
			var item:PropertyItem;
			for(var i:int=0; i<len; i++){
				item = arr[i] as PropertyItem;
				if(item.type==cls) ret.push(item);
			}
			return ret;
		}

		/** 
		* Separates the methods by return type
		* 
		* 
		* @public 
		* @param cls 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function getMethodsByType(cls:Class):Array{
			return this.methodsByType(this._methods, cls);
		}

		/** 
		* Separates the static methods by return type
		* 
		* 
		* @public (static_ns) 
		* @param cls 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static_ns function getMethodsByType(cls:Class):Array{
			return this.methodsByType(this._staticMethods, cls);
		}

		/** 
		* Separates the methods by return type from list
		* 
		* 
		* @private (protected) 
		* @param arr 
		* @param cls 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected function methodsByType(arr:Array, cls:Class):Array{
			var len:int = arr.length;
			var ret:Array = new Array();
			var item:PropertyItem;
			for(var i:int=0; i<len; i++){
				item = arr[i] as PropertyItem;
				if(item.type==cls) ret.push(item);
			}
			return ret;
		}

		/** 
		* 
		* 
		* @copy #_methods
		* @public (getter) 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get methods():Array{
			return this._methods.concat();
		}

		/** 
		* 
		* 
		* @copy #_staticMethods
		* @public (static_ns,getter) 
		* @return Array 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static_ns function get methods():Array{
			return this._staticMethods.concat();
		}

		/** 
		* Processes and stores information about object class
		* 
		* 
		* @private (protected) 
		* @param o 
		* @return void 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected function saveInfo(o:Class):void{
			var x:XML = describeType(o);
			this._isDynamic = BasicValue.expectsBoolean(x.@isDynamic);
			saveInfoTo(x, this._staticNames, this._staticProperties, this._staticMethods);
			saveInfoTo(x.factory[0], this._names, this._properties, this._methods);
		}

		/** 
		* Parses the received XML and creates objects PropertyItem to find data about the members of the class
		* 
		* 
		* @private (protected) 
		* @param x 
		* @param names 
		* @param properties 
		* @param methods 
		* @return void 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static protected function saveInfoTo(x:XML, names:Object, properties:Array, methods:Array):void{
			var types:Object = PropertyAccessType.TYPES;
			var item:PropertyItem;
			x.variable.(item = new PropertyItem(attribute(NAME_ATTR_NAME), getDefinition(attribute(TYPE_ATTR_NAME)), types[attribute(ACCESS_ATTR_NAME)], PropertyContainerType.VARIABLE, String(attribute(URI_ATTR_NAME))), names[String(item.name)] = item, properties.push(item));
			x.accessor.(item = new PropertyItem(attribute(NAME_ATTR_NAME), getDefinition(attribute(TYPE_ATTR_NAME)), types[attribute(ACCESS_ATTR_NAME)], PropertyContainerType.ACCESSOR, String(attribute(URI_ATTR_NAME))), names[String(item.name)] = item, properties.push(item));
			x.constant.(item = new PropertyItem(attribute(NAME_ATTR_NAME), getDefinition(attribute(TYPE_ATTR_NAME)), PropertyAccessType.READONLY, PropertyContainerType.CONSTANT, String(attribute(URI_ATTR_NAME))), names[String(item.name)] = item, properties.push(item));
			x.method.(item = new PropertyItem(attribute(NAME_ATTR_NAME), getDefinition(attribute(RETURNTYPE_ATTR_NAME)), PropertyAccessType.METHOD, PropertyContainerType.METHOD, String(attribute(URI_ATTR_NAME))), names[String(item.name)] = item, methods.push(item));
			/*
			var types:Object = PropertyAccessType.TYPES;
			var i:int;
			var node:XML;
			var name:String;
			var item:PropertyItem;
			var xlist:XMLList = x.variable;
			var prop:int = PropertyContainerType.VARIABLE;
			var len:int = xlist.length();
			for(i=0; i<len; i++){
				node = xlist[i];
				name = node.@name;
				item = new PropertyItem(name, getDefinition(node.@type), types[node.@access], prop, String(node.@uri));
				names[String(item.name)] = item;
				properties.push(item);
			}
			xlist = x.accessor;
			prop = PropertyContainerType.ACCESSOR;
			len = xlist.length();
			for(i=0; i<len; i++){
				node = xlist[i];
				name = node.@name;
				item = new PropertyItem(name, getDefinition(node.@type), types[node.@access], prop, String(node.@uri));
				names[String(item.name)] = item;
				properties.push(item);
			}
			xlist = x.constant;
			prop = PropertyContainerType.CONSTANT;
			len = xlist.length();
			for(i=0; i<len; i++){
				node = xlist[i];
				name = node.@name;
				item = new PropertyItem(name, getDefinition(node.@type), PropertyAccessType.READONLY, prop, String(node.@uri));
				names[String(item.name)] = item;
				properties.push(item);
			}
			xlist = x.method;
			prop = PropertyContainerType.METHOD;
			len = xlist.length();
			var type:String;
			for(i=0; i<len; i++){
				node = xlist[i];
				name = node.@name;
				type = node.@returnType;
				item = new PropertyItem(name, getDefinition(type), PropertyAccessType.METHOD, prop, String(node.@uri));
				names[String(item.name)] = item;
				methods.push(item);
			}
			*/
		}

		/** 
		* 
		* 
		* 
		* @private (protected) 
		* @param str 
		* @return Class 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static protected function getDefinition(str:String):Class{
			if(str==VOID_RETURN_TYPE_NAME) return undefined;
			else if(str==ANY_RETURN_TYPE_NAME) return Object;
			else return getDefinitionByName(str) as Class;
		}
	}
}