package aw.projects.stringparser.sub{
	import aw.projects.stringparser.IStringParser;
	import aw.projects.stringparser.StringParser;

	public interface IStringSubParser extends IStringParser{
		/**
		 * Resulting data type
		 */
		function get dataType():String;
		/**
		 * Chars that may identify sub-string to be parsed with exactly this sub-parser
		 */
		function get initChars():Vector.<String>;
		/**
		 * Initialize and bind Sub-Parser with StringParser instance.
		 */
		function initialize(parser:StringParser):void;
		/**
		 * Remove all past results and other temporary data.
		 */
		function clear():void;
	}
}