package aw.utils{
	import aw.utils.propertyinspector.PropertyAccessType;
	import aw.utils.propertyinspector.PropertyInspectorItem;
	import aw.utils.propertyinspector.PropertyItem;
	import aw.utils.propertyinspector.static_ns;
	
	import flash.utils.Dictionary;
	

	/** 
	* Класс позволяет получать информацию о членах классов и их особенностях.
	* Член класса - свойство, метод, пространство имён, константа.
	* Для получения информации о классах используется метод flash.utils.describeType(), но обработанная информация сохраняется в виде объектов PropertyInspectorItem, в хранилище, для последующих запросов.
	* @example Пример использования
<listing version="3.0">
package {
	import aw.utils.PropertyInspector;
	import aw.utils.propertyinspector.PropertyAccessType;
	import aw.utils.propertyinspector.PropertyContainerType;
	import aw.utils.propertyinspector.PropertyItem;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	public class Test extends Sprite{
		public function Test():void{
			super();
			var staticProperies:Array = PropertyInspector.getProperties(this, PropertyAccessType.ANY, true);
			trace(staticProperies);
			var instanceProperies:Array = PropertyInspector.getProperties(this);
			trace(instanceProperies);
			var prop:PropertyItem = instanceProperies[0] as PropertyItem;
			trace('name:     ', prop.name);
			trace('access:   ', PropertyAccessType.getTypeName(prop.access));
			trace('container:', PropertyContainerType.getTypeName(prop.container));
			trace('type:     ', getQualifiedClassName(prop.type));
			trace('Rectangle properties:', PropertyInspector.getPropertiesByType(this, Rectangle));
			trace('Rectangle methods:   ', PropertyInspector.getMethodsByType(this, Rectangle));
		}
	}
}
/&#042; trace output:
prototype
soundTransform,buttonMode,graphics,dropTarget,hitArea,useHandCursor,...
name:      soundTransform
access:    readwrite
container: accessor
type:      flash.media::SoundTransform
Rectangle properties: scrollRect,scale9Grid
Rectangle methods:    getBounds,getRect
&#042;/
</listing>
	* @public 
	* @see aw.utils.propertyinspector.PropertyItem
	* @see aw.utils.propertyinspector.PropertyInspectorItem
	* @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	*/
	//TODO: Добавить проверку на тип namespace
	//TODO: В isExists нужно учесть, что могут быть одноимённые члены класса статические и экземпляра

	/** 
	* 
	* 
	* 
	* @public 
	* @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	*/
	public final class PropertyInspector extends Object{

		/** 
		* Text of the error, occurs when failure to gain access to the object
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const OBJECT_NULL_ERROR:String = 'Object is NULL.';

		/** 
		* Dictionary of objects and their descriptions
		* _types[object definition] = object description.
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static protected var _types:Dictionary = new Dictionary();

		/** 
		* Get PropertyInspectorItem object contains the information about target object
		* 
		* 
		* @public 
		* @param o Object instance or definition
		* @return PropertyInspectorItem 
		* @see aw.utils.propertyinspector.PropertyInspectorItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getInfo(o:Object):PropertyInspectorItem{
			if(!o) throw new Error(OBJECT_NULL_ERROR);
			var pii:PropertyInspectorItem;
			var cls:Class = (o is Class) ? o as Class : o.constructor;
			if(!(cls in _types)) _types[cls] = new PropertyInspectorItem(cls);
			pii = _types[cls];
			return pii;
		}

		/** 
		* Get properties of object by level of access
		* 
		* 
		* @public 
		* @param o Object instance or definition
		* @param acc Access type
		* @param useStatic Use static memebers only
		* @return Array
		* @see aw.utils.propertyinspector.PropertyItem 
		* @see aw.utils.propertyinspector.PropertyAccessType
		* @see aw.utils.propertyinspector.PropertyInspectorItem#getProperties
		* @see aw.utils.propertyinspector.PropertyInspectorItem#static_ns::getProperties
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getProperties(o:Object, acc:int=-1, useStatic:Boolean=false):Array{
			if(!o) throw new Error(OBJECT_NULL_ERROR);
			var pii:PropertyInspectorItem = getInfo(o);
			return useStatic ? pii.static_ns::getProperties(acc) : pii.getProperties(acc);
		}

		/** 
		* Retrieve object PropertyItem, by name of a member of the class
		* 
		* 
		* @public 
		* @param o Object instance or definition
		* @param name Name of property can be String or QName instance
		* @return PropertyItem 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getByName(o:Object, name:*):PropertyItem{
			if(!o) throw new Error(OBJECT_NULL_ERROR);
			var pii:PropertyInspectorItem = getInfo(o);
			var pi:PropertyItem = pii.getByName(name);
			return Boolean(pi) ? pi : pii.static_ns::getByName(name);
		}

		/** 
		* Verifies the existence of a member of the class, by its name
		* 
		* 
		* @public 
		* @param o Object instance or definition
		* @param name Name of property can be String or QName instance
		* @return Boolean 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function isExists(o:Object, name:*):Boolean{
			if(!o) throw new Error(OBJECT_NULL_ERROR);
			var pii:PropertyInspectorItem = getInfo(o);
			return (pii.static_ns::isExists(name) || pii.isExists(name));
		}

		/** 
		* Returns TRUE, if passed the name of the property and FALSE - if the name of the method.
		* 
		* 
		* @public 
		* @param o Object instance or definition
		* @param name Name of property can be String or QName instance
		* @return Boolean 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function isProperty(o:Object, name:*):Boolean{
			if(!o) throw new Error(OBJECT_NULL_ERROR);
			var pii:PropertyInspectorItem = getInfo(o);
			return (pii.static_ns::isProperty(name) || pii.isProperty(name));
		}

		/** 
		* Returns properties by the type of class member
		* 
		* 
		* @public 
		* @param o Object instance or definition.
		* @param cont 
		* @param useStatic Use static memebers only
		* @return Array 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @see aw.utils.propertyinspector.PropertyContainerType 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getPropertiesByContainer(o:Object, cont:int=-1, useStatic:Boolean=false):Array{
			if(!o) throw new Error(OBJECT_NULL_ERROR);
			var pii:PropertyInspectorItem = getInfo(o);
			return useStatic ? pii.static_ns::getPropertiesByContainer(cont) : pii.getPropertiesByContainer(cont);
		}

		/** 
		* Returns the properties by value type
		* 
		* 
		* @public 
		* @param o Object instance or definition
		* @param type Тип значения, по которому требуется произвести выборку.
		* @param useStatic Use static memebers only
		* @return Array 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getPropertiesByType(o:Object, type:Class, useStatic:Boolean=false):Array{
			if(!o) throw new Error(OBJECT_NULL_ERROR);
			var pii:PropertyInspectorItem = getInfo(o);
			return useStatic ? pii.static_ns::getPropertiesByType(type) : pii.getPropertiesByType(type);
		}

		/** 
		* Возвращает список всех объектов PropertyItem, описывающих методы.
		* 
		* 
		* @public 
		* @param o Object instance or definition
		* @param useStatic Use static memebers only
		* @return Array 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getMethods(o:Object, useStatic:Boolean=false):Array{
			if(!o) throw new Error(OBJECT_NULL_ERROR);
			var pii:PropertyInspectorItem = getInfo(o);
			return useStatic ? pii.static_ns::methods : pii.methods;
		}

		/** 
		* Returns list of PropertyItem, which describes object methods.
		* 
		* 
		* @public 
		* @param o Object instance or definition
		* @param type Type of return value
		* @param useStatic Use static memebers only
		* @return Array 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getMethodsByType(o:Object, type:Class, useStatic:Boolean=false):Array{
			if(!o) throw new Error(OBJECT_NULL_ERROR);
			var pii:PropertyInspectorItem = getInfo(o);
			return useStatic ? pii.static_ns::getMethodsByType(type) : pii.getMethodsByType(type);
		}

		/** 
		* Returns an object with duplicates of the source object properties and their values
		* 
		* 
		* @public 
		* @param obj Target object
		* @param type If the type of values is specified, will be processed only properties with values of this type
		* @return Object 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function save(obj:Object, type:Class=null):Object{
			var ret:Object = {};
			var arr:Array = getProperties(obj);
			var len:int = arr.length;
			var name:QName;
			var prop:PropertyItem;
			for(var i:int=0; i<len; i++){
				prop = arr[i] as PropertyItem;
				name = prop.name;
				if((prop.access == PropertyAccessType.READWRITE || prop.access == PropertyAccessType.READONLY) && (!type || prop.type==type)){
					ret[String(name)] = obj[name];
				}
			}
			return ret;
		}

		/** 
		* Returns an object containing properties with values similar in both objects
		* 
		* 
		* @public 
		* @param obj1 First object
		* @param obj2 Second object
		* @param type If the type of values is specified, will be processed only properties with values of this type
		* @return Object 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function intersect(obj1:Object, obj2:Object, type:Class=null):Object{
			if(!obj1 || !obj2) throw new Error(OBJECT_NULL_ERROR);
			var ret:Object = new Object();
			var arr:Array = compatible(obj1, obj2);
			var len:int = arr.length;
			var name:QName;
			var prop:PropertyItem;
			var val1:*;
			var val2:*;
			for(var i:int=0; i<len; i++){
				prop = arr[i] as PropertyItem;
				if(!type || (type && prop.type==type)){
					name = prop.name;
					val1 = obj1[name];
					val2 = obj2[name];
					if(val1==val2) ret[name] = val1;
				}
			}
			return ret;
		}

		/** 
		* Returns an object containing properties with the values of the first object having a value different from the values of the same properties of the second object
		* 
		* 
		* @public 
		* @param obj1 First object
		* @param obj2 Second object
		* @param type If the type of values is specified, will be processed only properties with values of this type
		* @return Object 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function difference(obj1:Object, obj2:Object, type:Class=null):Object{
			if(!obj1 || !obj2) throw new Error(OBJECT_NULL_ERROR);
			var ret:Object = new Object();
			var arr:Array = compatible(obj1, obj2);
			var len:int = arr.length;
			var name:QName;
			var prop:PropertyItem;
			var val1:*;
			var val2:*;
			for(var i:int=0; i<len; i++){
				prop = arr[i] as PropertyItem;
				if(!type || (type && prop.type==type)){
					name = prop.name;
					val1 = obj1[name];
					val2 = obj2[name];
					if(val1!=val2) ret[name] = val1;
				}
			}
			return ret;
		}

		/** 
		* Changes between the objects, values of common properties that have the same names and types of values
		* 
		* 
		* @public 
		* @param obj1 First object
		* @param obj2 Second object
		* @param type If the type of values is specified, will be processed only properties with values of this type
		* @param names An array of names of properties, if specified, the method will work only with those properties
		* @return void 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function invert(obj1:Object, obj2:Object, type:Class=null, names:Array=null):void{
			if(!obj1 || !obj2) throw new Error(OBJECT_NULL_ERROR);
			var i:int;
			var val1:*;
			var val2:*;
			var len:int;
			var name:QName;
			var prop:PropertyItem;
			var noNames:Object = {};
			if(names){
				len = names.length;
				for(i=0; i<len; i++) noNames[String(names[i])] = true;
			}
			var tempNames:Array = [];
			var tempValues:Array = [];
			var arr:Array = compatible(obj1, obj2);
			len = arr.length;
			for(i=0; i<len; i++){
				prop = arr[i] as PropertyItem;
				name = prop.name;
				if((!type || (type && prop.type==type)) && !(String(name) in noNames)){
					tempNames.push(name);
					tempValues.push(obj1[name]);
					obj1[name] = obj2[name];
				}
			}
			len = tempNames.length;
			for(i=0; i<len; i++){
				obj2[tempNames[i]] = tempValues[i];
			}
		}

		/** 
		* Returns an array of PropertyItem objects describing available for reading and writing properties that are present in both objects
		* 
		* 
		* @public 
		* @param obj1 First object
		* @param obj2 Second object
		* @return Array 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function compatible(obj1:Object, obj2:Object):Array{
			if(!obj1 || !obj2) throw new Error(OBJECT_NULL_ERROR);
			var ret:Array = new Array();
			var arr:Array = getProperties(obj1);
			var len:int = arr.length;
			var prop1:PropertyItem;
			var prop2:PropertyItem;
			for(var i:int=0; i<len; i++){
				prop1 = arr[i] as PropertyItem;
				prop2 = getByName(obj2, prop1.name);
				if(prop2 && 
					prop1.access == PropertyAccessType.READWRITE && 
					prop2.access == PropertyAccessType.READWRITE && 
					prop1.type==prop2.type
				){
					ret.push(prop1);
				}
			}
			return ret;
		}

		/** 
		* Returns an array of PropertyItem objects describing available for read and write properties and are opposed (to the type of content), or missing in one of the objects 
		* 
		* 
		* @public 
		* @param obj1 First object
		* @param obj2 Second object
		* @return Array 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function incompatible(obj1:Object, obj2:Object):Array{
			if(!obj1 || !obj2) throw new Error(OBJECT_NULL_ERROR);
			var ret:Array = new Array();
			var temp:Object = {};
			var arr:Array = getProperties(obj1).concat(getProperties(obj2));
			var len:int = arr.length;
			var name:String;
			var prop:PropertyItem;
			for(var i:int=0; i<len; i++){
				prop = arr[i] as PropertyItem;
				if(prop.access!=PropertyAccessType.READWRITE) continue;
				name = String(prop.name);
				if(!(name in temp)){
					temp[name] = prop;
					ret.push(prop);
				}
			}
			return ret;
		} 
	}
}