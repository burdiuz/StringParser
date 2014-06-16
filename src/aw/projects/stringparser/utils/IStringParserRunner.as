package aw.projects.stringparser.utils{
	public interface IStringParserRunner{
		function reset(startIndex:uint, length:uint=0, index:uint=0):void;
		function get startIndex():uint;
		function get index():uint;
		function set index(value:uint):void;
		function get length():uint;
		function set length(value:uint):void;
		function get currentIndex():uint;
		function set currentIndex(value:uint):void;
		function get lastIndex():uint;
		function set lastIndex(value:uint):void;
		function clone():IStringParserRunner;
	}
}