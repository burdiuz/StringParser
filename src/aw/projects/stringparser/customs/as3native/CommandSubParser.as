package aw.projects.stringparser.customs.as3native{
	import aw.projects.stringparser.sub.StringSubParser;
	import aw.projects.stringparser.utils.IStringParserRunner;

	public class CommandSubParser extends StringSubParser{
		static public const DATA_TYPE:String = "command";
		public function CommandSubParser():void{
			super(DATA_TYPE, new <String>[]);
		}
		
		override public function parse(data:String, runner:IStringParserRunner):*{
			return null;
		}
	}
}