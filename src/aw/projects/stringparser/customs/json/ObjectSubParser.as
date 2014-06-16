package aw.projects.stringparser.customs.json
{
	import aw.projects.stringparser.sub.StringSubParser;
	import aw.projects.stringparser.utils.IStringParserRunner;
	
	public class ObjectSubParser extends aw.projects.stringparser.sub.StringSubParser{
		static public const DATA_TYPE:String = "object";
		public function ObjectSubParser():void{
			super(DATA_TYPE, new <String>["{"]);
		}
		
		override public function parse(data:String, runner:IStringParserRunner):*{
			return null;
		}
	}
}