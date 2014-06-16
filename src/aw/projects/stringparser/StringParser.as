package aw.projects.stringparser{
	import aw.projects.stringparser.collections.StringParserRunnerFactory;
	import aw.projects.stringparser.sub.IStringSubParser;
	import aw.projects.stringparser.utils.IStringParserRunner;

	public class StringParser extends Object implements IStringParser{
		private var _runnersFactory:StringParserRunnerFactory;
		private var _parsers:
		private var _data:String;
		private var _runner:IStringParserRunner;
		private var _result:String;
		public function StringParser():void{
			super();
		}
		
		public function parse(data:String, runner:IStringParserRunner):*{
			return null;
		}
		
		public function get lastData():String{
			return _data;
		}
		
		public function get lastRunner():*
		{
			return _runner;
		}
		
		public function get lastResult():*{
			return _result;
		}
		
		public function registerParser(parser:IStringSubParser):void{
			
		}
		
		public function removeParser(parser:IStringSubParser):void{
			
		}
		
		public function getParsersByDataType(dataType:String):Vector.<IStringSubParser>{
			return null;
		}
	}
}