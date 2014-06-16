package aw.utils.eval{
	import aw.utils.iteration.LengthIterationIndex;
	
	/** Gets from the string line framed quotations and converts special characters.
	 * 
	 * 
	 * @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	 * @playerversion Flash 9.0.28.0
	 * @langversion 3.0
	*/
	public class StringEval extends Object{

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const SPACES:String = ' \n\t\r';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const STRING_STOP:String = '"\'`';

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
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const UNICODE_META_CHAR:String = 'u';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const META_SEQUENCE_LENGTH:int = 2;

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const UNICODE_CODE_LENGTH:int = 4;

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const HEXADECIMAL_DIGIT_START:String = '0x';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const HEXADECIMAL_DIGIT_RADIX:int = 16;

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const STRING_REPLACEMENTS:Object = function ():Object{
			var obj:Object = {};
			obj['r'] = '\r';
			obj['n'] = '\n';
			obj['\\'] = '\\';
			obj['t'] = '\t';
			obj['v'] = '\v';
			obj['b'] = '\b';
			obj['f'] = '\f';
			obj['x'] = '\x';
			obj['0'] = '\0';
			obj['/'] = '\/';
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
		static public function evaluate(str:String, iteration:LengthIterationIndex=null):String{
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
		* @return String 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getData(str:String, iteration:LengthIterationIndex):String{
			return parseString(getRawData(str, iteration));
		}
		
		/**
		* 
		* @param str
		* @param iteration
		* @return 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getRawData(str:String, iteration:LengthIterationIndex, backQuote:String=''):String{
			var i:int = iteration.index;
			var quote:String = str.charAt(i);
			if(!backQuote) backQuote = quote;
			var j:int = i;
			var mI:int;
			while((j = str.indexOf(backQuote, j+1))>=0){
				mI = j;
				while(str.charAt(--mI)==STRING_META_CHAR){
					// nothing to do;
				}
				if((j-mI)%META_SEQUENCE_LENGTH==1) break;
			}
			iteration.index = ++j;
			//trace('----------- STRING LAST CHAR', str.charAt(j));
			return str.substring(i, j);
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @return void 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function skipQuotedString(str:String, iteration:LengthIterationIndex):void{
			var i:int = iteration.index;
			var q:String = str.charAt(i);
			var j:int = i;
			var mI:int;
			while((j = str.indexOf(q, j+1))>=0){
				mI = j;
				while(str.charAt(--mI)==STRING_META_CHAR){
					// nothing to do;
				}
				if((j-mI)%META_SEQUENCE_LENGTH==1) break;
			}
			iteration.index = j+1;
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @return String 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function parseString(str:String):String{
			var q:String = str.charAt(0);
			var j:int = 0;
			var src:String;
			var rpl:String;
			while((j = str.indexOf(STRING_META_CHAR, j+1))>=0){
				src = str.charAt(j+1);
				if(src in STRING_REPLACEMENTS) rpl = STRING_REPLACEMENTS[src];
				else if(src==UNICODE_META_CHAR){
					rpl = String.fromCharCode(parseInt(HEXADECIMAL_DIGIT_START+str.substr(j+META_SEQUENCE_LENGTH, UNICODE_CODE_LENGTH), HEXADECIMAL_DIGIT_RADIX));
					j+=UNICODE_CODE_LENGTH;
				}else if(src == q) rpl = q;
				else continue;
				str = str.substr(0, j)+rpl+str.substr(j+META_SEQUENCE_LENGTH);
			}
			return str.substring(1, str.length-1);
		}
	}
}