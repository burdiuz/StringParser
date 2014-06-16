package aw.utils.propertyinspector{

	/** 
	* Types of acceptable members of the class and their values 
	* 
	* 
	* @public 
	* @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	* @see aw.utils.PropertyInspector
	*/
	public final class PropertyContainerType extends Object{

		/** 
		* Any type
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ANY:int = -1;

		/** 
		* Variable
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const VARIABLE:int = 0;

		/** 
		* Accessor method (GET/SET method).
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ACCESSOR:int = 1;

		/** 
		* Constant
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const CONSTANT:int = 2;

		/** 
		* Method
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const METHOD:int = 3;

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const VARIABLE_NAME:String = 'variable';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ACCESSOR_NAME:String = 'accessor';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const CONSTANT_NAME:String = 'constant';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const METHOD_NAME:String = 'method';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const TYPE_LIST:Object = [VARIABLE_NAME, ACCESSOR_NAME, CONSTANT_NAME, METHOD_NAME];

		/** 
		* The method returns a description by value type
		* 
		* 
		* @public
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getTypeName(type:int):String{
			return TYPE_LIST[type];
		}
	}
}