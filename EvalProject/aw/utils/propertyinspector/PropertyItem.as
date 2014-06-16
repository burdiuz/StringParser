package aw.utils.propertyinspector{
	import aw.data.*;
	
	import flash.utils.getQualifiedClassName;

	/** 
	* 	Object describing a member of a class (property or method). It stores information about the features, such as: name, type of return value, type member of the class, level of access
	* 
	* 
	* @public 
	* @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	*/
	public class PropertyItem extends Object{

		/** 
		* 
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected var _name:QName;

		/** 
		* 
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected var _type:Class;

		/** 
		* 
		* 
		* 
		* @private (protected)
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected var _container:int;

		/** 
		* 
		* 
		* 
		* @private (protected) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		protected var _access:int;

		/** 
		* Into the constructor passed characteristics of the class members
		* 
		* 
		* @public 
		* @param n 
		* @param t 
		* @param a 
		* @param p 
		* @param u 
		* @return void 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function PropertyItem(n:String, t:Class, a:int, p:int, u:String=''):void{
			super();
			_name = new QName(u, n);
			_type = t;
			_access = a;
			_container = p;
		}

		/** 
		* Returns a string representation of the object, the name of the property
		* 
		* 
		* @public 
		* @return String 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function toString():String{
			return this._name.toString();
		}

		/** 
		* Name of a member of the class
		* 
		* 
		* @public (getter) 
		* @return QName 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get name():QName{
			return this._name;
		}

		/** 
		* Namespace URI in which the member of the class
		* 
		* 
		* @public (getter) 
		* @return String 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get uri():String{
			return this._name.uri;
		}

		/** 
		* Namespace in which the members of the class
		* 
		* 
		* @public (getter) 
		* @return Namespace 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get namespace():Namespace{
			return new Namespace(this._name.uri);
		}

		/** 
		* Local name of a member of the class
		* 
		* 
		* @public (getter) 
		* @return String 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get localName():String{
			return this._name.localName;
		}

		/** 
		* Type of return value, and for the properties - the type of property value
		* 
		* 
		* @public (getter) 
		* @return Class 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get type():Class{
			return this._type;
		}

		/** 
		* Type of class members - a variable, GET/SET method, a constant or method
		* 
		* 
		* @public (getter) 
		* @return int 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get container():int{
			return this._container;
		}

		/** 
		* The level of access - read / write, read only, write only, or method
		* 
		* 
		* @public (getter) 
		* @return int 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function get access():int{
			return this._access;
		}

		/** 
		* Name of a member of the class
		* 
		* 
		* @public 
		* @return String 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function valueOf():QName{
			return this._name;
		}

		/** 
		* Clone
		* 
		* 
		* @public 
		* @return PropertyItem 
		* @see aw.utils.propertyinspector.PropertyItem 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		public function clone():PropertyItem{
			return new PropertyItem(this._name.localName, this._type, this._container, this._access, this._name.uri);
		}
	}
}