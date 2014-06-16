package aw.utils{
	import aw.utils.eval.ArrayEval;
	import aw.utils.eval.ExecutableEval;
	import aw.utils.eval.NumberEval;
	import aw.utils.eval.ObjectEval;
	import aw.utils.eval.OperationEval;
	import aw.utils.eval.RegExpEval;
	import aw.utils.eval.StringEval;
	import aw.utils.eval.XMLEval;
	import aw.utils.iteration.LengthIterationIndex;
	public class EvalUtils extends Object{
		static private var SPACES:String = StringEval.SPACES;
		static private const EXPRESSION_SEPARATOR:String = ',;';
		static public function evaluate(str:String, scope:Object=null, iteration:LengthIterationIndex=null):*{
			if(!iteration) iteration = new LengthIterationIndex(str.length);
			var val:*;
			var i:int = iteration.index;
			var len:int = iteration.length;
			while(i<len){
				var chr:String = str.charAt(i);
				if(SPACES.indexOf(chr)<0 && EXPRESSION_SEPARATOR.indexOf(chr)<0){
					iteration.index = i;
					val = parseValue(str, iteration, scope);
					i = iteration.index;
				}
				i++;
			}
			iteration.index = i;
			return val;
		}
		static public function parseValue(str:String, iteration:LengthIterationIndex, scope:Object=null):*{
			var chr:String;
			var i:int = iteration.index;
			var len:int = iteration.length;
			while(SPACES.indexOf((chr = str.charAt(i)))>=0 && i<len) i++;
			var ret:*;
			var pref:String = OperationEval.getPrefixOperator(str, iteration);
			if(i<len){
				// trace('----------------- PARSE VALUE CONTROL CHAR', chr);
				if(StringEval.STRING_STOP.indexOf(chr)>=0) ret = StringEval.getData(str, iteration);
				else if(NumberEval.NUMBER_CHAR.indexOf(chr)>=0) ret = NumberEval.getData(str, iteration);
				else if(chr==XMLEval.XML_OPEN) ret = XMLEval.getData(str, iteration);
				else if(chr==ArrayEval.ARRAY_OPEN) ret = ArrayEval.getData(str, iteration, parseValue, scope);
				else if(chr==ObjectEval.OBJECT_OPEN) ret = ObjectEval.getData(str, iteration, parseValue, scope);
				else if(chr==RegExpEval.REGEXP_OPEN) ret = RegExpEval.getData(str, iteration);
				else if(chr==ExecutableEval.GROUP_OPEN) ret = ExecutableEval.parseGroup(str, iteration, parseValue, scope);
				else{
					ret = ExecutableEval.lookToExecutableData(str, iteration, parseValue, scope);
				}
				chr = str.charAt(iteration.index);
				if(chr==ExecutableEval.DOT_CHAR){
					ret = ExecutableEval.getDottedSequence(str, iteration, parseValue, scope, ret);
				}
				if(pref) ret = OperationEval.executePrefixOperator(ret, pref);
				if(iteration.index<len) ret = OperationEval.getNextOperation(ret, str, iteration, parseValue, scope);
			}
			return ret;
		}
		static public function skipWhitespace(str:String, iteration:LengthIterationIndex):void{
			var index:int = iteration.index;
			var length:int = iteration.length;
			while(SPACES.indexOf(str.charAt(index))>=0 && index<length) index++;
			iteration.index = index;
		}
	}
}