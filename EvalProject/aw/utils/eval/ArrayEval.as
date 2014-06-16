package aw.utils.eval{
	import aw.utils.iteration.LengthIterationIndex;
	
	/** Converts a string to an Array.
	 * 
	 * 
	 * @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	 * @playerversion Flash 9.0.28.0
	 * @langversion 3.0
	*/
	public class ArrayEval extends Object{

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ARRAY_OPEN:String = '[';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ARRAY_CLOSE:String = ']';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ARRAY_ITEM_DELIMITER:String = ',';

		/** 
		* 
		* 
		* 
		* @private 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private var SPACES:String = StringEval.SPACES;

		/** 
		* 
		* 
		* 
		* @public 
		* @param str 
		* @param iteration 
		* @param parseValue 
		* @param scope 
		* @param closeChar 
		* @return Array 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getData(str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object=null, closeChar:String=ARRAY_CLOSE):Array{
			var ret:Array = [];
			var chr:String;
			var name:String;
			var value:String;
			var len:int = iteration.length;
			var i:int = iteration.index+1;
			var nextValue:Boolean = true;
			// trace('------------------------ START PARSE ARRAY', str.substr(iteration.index));
			while(i<len){
				chr = str.charAt(i);
				// trace('next char', chr);
				if(SPACES.indexOf(chr)>=0){
					// trace(' - space');
					i++;
					continue;
				}
				if(chr==closeChar){
					iteration.index = i+1;
					// trace('close array', chr);
					break;
				}
				if(nextValue){
					iteration.index = i;
					ret.push(parseValue(str, iteration, scope));
					// trace('value: ', ret[ret.length-1]);
					nextValue = false;
					i = iteration.index;
					continue;
				}
				if(chr==ARRAY_ITEM_DELIMITER){
					nextValue = true;
					i++;
					// trace('item delimiter', chr);
					continue;
				}
				i++;
			}
			// trace('------------------------ STOP PARSE ARRAY', str.substr(iteration.index));
			return ret;
		}
	}
}