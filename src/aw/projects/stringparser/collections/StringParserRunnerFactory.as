package aw.projects.stringparser.collections{
	import aw.projects.stringparser.utils.IStringParserRunner;

	public class StringParserRunnerFactory extends Object{
		private var _runners:Vector.<IStringParserRunner>;
		private var _runnerDefinition:Class;
		public function StringParserRunnerFactory(runnerDefinition:Class):void{
			super();
			_runnerDefinition = runnerDefinition;
			clear();
		}
		public function create(startIndex:uint, length:uint, index:uint=0):IStringParserRunner{
			var runner:IStringParserRunner;
			if(_runners.length){
				runner = _runners.pop();
				runner.reset(startIndex, length, index);
			}else{
				runner = new _runnerDefinition(startIndex, length, index);
			}
			return  runner;
		}
		public function release(runner:IStringParserRunner):void{
			_runners.push(runner);
		}
		public function clear():void{
			_runners = new Vector.<IStringParserRunner>();
		}
	}
}