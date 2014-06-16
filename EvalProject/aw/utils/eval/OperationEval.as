package aw.utils.eval{
	import aw.emulate.Arithmetic;
	import aw.emulate.Condition;
	import aw.emulate.OperatorPriority;
	import aw.emulate.Operators;
	import aw.utils.iteration.LengthIterationIndex;
	
	/** Gets from string operation and operands, calculates the value of the operation.
	 * 
	 * 
	 * @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	 * @playerversion Flash 9.0.28.0
	 * @langversion 3.0
	*/
	public class OperationEval extends Object{

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const OPERATION_CHAR:String = '+-*/=%<>!~|&^';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const EXEC_OPERATION_CHAR:String = 'asintceof';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const PREFIX_OPERATION_CHAR:String = '+-!';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const NOT_OPERATION_CHAR:String = '!';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const PLUS_OPERATION_CHAR:String = '+';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const MINUS_OPERATION_CHAR:String = '-';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ARITHM_CHAR:String = '+-*/=%';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const BITWISE_CHAR:String = '&|<>^';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const CONDITION_CHAR:String = '&|<>=';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const ARITHM_SIMPLE_CHAR:String = '+-';

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
		* @param first 
		* @param str 
		* @param iteration 
		* @param parseValue 
		* @param scope 
		* @param operation 
		* @return * 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getNextOperation(first:*, str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object, operation:String=''):*{
			// trace('get next operation start [',str.charAt(iteration.index),']');
			// trace('first operand', first, getQualifiedClassName(first));
			if(!operation) operation = getOperator(str, iteration);
			if(!operation) return first;
			// trace('operation is ', operation);
			if(operation==Arithmetic.INCREMENT){
				// trace(' - increment');
				first = first+1;
				operation = getOperator(str, iteration);
			}else if(operation==Arithmetic.DECREMENT){
				// trace(' - decrement');
				first = first-1;
				operation = getOperator(str, iteration);
			}
			if(!operation) return first;
			// trace('start with operation', operation);
			var second:* = parseValue(str, iteration, scope);
			// trace('second operand', second, getQualifiedClassName(second));
			var nextOperation:String = getOperator(str, iteration);
			if(nextOperation){
				// trace('next operation is', nextOperation);
				if(OperatorPriority.getValue(nextOperation)>OperatorPriority.getValue(operation)){
					// trace('next have higher priority');
					second = getNextOperation(second, str, iteration, parseValue, scope, nextOperation);
					// trace('new second operand', second, getQualifiedClassName(second));
					first = executeOperation(operation, first, second);
				}else{
					// trace('current have higher priority');
					first = executeOperation(operation, first, second);
					first = getNextOperation(first, str, iteration, parseValue, scope, nextOperation);
				}
			}else first = executeOperation(operation, first, second);
			return first;
		}

		/** 
		* 
		* 
		* 
		* @public 
		* @param operation 
		* @param first 
		* @param second 
		* @return * 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function executeOperation(operation:String, first:*, second:*):*{
			var cls:Object = Operators.getType(operation);
			if(cls) first = cls.byString(operation, first, second);
			else throw new Error('EvalUtils error: Operation ['+operation+'] is not supported.');
			return first;
		}

		/** 
		* 
		* 
		* 
		* @public 
		* @param str 
		* @param iteration 
		* @param chrs 
		* @return String 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getOperator(str:String, iteration:LengthIterationIndex, chrs:String=OPERATION_CHAR):String{
			var operation:String = '';
			var i:int = iteration.index;
			var len:int = iteration.length;
			var chr:String = str.charAt(i);
			var firstSpace:Boolean = SPACES.indexOf(chr)>=0;
			while(SPACES.indexOf((chr = str.charAt(i)))>=0 && i<len) i++;
			if(OPERATION_CHAR.indexOf(chr)>=0){
				operation = chr;
				while(OPERATION_CHAR.indexOf(chr = str.charAt(++i))>=0 && i<len) operation = operation+chr;
			}else if(firstSpace && EXEC_OPERATION_CHAR.indexOf(chr)>=0){
				operation = chr;
				while(EXEC_OPERATION_CHAR.indexOf(chr = str.charAt(++i))>=0 && i<len) operation = operation+chr;
				if(SPACES.indexOf(chr)<0) operation = '';
			}
			if(operation){
				while(SPACES.indexOf((chr = str.charAt(i)))>=0 && i<len) i++;
				iteration.index = i;
			}
			return operation;
		}

		/** Метод получения операторов префиксной операции. 
		* 
		* 
		* 
		* @public 
		* @param str 
		* @param iteration 
		* @param chrs 
		* @return String 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getPrefixOperator(str:String, iteration:LengthIterationIndex, chrs:String=PREFIX_OPERATION_CHAR):String{
			var operation:String = '';
			var i:int = iteration.index;
			var len:int = iteration.length;
			var chr:String;
			while(PREFIX_OPERATION_CHAR.indexOf(chr = str.charAt(i))>=0){
				operation = operation+chr;
				i++;
			}
			if(operation) iteration.index = i;
			return operation;
		}

		/** Метод обработки префиксных операторов справа налево. 
		* 
		* 
		* 
		* @public 
		* @param value 
		* @param chrs 
		* @return * 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function executePrefixOperator(value:*, chrs:String):*{
			var i:int = chrs.length-1;
			var chr:String;
			while(i>=0){
				chr = chrs.charAt(i);
				if(chr==Condition.LOGICAL_NOT) value = !value;
				else if(chr==Arithmetic.PLUS){
					if(chrs.charAt(i-1)==chr){
						value = ++value;
						i = i-1;
					}else value = +value;
				}else if(chr==Arithmetic.MINUS){
					if(chrs.charAt(i-1)==chr){
						value = --value;
						i = i-1;
					}else value = -value;
				}
				i = i-1;
			}
			return value;
		}
	}
}