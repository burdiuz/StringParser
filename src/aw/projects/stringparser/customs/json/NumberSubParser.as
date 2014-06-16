package aw.projects.stringparser.customs.json{
	import aw.projects.stringparser.sub.StringSubParser;
	import aw.projects.stringparser.utils.IStringParserRunner;
	
	/**
	 * 
	 * 
	 * 
<listing>
import aw.projects.stringparser.customs.json.NumberSubParser;
import aw.projects.stringparser.utils.StringParserRunner;

var str:String = "358fab 20e+4E-2, 0x00FFxCC00, .125, 0.25.86";
trace(str.substr(0, 7), NumberSubParser.parse(str, new StringParserRunner(0))); // 358fab  358
trace(str.substr(7, 7), NumberSubParser.parse(str, new StringParserRunner(7))); // 20e+4E- 200000
trace(str.substr(17, 7), NumberSubParser.parse(str, new StringParserRunner(17))); // 0x00FFx 255
trace(str.substr(30, 7), NumberSubParser.parse(str, new StringParserRunner(30))); // .125, 0 0.125
trace(str.substr(36, 7), NumberSubParser.parse(str, new StringParserRunner(36))); // 0.25.86 0.25
</listing>
	 */
	public class NumberSubParser extends aw.projects.stringparser.sub.StringSubParser{
		static public const DATA_TYPE:String = "number";
		static private const NUMBER_CHARS:String = '.0123456789e+-';
		static private const NUMBER_FULL_CHARS:String = '.0123456789xABCDEFabcdef';
		static private const HEX_CHARS:String = '0123456789ABCDEFabcdef';
		static private const HEX_CHAR:String = 'x';
		static private const DOT_CHAR:String = '.';
		static private const EXPONENT_CODE_CHARS:String = 'eE';
		static private const EXPONENT_SIGN_CHARS:String = '+-';
		static private const EXPONENT_CHARS:String = 'eE+-';
		public function NumberSubParser():void{
			super(DATA_TYPE, new <String>[".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]);
		}
		
		override public function parse(data:String, runner:IStringParserRunner):*{
			_data = data;
			_runner = runner;
			_result = NumberSubParser.parse(data, runner);
			return _result;
		}
		static public function parse(data:String, runner:IStringParserRunner):Number{
			var startIndex:int = runner.currentIndex;
			var length:int = data.length;
			var endIndex:int;
			var char:String;
			var isNumber:Boolean;
			if(data.charAt(startIndex)=="0" && data.charAt(startIndex+1)==HEX_CHAR){ // Hex
				endIndex = startIndex+2;
				while(Boolean(isNumber = (HEX_CHARS.indexOf(char = data.charAt(endIndex))>=0)) && endIndex<length){
					endIndex++;
				}
				if(isNumber) endIndex++;
				
			}else{ // Normal number
				endIndex = startIndex;
				var controlSignPassed:Boolean;
				while(Boolean(isNumber = (NUMBER_CHARS.indexOf(char = data.charAt(endIndex))>=0)) && endIndex<length){
					if(char==DOT_CHAR){
						if(controlSignPassed){
							isNumber = false;
							break;
						}else controlSignPassed = true;
					}else if(EXPONENT_CHARS.indexOf(char)>=0){
						if(!controlSignPassed && EXPONENT_CODE_CHARS.indexOf(char)>=0 && EXPONENT_SIGN_CHARS.indexOf(data.charAt(endIndex+1))>=0){
							endIndex++;
							controlSignPassed = true;
						}else{
							isNumber = false;
							break;
						}
					}
					endIndex++;
				}
				if(isNumber) endIndex++;
				
			}
			runner.lastIndex = endIndex;
			return Number(data.substring(startIndex, endIndex));
		}
	}
}