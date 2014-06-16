package aw.utils.eval{
	import aw.utils.iteration.LengthIterationIndex;
	
	/** Converts a string to an object.
	 * 
	 * 
	 * @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	 * @playerversion Flash 9.0.28.0
	 * @langversion 3.0
	*/
	public class ObjectEval extends Object{

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const OBJECT_OPEN:String = '{';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const OBJECT_CLOSE:String = '}';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const OBJECT_PAIR_DELIMITER:String = ',';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const OBJECT_PAIR_SEPARATOR:String = ':';

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
		* @return Object 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getData(str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object=null):Object{
			var ret:Object = {};
			var nextValue:Boolean = true;
			var len:int = iteration.length;
			var chr:String;
			var name:String;
			var value:String;
			var i:int = iteration.index+1;
			// trace('------------------------ START PARSE OBJECT');
			while(i<len){
				chr = str.charAt(i);
				// trace('next char', chr);
				if(SPACES.indexOf(chr)>=0){
					// trace(' - space');
					i++;
					continue;
				}
				if(chr==OBJECT_CLOSE){
					iteration.index = i+1;
					// trace('close object', chr);
					break;
				}
				if(nextValue){
					// trace('next value');
					iteration.index = i;
					if(name){
						ret[name] = parseValue(str, iteration, scope);
						// trace('value: ', ret[name]);
						i = iteration.index;
						name = '';
						nextValue = false;
					}else{
						name = getPropertyName(str, iteration);
						// trace('name: ', name);
						i = iteration.index+1;
					}
					continue;
				}
				if(chr==OBJECT_PAIR_DELIMITER){
					nextValue = true;
					i++;
					// trace('pair delimiter', chr);
					continue;
				}
				i++;
			}
			// trace('------------------------ STOP PARSE OBJECT');
			return ret;
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
		static public function getPropertyName(str:String, iteration:LengthIterationIndex):String{
			var i:int = iteration.index;
			var name:String;
			var end:int;
			if(StringEval.STRING_STOP.indexOf(str.charAt(i))>=0){
				// name as string - in quotes: {"some name string":true}
				name = StringEval.getData(str, iteration);
				end = str.indexOf(OBJECT_PAIR_SEPARATOR, iteration.index);
				if(end>0) iteration.index = end;
			}else{
				// name as basic name: {someName:true}
				end = str.indexOf(OBJECT_PAIR_SEPARATOR, i);
				if(end>0){
					iteration.index = end;
					while(SPACES.indexOf(str.charAt(--end))>=0){
						// nothing to do;
					}
					name = str.substring(i, end+1);
				}
			}
			return name;
		}
	}
}