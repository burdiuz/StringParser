package aw.projects.stringparser.sub{
	import aw.projects.stringparser.StringParser;
	import aw.projects.stringparser.utils.IStringParserRunner;
	public class StringSubParser extends Object implements IStringSubParser{
		protected var _data:String;
		protected var _runner:IStringParserRunner;
		protected var _result:*;
		protected var _parser:StringParser;
		private var _dataType:String;
		private var _initChars:Vector.<String>;
		public function StringSubParser(dataType:String, initChars:Vector.<String>):void{
			super();
			_dataType = dataType;
			_initChars = initChars.slice();
		}
		
		public function get dataType():String{
			return _dataType;
		}
		
		public function get initChars():Vector.<String>{
			return _initChars.slice();
		}
		
		public function initialize(parser:StringParser):void{
			_parser = parser;
		}
		
		public function parse(data:String, runner:IStringParserRunner):*{
			throw new Error("Abstract class cannot be used as sub-parser.");
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
		
		public function clear():void{
			_data = null;
			_runner = null;
			_result = null;
		}
	}
}