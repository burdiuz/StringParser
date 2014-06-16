package aw.projects.stringparser.customs.as3native{
	import aw.projects.stringparser.customs.json.StringSubParser;
	import aw.projects.stringparser.sub.StringSubParser;
	import aw.projects.stringparser.utils.IStringParserRunner;
	import aw.projects.stringparser.utils.StringParserMarker;
	
	/**
	 * 
	 * 
	 * 
<listing>
import aw.projects.stringparser.customs.as3native.XMLSubParser;
import aw.projects.stringparser.utils.StringParserRunner;

var str:String;
str = "start:<node attr='1' second='scnd'/>no XML here!";
trace(XMLSubParser.parse(str, new StringParserRunner(6)).toXMLString());
<node attr="1" second="scnd"/>

str =  "start:<node attr='1' second='scnd'><second><third/></second><node>text</node><second><node/><![CDATA[third>>><><><></node>]]></second><another><node/><?instruction value=\"TEST\" ?></another><!-- comment --></node>no XML here!";
trace(XMLSubParser.parse(str, new StringParserRunner(6)).toXMLString());
<node attr="1" second="scnd">
  <second>
    <third/>
  </second>
  <node>text</node>
  <second>
    <node/>
    <![CDATA[third>>><><><></node>]]>
  </second>
  <another>
    <node/>
  </another>
</node>
</listing>
	 */
	public class XMLSubParser extends aw.projects.stringparser.sub.StringSubParser{
		static public const DATA_TYPE:String = "xml";
		static private const XML_OPEN:String = '<';
		static private const XML_CLOSE:String = '>';
		static private const XML_CLOSE_TAG_CHAR:String = '/';
		static private const XML_CDATA_OPEN:String = '<![CDATA[';
		static private const XML_CDATA_CLOSE:String = ']]>';
		static private var SPACES:String = aw.projects.stringparser.customs.json.StringSubParser.SPACES;
		public function XMLSubParser():void{
			super(DATA_TYPE, new <String>["<"]);
		}
		
		override public function parse(data:String, runner:IStringParserRunner):*{
			_data = data;
			_runner = runner;
			_result = XMLSubParser.parse(data, runner);
			return _result;
		}
		
		static public function parse(data:String, runner:IStringParserRunner):*{
			var startIndex:int = runner.currentIndex;
			//trace(' -------------- XML started', data.substr(startIndex));
			var tagName:String = getXMLTagName(data, runner);
			if(!tagName) return StringParserMarker.INCOMPATIBLE_PARSER;
			else if(data.indexOf(XML_CDATA_OPEN, startIndex)==startIndex){
				runner.lastIndex = data.indexOf(XML_CDATA_CLOSE, startIndex)+XML_CDATA_CLOSE.length;
			}else if(!isClosedXMLTag(data, runner)){
				var tagNameLength:int = tagName.length;
				var index:int = startIndex + tagNameLength;
				var tagCount:int = 1;
				while(true){
					var tagIndex:int = data.indexOf(tagName, index);
					var cdataIndex:int = data.indexOf(XML_CDATA_OPEN, index);
					if(tagIndex<0) break;
					if(cdataIndex>0 && cdataIndex<tagIndex){
						index = data.indexOf(XML_CDATA_CLOSE, cdataIndex);
					}else{
						var char:String = data.charAt(tagIndex-1);
						if(char==XML_CLOSE_TAG_CHAR && data.charAt(tagIndex-2)==XML_OPEN){
							index = data.indexOf(XML_CLOSE, tagIndex);
							if(!--tagCount) break;
						}else{
							if(char==XML_OPEN) tagCount++;
							index = tagIndex+tagNameLength;
						}
					}
				}
				runner.lastIndex = index+1;
			}
			//trace(' ------------------------- XML done', startIndex, runner.lastIndex, data.substring(startIndex, runner.lastIndex));
			return XML(data.substring(startIndex, runner.lastIndex));
		}
		
		static public function getXMLTagName(data:String, runner:IStringParserRunner):String{
			var startIndex:int = runner.currentIndex+1;
			var index:int = startIndex;
			var char:String = data.charAt(index);
			while(SPACES.indexOf(char)<0 && char!=XML_CLOSE && char!=XML_CLOSE_TAG_CHAR) char = data.charAt(++index);
			runner.lastIndex = index;
			return data.substring(startIndex, index);
		}
		
		static public function isClosedXMLTag(data:String, runner:IStringParserRunner):Boolean{
			var startIndex:int = runner.currentIndex;
			var closeTagIndex:int = data.indexOf(XML_CLOSE_TAG_CHAR+XML_CLOSE, startIndex);
			var endTagIndex:int = data.indexOf(XML_CLOSE, startIndex);
			runner.lastIndex = endTagIndex+1;
			return (closeTagIndex>=0 && closeTagIndex<endTagIndex) ? true : false;
		}
	}
}