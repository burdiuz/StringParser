package aw.projects.stringparser{
	import aw.projects.stringparser.utils.IStringParserRunner;

	public interface IStringParser{
		/**
		 * Parse data and save last result with runner.
		 */
		function parse(data:String, runner:IStringParserRunner):*;
		/**
		 * Data that was parsed in last parse() session.
		 */
		function get lastData():String;
		/**
		 * Runner that was used in last parse() session.
		 */
		function get lastRunner():*;
		/**
		 * Result that was generated in last parse() session.
		 */
		function get lastResult():*;
	}
}