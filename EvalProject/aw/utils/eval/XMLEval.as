package aw.utils.eval{
	import aw.errors.EvalUtilsError;
	import aw.utils.EvalUtils;
	import aw.utils.iteration.LengthIterationIndex;
	
	/** Converts a string to an XML object.
	 * 
	 * 
	 * @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	 * @playerversion Flash 9.0.28.0
	 * @langversion 3.0
	*/
	public class XMLEval extends Object{

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const XML_OPEN:String = '<';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const XML_CLOSE:String = '>';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const XML_CLOSE_TAG_CHAR:String = '/';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const XML_CDATA_OPEN:String = '<![CDATA[';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const XML_CDATA_CLOSE:String = ']]>';

		/** 
		* 
		* 
		* 
		* @private 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private var SPACES:String = StringEval.SPACES;

		/** 
		* 
		* 
		* 
		* @public 
		* @param str 
		* @param iteration 
		* @return XML 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function evaluate(str:String, iteration:LengthIterationIndex=null):XML{
			if(!iteration) iteration = new LengthIterationIndex(str.length);
			return getData(str, iteration);
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @return XML 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getData(str:String, iteration:LengthIterationIndex):XML{
			var start:int = iteration.index;
			var i:int;
			// trace(' -------------- XML started', str.substr(start));
			var tagName:String = getXMLTagName(str, iteration);
			if(!tagName) throw new EvalUtilsError(EvalUtilsError.XML_ROOT_NODE_WITHOUT_NAME);
			else if(str.indexOf(XML_CDATA_OPEN, start)==start){
				iteration.index = str.indexOf(XML_CDATA_CLOSE, start)+XML_CDATA_CLOSE.length;
			}else if(!isClosedXMLTag(str, iteration)){
				var tagNameLength:int = tagName.length;
				i = iteration.index;
				var tagI:int;
				var cdtI:int;
				var tagCount:int = 1;
				var chr:String;
				while(true){
					tagI = str.indexOf(tagName, i);
					cdtI = str.indexOf(XML_CDATA_OPEN, i);
					if(tagI<0) break;
					if(cdtI>0 && cdtI<tagI){
						i = str.indexOf(XML_CDATA_CLOSE, cdtI);
					}else{
						chr = str.charAt(tagI-1);
						if(chr==XML_CLOSE_TAG_CHAR && str.charAt(tagI-2)==XML_OPEN){
							tagCount--;
							if(!tagCount){
								i = str.indexOf(XML_CLOSE, tagI);
								break;
							}
						}else{
							if(chr==XML_OPEN) tagCount++;
							i = tagI+tagNameLength;
						}
					}
				}
				iteration.index = ++i;
			}
			// trace(' ------------------------- XML done', start, i, str.substring(start, iteration.index));
			return XML(str.substring(start, iteration.index));
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @return String 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getXMLTagName(str:String, iteration:LengthIterationIndex):String{
			var start:int = iteration.index+1;
			var i:int = start;
			var chr:String = str.charAt(i);
			while(SPACES.indexOf(chr)<0 && chr!=XML_CLOSE && chr!=XML_CLOSE_TAG_CHAR) chr = str.charAt(++i);
			iteration.index = i;
			return str.substring(start, i+1);
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @return Boolean 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function isClosedXMLTag(str:String, iteration:LengthIterationIndex):Boolean{
			var start:int = iteration.index;
			var cls:int = str.indexOf(XML_CLOSE_TAG_CHAR+XML_CLOSE, start);
			var ncls:int = str.indexOf(XML_CLOSE, start);
			iteration.index = ncls+1;
			return (cls>=0 && cls<ncls) ? true : false;
		}
	}
}