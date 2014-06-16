package aw.utils.eval{
	import aw.utils.iteration.LengthIterationIndex;
	
	/** Gets from a string numeric value and converts to a number.
	 * 
	 * 
	 * @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	 * @playerversion Flash 9.0.28.0
	 * @langversion 3.0
	*/
	public class NumberEval extends Object{

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const NUMBER_CHAR:String = '.0123456789';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const NUMBER_FULL_CHAR:String = '.0123456789xABCDEFabcdef';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const HEX_CHAR:String = 'x';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const DOT_CHAR:String = '.';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const EXPONENT_CODE_CHARS:String = 'eE';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const EXPONENT_SIGN_CHARS:String = '+-';

		/** 
		* 
		* 
		* 
		* @public 
		* @param str 
		* @param iteration 
		* @return Number 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function evaluate(str:String, iteration:LengthIterationIndex=null):Number{
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
		* @return Number 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getData(str:String, iteration:LengthIterationIndex):Number{
			var start:int = iteration.index;
			var len:int = iteration.length;
			var end:int = start;
			var chr:String;
			var floatNumber:Boolean = false;
			while(NUMBER_FULL_CHAR.indexOf((chr = str.charAt(end)))>=0 && end<len){
				if(chr==DOT_CHAR || chr==HEX_CHAR){
					if(floatNumber) break;
					else floatNumber = true;
				}else if(EXPONENT_CODE_CHARS.indexOf(chr)>=0 && EXPONENT_SIGN_CHARS.indexOf(str.charAt(end+1))>=0){
					end++;
					floatNumber = true;
				}
				end++;
			}
			iteration.index = end;
			// trace('----------- NUMBER LAST CHAR', str.charAt(end));
			return Number(str.substring(start, end));
		}
	}
}