package aw.utils{
	import aw.collections.Dict;
	
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

		/* *
		* Class for working with object classes/definitions.
		* Allows you to create instances of classes by name or Class object.
		* @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
	public class ClassUtils extends Object{
		static public const VECTOR_CLASS_NAME:String = getQualifiedClassName(ApplicationDomain.currentDomain.hasDefinition('__AS3__.vec.Vector') ? ApplicationDomain.currentDomain.getDefinition('__AS3__.vec.Vector') : ApplicationDomain.currentDomain.getDefinition('Vector'));
		static public const WRONG_NAME_ERROR:String = 'ClassUtils Error: can\'t found [$cls] class definition by name';
		static protected const classCallers:Array = [call0Class, call1Class, call2Class, call3Class, call4Class, call5Class, call6Class, call7Class, call8Class, call9Class, call10Class, call11Class, call12Class, call13Class, call14Class, call15Class];
		static private const _definitionNames:Dictionary = new Dictionary(true);

		/**
		* Returns an Class object by its instance
		* 
		* @param any Class instance  
		* @return Class
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function getClassDefinition(any:*):Class{
			var cls:Object = null;
			if(any is Proxy) cls = getDefinitionByName(getQualifiedClassName(any));
			else cls = Object(any).constructor;
			return cls as Class;
		}
		
		/**
		 * Get Vector class defnition with selected elements type 
		 * @param itemDefinition Selected element type
		 * @param applicationDomain Application domain of element type
		 * @return Vector class definition
		 * 
		 */
		static public function getVectorDefinition(itemDefinition:Class, applicationDomain:ApplicationDomain=null):Class{
			if(!applicationDomain) applicationDomain = ApplicationDomain.currentDomain;
			return applicationDomain.getDefinition(VECTOR_CLASS_NAME+'.<'+getQualifiedClassName(itemDefinition)+'>') as Class;
		}
		
		/**
		 * Create Vector class instance with selected elements type
		 * @param itemDefinition Selected element type
		 * @param length Vector length
		 * @param fixed Fixed length
		 * @param applicationDomain Application domain of element type 
		 * @return Vector class instance
		 * 
		 */
		static public function createCustomVector(itemDefinition:Class, length:uint=0, fixed:Boolean=false, applicationDomain:ApplicationDomain=null):*/* Vector.<*> */{
			var definition:Class = getVectorDefinition(itemDefinition, applicationDomain);
			return new definition(length, fixed);
		}
		static public function isVector(object:Object):Boolean{
			return object is Class ? getQualifiedClassName(object).indexOf(VECTOR_CLASS_NAME) == 0 : object is Vector.<*>;
		}
		static public function isExtendedBy(child:Class, parent:Class):Boolean{
			return parent.prototype.isPrototypeOf(child.prototype);
		}
		/**
		 * Returns the name of the class.
		 * 
		 * @param value Class object, a instance of it or name (if set name of a non-existent class, it returns the class name "String")
		 * @param skipStringDomainValidation
		 * @param applicationDomain
		 * @return 
		 * 
		 */
		static public function getClassName(value:*, skipStringDomainValidation:Boolean=false, applicationDomain:ApplicationDomain=null):String{
			if(value is String){
				if((value as String).charAt()=='<') value = VECTOR_CLASS_NAME+'.'+value; // protection for shortcutting Vector names in expressions like "new <flash.display::Sprite>[new Sprite()];"
				if(skipStringDomainValidation || ((applicationDomain ? applicationDomain : ApplicationDomain.currentDomain) as ApplicationDomain).hasDefinition(value)){
					return value;
				}
			}
			return getQualifiedClassName(value);
		}
		/**
		 * Will return Cloass local name excluding package, if Vector passed, will return name with item type fully qualified name, e.g. Vector.<flash.display::Sprite>
		 * @param cls instance of Class type or string representing Class name
		 * @return String Class local name
		 * 
		 */
		static public function getLocalName(cls:*, vectorTypeLocal:Boolean=false):String{
			var name:String = getClassName(cls, true);
			var vectorType:String = '';
			var baseName:String = name;
			var index:int = name.indexOf('<');
			if(index>0 && vectorTypeLocal){
				const parts:Array = name.substring(0, name.indexOf('>')).split('.<');
				name = '';
				index = parts.length;
				while(--index>=0){
					var current:String = parts[index];
					var indexDot:int = current.lastIndexOf('.');
					var indexColon:int = current.lastIndexOf(':');
					current = current.substring((indexColon>indexDot ? indexColon : indexDot)+1);
					if(name) name = current+'.<'+name+'>';
					else name = current;
				}
				return name;
			}else{
				if(index>0){
					vectorType = baseName.substr(--index);
					baseName = baseName.substr(0, index);
				}
				var localName:String = (baseName.indexOf(':')>0 ? baseName.split('::').pop() : baseName.split('.').pop())+vectorType;
				return localName;
			}
		}
		/**
		 * Method returns all qualified Class names used in passed Class definition. 
		 * Its helpful with Vector classes, it will return all class names used in 
		 * Vector definition. 
		 * For example, vector class Vector.<Vector.<Vector<flash.display::Sprite>>> 
		 * will be broken to 
		 * Vector.<Vector.<Vector<flash.display::Sprite>>>, 
		 * Vector.<Vector<flash.display::Sprite>>, 
		 * Vector<flash.display::Sprite>, 
		 * flash.display::Sprite
		 * covering all Class names/types used in this collection.
		 * @param value Instance of Class type or string representing Class name.
		 * @return 
		 * 
		 */
		static public function parseClassName(value:*):Array{
			const list:Array = [];
			const name:String = getClassName(value, true);
			var index:int = name.length;
			while(name.charAt(--index-1)=='>'){};
			const parts:Array = name.substr(0, index).split('.<');
			var part:String = '';
			index = parts.length;
			while(--index>=0){
				var current:String = parts[index];
				if(part) part = current+'.<'+part+'>';
				else part = current;
				list.unshift(part);
			}
			return list;
			/*
			var index:int;
			var className:String = getClassName(cls, true);
			const list:Array = [className];
			var startIndex:int = 0;
			while((index = className.indexOf('<', startIndex))>0){
				var count:int = 1;
				startIndex = ++index;
				do{
					var indexLt:int = className.indexOf('<', index);
					var indexGt:int = className.indexOf('>', index);
					if(indexLt>0 && indexLt<indexGt){
						count++;
						index = indexLt+1;
						continue;
					}else if(indexGt>0){
						count--;
						if(!count){
							list.push(className.substring(startIndex, indexGt));
							break;
						}else index = indexGt+1;
					}else break;
				}while(count>0);
			}
			return list;
			*/
		}
		/**
		 * Analog method of parseClassName, but returns list of local names without packages info
		 * @param value
		 * @return 
		 * 
		 */
		static public function parseClassNameLocal(value:*):Array{
			const list:Array = [];
			const name:String = getClassName(value, true);
			var index:int = name.length;
			while(name.charAt(--index-1)=='>'){};
			const parts:Array = name.substr(0, index).split('.<');
			var part:String = '';
			index = parts.length;
			while(--index>=0){
				var current:String = parts[index];
				var indexDot:int = current.lastIndexOf('.');
				var indexColon:int = current.lastIndexOf(':');
				current = current.substring((indexColon>indexDot ? indexColon : indexDot)+1);
				if(part) part = current+'.<'+part+'>';
				else part = current;
				list.unshift(part);
			}
			return list;
		}

		/**
		* Emulates the same method of the Function class.
		* 
		* @param cls Class object, a copy of which will be retrieved
		* @param arr List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function apply(cls:Object, arr:Array=null):*{
			if(!arr) arr = [];
			var f:Function = classCallers[arr.length];
			if(f!=null) return f(cls, arr);
			else throw new Error(cantCreateErrorString(getQualifiedClassName(cls)));
		}

		/**
		* Creates a copy of the class by its name, passing in the constructor parameters from the array
		* 
		* @param name Class name, which instance to get
		* @param arr List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function applyByName(name:String, arr:Array=null):*{
			var ad:ApplicationDomain = ApplicationDomain.currentDomain;
			var cls:Class;
			if(ad.hasDefinition(name)){
				cls = ad.getDefinition(name) as Class;
			}
			if(!cls) throw new IllegalOperationError(WRONG_NAME_ERROR.split('$cls').join(name));
			if(!arr) arr = [];
			var f:Function = classCallers[arr.length];
			if(f!=null) return f(cls, arr);
			else throw new Error(cantCreateErrorString(name));
		}
		
		/**
		* Emulates the same method of the Function class.
		* 
		* @param cls Class object
		* @param ...args List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function call(cls:Object, ...args:Array):*{
			var f:Function = classCallers[args.length];
			if(f!=null) return f(cls, args);
			else throw new Error(cantCreateErrorString(getQualifiedClassName(cls)));
		}

		/**
		* Creates a copy of the class by its name, passing in the constructor, all parameters following by the class name.
		* 
		* @param cls Class object
		* @param ...args List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function callByName(name:String, ...args:Array):*{
			var ad:ApplicationDomain = ApplicationDomain.currentDomain;
			var cls:Class;
			if(ad.hasDefinition(name)){
				cls = ad.getDefinition(name) as Class;
			}
			if(!cls) throw new IllegalOperationError(WRONG_NAME_ERROR);
			var f:Function = classCallers[args.length];
			if(f!=null) return f(cls, args);
			else throw new Error(cantCreateErrorString(getQualifiedClassName(cls)));
		}

		/**
		* Get a reference to the method, which creates a copy of the class, by the number of arguments
		* @private
		* @param i 	Number of arguments
		* @return Function
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function getClassCaller(i:uint):Function{
			return classCallers[i];
		}

		/**
		* Get instance of class, which constructor takes no parameters
		* @private
		* @param cls Class object
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call0Class(cls:Object, a:Array=null):*{
			return new cls();
		}

		/**
		* Get instance of class, which constructor takes 1 parameter
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call1Class(cls:Object, a:Array):*{
			return new cls(a[0]);
		}

		/**
		* Get instance of class, which constructor takes 2 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call2Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1]);
		}

		/**
		* Get instance of class, which constructor takes 3 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call3Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2]);
		}

		/**
		* Get instance of class, which constructor takes 4 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call4Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3]);
		}

		/**
		* Get instance of class, which constructor takes 5 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call5Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4]);
		}

		/**
		* Get instance of class, which constructor takes 6 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call6Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5]);
		}

		/**
		* Get instance of class, which constructor takes 7 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call7Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
		}

		/**
		* Get instance of class, which constructor takes 8 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call8Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
		}

		/**
		* Get instance of class, which constructor takes 9 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call9Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
		}

		/**
		* Get instance of class, which constructor takes 10 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call10Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]);
		}

		/**
		* Get instance of class, which constructor takes 11 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call11Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10]);
		}

		/**
		* Get instance of class, which constructor takes 12 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call12Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]);
		}

		/**
		* Get instance of class, which constructor takes 13 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call13Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12]);
		}

		/**
		* Get instance of class, which constructor takes 14 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call14Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13]);
		}

		/**
		* Get instance of class, which constructor takes 15 parameters
		* @private
		* @param cls Class object
		* @param a List of parameters for constructor
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function call15Class(cls:Object, a:Array):*{
			return new cls(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14]);
		}

		/**
		* Creates an error message
		* @private
		* @param cls Class name, that caused the error
		* @return *
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static private function cantCreateErrorString(name:String):String{
			return 'ClassUtils can\'t create "'+name+'" instance.'
		}
	}
}