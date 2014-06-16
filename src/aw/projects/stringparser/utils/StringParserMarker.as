package aw.projects.stringparser.utils{
	public class StringParserMarker extends Object{
		static private const TARGET:Object = {};
		/**
		 * If returned by sub-parser means to try next available sub-parser
		 */
		static public const INCOMPATIBLE_PARSER:StringParserMarker = new StringParserMarker("incompatibleParser", TARGET);
		/**
		 * If returned by sub-parser means that sub-parser was not able to parse properly internals of the string but was able to determine its approximate size. Parsing may continue, but data may be corrupted.
		 */
		static public const PARSE_ERROR:StringParserMarker = new StringParserMarker("parseError", TARGET);
		/**
		 * If returned by sub-parser means that sub-parser was not able to parse properly and failed to determine sub-string size, so this is end of parsing.
		 */
		static public const FATAL_ERROR:StringParserMarker = new StringParserMarker("fatalError", TARGET);
		
		private var _value:String;
		public function StringParserMarker(value:String, target:Object):void{
			super();
			_value = value;
			if(target!==TARGET){
				throw new Error("Custom StringParserMarker's are not supported.");
			}
		}
		
		public function get value():String{
			return _value;
		}
		
		public function toString():String{
			return "[StringParserMarker(\""+_value+"\")]";
		}
		
		static public function isMarker(marker:StringParserMarker):Boolean{
			switch(marker){
				case INCOMPATIBLE_PARSER:
				case PARSE_ERROR:
				case FATAL_ERROR:
					return true;
					break;
			}
			return false;
		}
	}
}