package aw.utils.propertyinspector{

	/** 
	* Возможные типы доступа к членам классов и их значения.
	* 
	* 
	* @public 
	* @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	* @see aw.utils.PropertyInspector
	*/
	public final class PropertyAccessType extends Object{

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
		* Read and Write
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const READWRITE:int = 0;

		/** 
		* Read only
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const READONLY:int = 1;

		/** 
		* Write only
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const WRITEONLY:int = 2;

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
		static public const READWRITE_NAME:String = 'readwrite';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const READONLY_NAME:String = 'readonly';

		/** 
		* 
		* 
		* 
		* @public (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const WRITEONLY_NAME:String = 'writeonly';

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
		* @private (internal,constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static internal const TYPES:Object = {readwrite:0, readonly:1, writeonly:2, method:3};

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const TYPE_LIST:Object = [READWRITE_NAME, READONLY_NAME, WRITEONLY_NAME, METHOD_NAME];

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