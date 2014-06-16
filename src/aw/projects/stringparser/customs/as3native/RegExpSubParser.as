package aw.projects.stringparser.customs.as3native{
	import aw.projects.stringparser.sub.StringSubParser;
	import aw.projects.stringparser.utils.IStringParserRunner;
	
	public class RegExpSubParser extends StringSubParser{
		static public const DATA_TYPE:String = "regexp";
		public function RegExpSubParser():void{
			super(dataType, initChars);
		}
		
		override public function parse(data:String, runner:IStringParserRunner):*{
			return null;
		}
	}
}