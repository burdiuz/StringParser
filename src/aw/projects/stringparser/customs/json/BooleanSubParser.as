package aw.projects.stringparser.customs.json{
	import aw.projects.stringparser.sub.StringSubParser;
	import aw.projects.stringparser.utils.IStringParserRunner;
	import aw.projects.stringparser.utils.StringParserMarker;

	/**
	 * 
	 * 
	 * 
<listing>
import aw.projects.stringparser.customs.json.BooleanSubParser;
import aw.projects.stringparser.utils.StringParserRunner;

var str:String = "some falsething truesome, false true, FALSE!";
trace(str.substr(5, 7), BooleanSubParser.parse(str, new StringParserRunner(5))); // falseth [StringParserMarker("incompatibleParser")]
trace(str.substr(16, 7), BooleanSubParser.parse(str, new StringParserRunner(16))); // truesom [StringParserMarker("incompatibleParser")]
trace(str.substr(26, 7), BooleanSubParser.parse(str, new StringParserRunner(26))); // false t false
trace(str.substr(32, 7), BooleanSubParser.parse(str, new StringParserRunner(32))); // true, F true
trace(str.substr(38, 7), BooleanSubParser.parse(str, new StringParserRunner(38))); // FALSE! [StringParserMarker("incompatibleParser")]
</listing>
	 */
	public class BooleanSubParser extends aw.projects.stringparser.sub.StringSubParser{
		static public const DATA_TYPE:String = " boolean";
		static public const TRUE_STRING:String = "true";
		static public const FALSE_STRING:String = "false";
		public function BooleanSubParser():void{
			super(DATA_TYPE, new <String>["t", "f"]);
		}
		
		override public function parse(data:String, runner:IStringParserRunner):*{
			_data = data;
			_runner = runner;
			_result = BooleanSubParser.parse(data, runner);
			return _result;
		}
		
		static public function parse(data:String, runner:IStringParserRunner):*{
			var index:uint = runner.currentIndex;
			var result:* = StringParserMarker.INCOMPATIBLE_PARSER;
			switch(data.charAt(index)){
				case "t":
					if(data.substr(index, 4)==TRUE_STRING && data.charAt(index+4).search(/[\w\d$_]/i)<0){
						runner.length = 4;
						result = true;
					}
					break;
				case "f":
					if(data.substr(index, 5)==FALSE_STRING && data.charAt(index+5).search(/[\w\d$_]/i)<0){
						runner.length = 5;
						result = false;
					}
					break;
			}
			
			return result;
		}
	}
}