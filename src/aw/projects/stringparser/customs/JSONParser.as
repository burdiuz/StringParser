package aw.projects.stringparser.customs{
	import aw.projects.stringparser.StringParser;
	import aw.projects.stringparser.customs.json.ArraySubParser;
	import aw.projects.stringparser.customs.json.NumberSubParser;
	import aw.projects.stringparser.customs.json.ObjectSubParser;
	import aw.projects.stringparser.customs.json.PredefinedSubParser;
	import aw.projects.stringparser.customs.json.StringSubParser;
	import aw.projects.stringparser.utils.StringParserMarker;
	import aw.projects.stringparser.utils.StringParserRunner;

	public class JSONParser extends Object{
		private var _parser:StringParser;
		public function JSONParser():void{
			super();
			install();
		}
		private function install():void{
			_parser = new StringParser();
			_parser.registerParser(new ArraySubParser());
			_parser.registerParser(new ObjectSubParser());
			_parser.registerParser(new NumberSubParser());
			_parser.registerParser(new StringSubParser());
			_parser.registerParser(PredefinedSubParser.createJSONParser());
		}
		public function parse(data:String):*{
			var result:* = _parser.parse(data, new StringParserRunner(0));
			return StringParserMarker.isMarker(result) ? null : result;
		} 
	}
}