package aw.projects.stringparser.customs.json{
	import aw.projects.stringparser.StringParser;
	import aw.projects.stringparser.sub.StringSubParser;
	import aw.projects.stringparser.utils.IStringParserRunner;
	import aw.projects.stringparser.utils.StringParserMarker;
	
	/**
	 * 
	 * 
<listing>
import aw.projects.stringparser.customs.json.PredefinedSubParser;
import aw.projects.stringparser.utils.StringParserRunner;

var parser:PredefinedSubParser = PredefinedSubParser.createAS3Parser();
var string:String = "+-Infinity grg true; r null wNaN3g";
trace(parser.parse(string, new StringParserRunner(1))); // -Infinity
trace(parser.parse(string, new StringParserRunner(10))); // incompatibleParser
trace(parser.parse(string, new StringParserRunner(11))); // incompatibleParser
trace(parser.parse(string, new StringParserRunner(15))); // true
trace(parser.parse(string, new StringParserRunner(23))); // null
trace(parser.parse(string, new StringParserRunner(29))); // incompatibleParser
</listing>
	 */
	public class PredefinedSubParser extends aw.projects.stringparser.sub.StringSubParser{
		static public const DATA_TYPE:String = "keyword";
		private var _values:Object = {};
		private var _cache:Object = {};
		private var _valuesWereChanged:Boolean;
		private var _initChars:Vector.<String> = new Vector.<String>();
		private var _initialized:Boolean;
		public function PredefinedSubParser(namedValues:Object=null):void{
			super(DATA_TYPE, _initChars);
			setValues(namedValues);
		}
		override public function initialize(parser:StringParser):void{
			super.initialize(parser);
			resetInitChars();
			_initialized = true;
		}
		override public function get initChars():Vector.<String>{
			if(_valuesWereChanged){
				resetInitChars();
			}
			return super.initChars;
		}
		
		override public function parse(data:String, runner:IStringParserRunner):*{
			if(_valuesWereChanged){
				resetInitChars();
			}
			_data = data;
			_runner = runner;
			_result = null;
			var index:int = runner.currentIndex;
			var char:String = data.charAt(index);
			if(char in _cache){
				var hash:Object = _cache[char];
				for(var name:String in hash){
					var length:int = name.length;
					var nextIndex:int = index+length;
					if(data.substr(index, length)===name && (data.length<=nextIndex || data.charAt(nextIndex).search(/[\w\d$_]/i)<0)){
						runner.length = length;
						_result = hash[name];
						return _result;
					}
				}
			}
			return StringParserMarker.INCOMPATIBLE_PARSER;
		}
		
		public function setValue(name:String, value:*):void{
			if(_initialized) throw new Error("Values cannot be changed after object is initialized.");
			if(!name){
				throw new Error("Name cannot be empty.");
			}
			if(name in _values){
				throw new Error("Name \""+name+"\" already set for \""+_values[name]+"\" value. Use \"removeValue\" method to reset name/value pair.");
			}
			_values[name] = value;
			_valuesWereChanged = true;
		}
		
		public function hasValue(name:String):Boolean{
			return name in _values;
		}
		
		public function getValue(name:String):*{
			return _values[name];
		}
		
		public function setValues(namedValues:Object):void{
			if(namedValues){
				for(var name:String in namedValues){
					setValue(name, namedValues[name]);
				}
			}
		}
		
		public function removeValue(name:String):void{
			if(_initialized) throw new Error("Values cannot be changed after object is initialized.");
			if(name in _values){
				delete _values[name];
				_valuesWereChanged = true;
			}
		}
		
		private function resetInitChars():void{
			const hash:Object = {};
			_cache = {};
			_initChars.splice(0, _initChars.length);
			for(var name:String in _values){
				var char:String = name.charAt(0);
				if(char in hash){
					_cache[char][name] = _values[name];
					continue;
				}else{
					_cache[char] = {};
					_cache[char][name] = _values[name];
				}
				_initChars.push(char);
				hash[name] = true;
			}
			_valuesWereChanged = false;
		}
		
		static public function createJSONParser():PredefinedSubParser{
			const parser:PredefinedSubParser = new PredefinedSubParser();
			var values:Object = parser._values;
			values['null'] = null;
			values['true'] = true;
			values['false'] = false;
			values['undefined'] = undefined;
			values['Infinity'] = Infinity;
			values['+Infinity'] = +Infinity;
			values['-Infinity'] = -Infinity;
			values['NaN'] = NaN;
			parser._valuesWereChanged = true;
			return parser;
		}
		
		static public function createAS3Parser():PredefinedSubParser{
			const parser:PredefinedSubParser = createJSONParser();
			var values:Object = parser._values;
			values['AS3'] = AS3;
			parser._valuesWereChanged = true;
			return parser;
		}
	}
}