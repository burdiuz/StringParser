package aw.projects.stringparser.customs.json{
	
	import aw.projects.stringparser.sub.IStringSubParser;
	import aw.projects.stringparser.sub.StringSubParser;
	import aw.projects.stringparser.utils.IStringParserRunner;
	
	/**
	 * 
<listing>
import aw.projects.stringparser.customs.json.StringSubParser;
import aw.projects.stringparser.utils.StringParserRunner;
import aw.projects.stringparser.utils.IStringParserRunner;

var parser:StringSubParser = new StringSubParser();
var data:String = "something '\"` This is the sub-string we\\\", \\', \\` are looking for!`\"'# something here";
var runner:IStringParserRunner;
var result:String;
 // Parse with '
runner = new StringParserRunner(10);
result = parser.parse(data, runner);
trace(runner.currentIndex, runner.length, data.charAt(runner.lastIndex));
trace(result);
// Parse with "
runner = new StringParserRunner(11);
result = parser.parse(data, runner);
trace(runner.currentIndex, runner.length, data.charAt(runner.lastIndex));
trace(result);
// Parse with `
runner = new StringParserRunner(12);
result = parser.parse(data, runner);
trace(runner.currentIndex, runner.length, data.charAt(runner.lastIndex));
trace(result);
</listing>
	 */
	
	public class StringSubParser extends aw.projects.stringparser.sub.StringSubParser implements IStringSubParser{
		static public const DATA_TYPE:String = "string";
		static public const SPACES:String = ' \n\t\r';
		static private const STRING_STOP:String = '"\'`';
		static private const STRING_META_CHAR:String = '\\';
		static private const UNICODE_META_CHAR:String = 'u';
		static private const META_SEQUENCE_LENGTH:uint = 2;
		static private const UNICODE_CODE_LENGTH:uint = 4;
		static private const HEXADECIMAL_DIGIT_START:String = '0x';
		static private const HEXADECIMAL_DIGIT_RADIX:uint = 16;
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
		public function StringSubParser():void{
			super(DATA_TYPE, new <String>["\"", "'", "`"]);
		}
		
		override public function parse(data:String, runner:IStringParserRunner):*{
			_data = data;
			_runner = runner;
			_result = parseJSONString(extractRawSubstring(data, runner));
			return _result;
		}
		
		static public function parse(data:String, runner:IStringParserRunner):*{
			return parseJSONString(extractRawSubstring(data, runner));
		}
		/**
		 * Determine substring length by first and last symbol. Will treat first symbol as sign of sub-string start and will search for same, not escaped, symbol as end of sub-string.   
		*/
		static public function findBackQuote(data:String, runner:IStringParserRunner):void{
			var index:uint = runner.currentIndex;
			var quote:String = data.charAt(index);
			var lastIndex:uint = index;
			var tempIndex:uint;
			while((lastIndex = data.indexOf(quote, lastIndex+1))>=0){
				tempIndex = lastIndex;
				while(data.charAt(--tempIndex)==STRING_META_CHAR){
					// nothing to do;
				}
				if((lastIndex-tempIndex)%META_SEQUENCE_LENGTH==1) break;
			}
			runner.lastIndex = lastIndex;
		}
		static public function extractRawSubstring(str:String, runner:IStringParserRunner, backQuote:String=null):String{
			var index:uint = runner.currentIndex;
			var quote:String = str.charAt(index);
			if(!backQuote) backQuote = quote;
			var lastIndex:uint = index;
			var tempIndex:uint;
			while((lastIndex = str.indexOf(backQuote, lastIndex+1))>=0){
				tempIndex = lastIndex;
				while(str.charAt(--tempIndex)==STRING_META_CHAR){
					// nothing to do;
				}
				if((lastIndex-tempIndex)%META_SEQUENCE_LENGTH==1) break;
			}
			runner.lastIndex = ++lastIndex;
			return str.substring(index, lastIndex);
		}
		static public function parseJSONString(data:String):String{
			var quote:String = data.charAt(0);
			var index:uint = 0;
			var src:String;
			var rpl:String;
			while((index = data.indexOf(STRING_META_CHAR, index+1))>=0){
				src = data.charAt(index+1);
				if(src in STRING_REPLACEMENTS) rpl = STRING_REPLACEMENTS[src];
				else if(src==UNICODE_META_CHAR){
					rpl = String.fromCharCode(parseInt(HEXADECIMAL_DIGIT_START+data.substr(index+META_SEQUENCE_LENGTH, UNICODE_CODE_LENGTH), HEXADECIMAL_DIGIT_RADIX));
					index+=UNICODE_CODE_LENGTH;
				}else if(src == quote) rpl = quote;
				else continue;
				data = data.substr(0, index)+rpl+data.substr(index+META_SEQUENCE_LENGTH);
			}
			return data.substring(1, data.length-1);
		}
	}
}