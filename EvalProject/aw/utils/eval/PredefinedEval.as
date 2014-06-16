package aw.utils.eval{
	import aw.utils.iteration.LengthIterationIndex;
	
	/** Converts a string to a constant value.
	 * 
	 * 
	 * @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	 * @playerversion Flash 9.0.28.0
	 * @langversion 3.0
	*/
	public class PredefinedEval extends Object{

		/** 
		* 
		* 
		* 
		* @private 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public var CONSTANT_SYMBOLS:Object = {};

		/** 
		* 
		* 
		* 
		* @private 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private var CONSTANT_MAX_LENGTH:int;

		/** 
		* 
		* 
		* 
		* @private (internal,constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static internal const CONSTANTS:Object = function ():Object{
			var obj:Object = {};
			obj['null'] = null;
			obj['true'] = true;
			obj['false'] = false;
			obj['undefined'] = undefined;
			obj['Infinity'] = Infinity;
			obj['+Infinity'] = +Infinity;
			obj['-Infinity'] = -Infinity;
			obj['NaN'] = NaN;
			obj['AS3'] = AS3;
			for(var p:String in obj){
				var len:int = p.length;
				for(var i:int=0; i<len; i++) CONSTANT_SYMBOLS[p.charAt(i)] = true;
				CONSTANT_MAX_LENGTH = Math.max(len, CONSTANT_MAX_LENGTH);
			}
			return obj;
		}();

		/** 
		* 
		* 
		* 
		* @public 
		* @param str 
		* @param iteration 
		* @return String 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function isDefined(str:String, iteration:LengthIterationIndex=null):String{
			var chr:String;
			var i:int = iteration.index;
			var j:int = 0;
			var len:int = iteration.length;
			var name:String = '';
			while((chr = str.charAt(i)) in CONSTANT_SYMBOLS && j<CONSTANT_MAX_LENGTH && i<len){
				name+=chr;
				j++;
				i++;
			}
			if(name in CONSTANTS){
				iteration.index = i;
				return name;
			}else return '';
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @return * 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getData(str:String, iteration:LengthIterationIndex):*{
			var name:String = isDefined(str, iteration);
			return name ? getValue(name) : undefined;
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param name 
		* @return * 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getValue(name:String):*{
			trace('GET:', name);
			return CONSTANTS[name];
		}
		/**
		 * 
		 * @param name
		 * @param value
		 * 
		 */
		static public function define(name:String, value:*):void{
			CONSTANTS[name] = value;
		}
	}
}