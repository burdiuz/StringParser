package aw.utils.eval{
	import aw.utils.iteration.LengthIterationIndex;
	
	/** Converts a string to an RegExp object. 
	 * 
	 * 
	 * @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	 * @playerversion Flash 9.0.28.0
	 * @langversion 3.0
	*/
	public class RegExpEval extends Object{

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const REGEXP_OPEN:String = '/';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const REGEXP_ADDON:String = 'gimsx';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const STRING_META_CHAR:String = '\\';

		/** 
		* 
		* 
		* 
		* @public 
		* @param str 
		* @param iteration 
		* @return RegExp 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function evaluate(str:String, iteration:LengthIterationIndex=null):RegExp{
			if(!iteration) iteration = new LengthIterationIndex(str.length);
			return getData(str, iteration);
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @return RegExp 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getData(str:String, iteration:LengthIterationIndex):RegExp{
			var rgx:String = getRegExpExpression(str, iteration);
			var length:int = iteration.length;
			var i:int = iteration.index;
			var j:int = i+1;
			while(i<length && REGEXP_ADDON.indexOf(str.charAt(++i))>=0){
				// nothing to do;
			}
			var keys:String = str.substring(j, i);
			iteration.index = i;
			return new RegExp(rgx, keys);
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @return String 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getRegExpExpression(str:String, iteration:LengthIterationIndex):String{
			var i:int = iteration.index;
			var j:int = i;
			var mI:int;
			while((j = str.indexOf(REGEXP_OPEN, j+1))>=0){
				mI = j;
				while(str.charAt(--mI)==STRING_META_CHAR){
					// nothing to do;
				}
				if((j-mI)%2==1) break;
			}
			iteration.index = j;
			return str.substring(i+1, j);
		}
	}
}