package aw.projects.stringparser.utils{
	public class StringParserRunner extends Object implements IStringParserRunner{
		private var _startIndex:uint;
		private var _index:uint;
		private var _length:uint;
		private var _lastIndex:uint;
		public function StringParserRunner(startIndex:uint, length:uint=0, index:uint=0):void{
			super();
			_startIndex = startIndex;
			_length = length;
			_index = index;
		}
		
		public function reset(startIndex:uint, length:uint=0, index:uint=0):void{
			_startIndex = startIndex;
			_length = length;
			_index = index;
		}
		
		/**
		 * Index where entire parsing stuff started. 
		 */
		public function get startIndex():uint{
			return _startIndex;
		}
		
		public function set startIndex(value:uint):void{
			_startIndex = value;
		}
		
		/**
		 * Current starting position for sub-parser, where it should start.
		 */
		public function get index():uint{
			return _index;
		}
		
		public function set index(value:uint):void{
			_index = value;
		}
		
		/**
		 * Length of sub-string that was parsed by Sub-parser. 
		 */
		public function get length():uint{
			return _length;
		}
		
		public function set length(value:uint):void{
			_length = value;
		}
		
		/**
		 * Current index of sub-parser in terms of whole string. startIndex+index
		 */
		public function get currentIndex():uint{
			return _startIndex+_index;
		}
		
		public function set currentIndex(value:uint):void{
			_index = value-_startIndex;
		}
		
		/**
		 * Next index that goes after position of last symbol parsed by sub-parser. If its value equal to length of data string, this means parsing if finished. startIndex+length
		 */
		public function get lastIndex():uint{
			return _startIndex+_length;
		}
		
		public function set lastIndex(value:uint):void{
			_length = value-_startIndex;
		}
		
		public function clone():IStringParserRunner{
			return new StringParserRunner(_startIndex, _length, _index);
		}
	}
}