package aw.utils.eval{
	import aw.emulate.Arithmetic;
	import aw.errors.EvalUtilsError;
	import aw.utils.ClassUtils;
	import aw.utils.iteration.LengthIterationIndex;
	
	import flash.system.ApplicationDomain;
	
	/** Converts a string in a point notation query. You can call methods and access properties, supports E4X syntax (without filters). 
	 * 
	 * 
	 * @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	 * @playerversion Flash 9.0.28.0
	 * @langversion 3.0
	*/
	public class ExecutableEval extends Object{

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const PARAM_NAME_SPACERS:String = '.([';
		
		/**
		 * 
		 * 
		 * 
		 * @private (constant) 
		 * @langversion ActionScript 3.0 
		 * @playerversion Flash 9.0.28.0 
		 */
		static public const GROUP_OPEN:String = '(';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const FUNCTION_CALL_OPEN:String = '(';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const FUNCTION_CALL_CLOSE:String = ')';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const DYNAMIC_NAME_OPEN:String = '[';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const DYNAMIC_NAME_CLOSE:String = ']';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const ANY_SIGN:String = '*';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const THIS_LINK_NAME:String = 'this';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const NAMESPACE_SEPARATOR_PART:String = ':';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const NAMESPACE_SEPARATOR:String = '::';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const PARAMETER_SEPARATOR:String = '.';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const ATTRIBUTE_SEPARATOR:String = '@';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public const DOT_CHAR:String = '.';

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const RESTRICTED_NAME_CHARS:String = '~!#$%^&*()+|-=\\[];\'`<>?,./:"{}№ \t';
		
		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const RESTRICTED_NAME_CHARS_OBJECT:Object = function():Object{
			var obj:Object = {};
			var len:int = RESTRICTED_NAME_CHARS.length;
			for(var i:int=0; i<len; i++) obj[RESTRICTED_NAME_CHARS.charAt(i)] = true;
			return obj;
		}();
		
		/** 
		 * 
		 * 
		 * 
		 * @private (constant) 
		 * @langversion ActionScript 3.0 
		 * @playerversion Flash 10.0.0
		 */
		static private const VECTOR_TYPE_CONTAINER:String = '.<';
		static private const VECTOR_TYPE_OPEN:String = '<';
		static private const VECTOR_TYPE_CLOSE:String = '>';

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
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;

		/** 
		* 
		* 
		* 
		* @private (constant) 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static private const EXECUTABLE_OPERATORS:Object = function():Object{
			var obj:Object = {};
			obj['new'] = createNewInstace;
			return obj;
		}();

		/** 
		* 
		* 
		* 
		* @public 
		* @param str 
		* @param iteration 
		* @param parseValue 
		* @param scope 
		* @return Object 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function lookToExecutableData(str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object=null):Object{
			var i:int = iteration.index;
			for(var p:String in EXECUTABLE_OPERATORS){
				var plen:int = p.length;
				if(str.substr(i, plen)==p && SPACES.indexOf(str.charAt(i+plen))>=0){
					i+=plen;
					var length:int = iteration.length;
					while(i<length && SPACES.indexOf(str.charAt(i))>=0) i++;
					iteration.index = i;
					return EXECUTABLE_OPERATORS[p](str, iteration, parseValue, scope);
				}
			}
			return getData(str, iteration, parseValue, scope);
		}
		

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @param parseValue 
		* @param scope 
		* @return Object 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function createNewInstace(str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object=null):Object{
			var definition:Object =  getData(str, iteration, parseValue, scope, false);// Object, because in AS you can instantiate Class and Function objects.
			//trace(' -- new instance', definition);
			var i:int = iteration.index;
			var len:int = iteration.length;
			while(SPACES.indexOf(str.charAt(i))>=0 && i<len) i++;
			iteration.index = i;
			var object:Object;
			if(str.charAt(i)==FUNCTION_CALL_OPEN){
				var arguments:Array = ArrayEval.getData(str, iteration, parseValue, scope, FUNCTION_CALL_CLOSE);
				object = ClassUtils.apply(definition, arguments);
			}else{
				object = ClassUtils.apply(definition);
			}
			return object;
		}
		
		/**
		 * 
		 * @param str
		 * @param iteration
		 * @param parseValue
		 * @param scope
		 * @return 
		 * 
		 */
		static public function parseGroup(str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object=null):Object{
			iteration.index++;
			var target:Object = parseValue(str, iteration, scope);
			iteration.index += 1;
			var chr:String = str.charAt(iteration.index);
			if(chr==DOT_CHAR || chr==FUNCTION_CALL_OPEN){
				target = getDottedSequence(str, iteration, parseValue, scope, target);
			}
			return target;
		}

		/** 
		* 
		* 
		* 
		* @public 
		* @param str 
		* @param iteration 
		* @param parseValue 
		* @param scope 
		* @param callFunction 
		* @return Object 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getData(str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object=null, callFunction:Boolean=true):Object{
			var i:int = iteration.index;
			var len:int = iteration.length;
			var chr:String = str.charAt(i);
			var isAttribute:Boolean = false;
			var currentScope:Object;
			// trace('------------------------ START PARSE EXECUTABLE');
			if(chr==ATTRIBUTE_SEPARATOR){
				// trace('first is attribute');
				isAttribute = true;
				iteration.index = ++i;
			}
			var name:QName = getQName(str, iteration, parseValue, scope);
			var operators:String = getAssignOperator(str, iteration);
			if(operators){
				// trace('assign operator found:', operators);
				return applyValue(str, iteration, parseValue, operators, scope, name, isAttribute, scope);
			}
			// trace('first name:', name);
			if(name.localName==THIS_LINK_NAME){
				// trace(' - force current scope');
				currentScope = scope;
			}else if(scope && name in scope){
				// trace(' - current scope');
				currentScope = isAttribute ? scope.@[name] : scope[name];
			}else{
				// trace(' - static scope');
				currentScope = getStaticValue(str, iteration, applicationDomain, String(name));
			}
			currentScope = getDottedSequence(str, iteration, parseValue, scope, currentScope, callFunction);
			// trace('------------------------ STOP PARSE EXECUTABLE');
			return currentScope;
		}
		static public function getDottedSequence(str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object=null, currentScope:Object=null, callFunction:Boolean=true):Object{
			var i:int = iteration.index;
			var len:int = iteration.length;
			var isAttribute:Boolean = false;
			var isGetDescendants:Boolean = false;
			var previousScope:Object = scope;
			var operators:String;
			var name:QName;
			var chr:String;
			// trace(' -- cycle');
			while(i<len){
				chr = str.charAt(i);
				// trace('next char:', chr);
				if(chr==FUNCTION_CALL_OPEN){
					if(callFunction){
						// trace('function call', previousScope);
						if(previousScope is XML || previousScope is XMLList){
							name = new QName(AS3.uri, name.localName);
							currentScope = previousScope[name];
						}
						if(currentScope is Function){
							currentScope = (currentScope as Function).apply(previousScope, ArrayEval.getData(str, iteration, parseValue, scope, FUNCTION_CALL_CLOSE));
						}else throw new EvalUtilsError(EvalUtilsError.getIsNotFunctionMessage(name));
						i = iteration.index;
						continue;
					}else{
						// trace('do not call function', currentScope);
						break;
					}
				}
				if(chr==DOT_CHAR){
					// trace('dot separated names');
					chr = str.charAt(++i);
					if(chr==DOT_CHAR){
						// trace('is descendants');
						isGetDescendants = true;
						chr = str.charAt(++i);
					}else isGetDescendants = false;
					if(chr==FUNCTION_CALL_OPEN){
						throw new Error('EvalUtils do not support E4X filters.');
					}
					if(chr==ATTRIBUTE_SEPARATOR){
						// trace('is attribute');
						isAttribute = true;
						chr = str.charAt(++i);
					}else isAttribute = false;
					iteration.index = i;
					name = getQName(str, iteration, parseValue, scope);
				}else if(chr==DYNAMIC_NAME_OPEN){
					iteration.index = i+1;
					var nameValue:Object = parseValue(str, iteration, scope);
					name = nameValue is QName ? nameValue as QName : new QName('', String(nameValue));
					iteration.index += 1;
				}else{
					break;
				}
				// trace('name: ', name);
				operators = getAssignOperator(str, iteration);
				previousScope = currentScope;
				if(operators){
					// trace('assign operator found:', operators);
					return applyValue(str, iteration, parseValue, operators, currentScope, name, isAttribute, scope);
				}else{
					if(isGetDescendants){
						if(name.uri===null){
							var localName:String = name.localName;
							currentScope = isAttribute ? currentScope..@*.(localName()==localName) : currentScope..*.(localName()==localName);
						}else currentScope = isAttribute ? currentScope..@*.(name()==name) : currentScope..*.(name()==name);
						//currentScope = isAttribute ? currentScope..@[name] : currentScope..[name]; вызывает непредвиденную ошибку при работе descendants+qname
					}else{
						currentScope = isAttribute ? currentScope.@[name] : currentScope[name];
					}
				}
				// trace('scope: ', name, currentScope);
				i = iteration.index;
			}
			iteration.index = i;
			// trace('------------------------ STOP PARSE EXECUTABLE');
			return currentScope;
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
		static public function getAssignOperator(str:String, iteration:LengthIterationIndex):String{
			//------- verify for assign value operation
			var chr:String;
			var i:int = iteration.index;
			var len:int = iteration.length;
			while(SPACES.indexOf((chr = str.charAt(i)))>=0 && i<len) i++;
			iteration.index = i;
			var operators:String = '';
			while(OperationEval.OPERATION_CHAR.indexOf((chr = str.charAt(i)))>=0 && i<len){
				operators+=chr;
				i++;
			}
			if((operators.indexOf(Arithmetic.ASSIGN)>=0 || operators==Arithmetic.INCREMENT || operators==Arithmetic.DECREMENT) && Arithmetic.isArithmetic(operators)){
				iteration.index = i;
				return operators;
			}else return '';
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @param parseValue 
		* @param operation 
		* @param currentScope 
		* @param name 
		* @param isAttribute 
		* @param scope 
		* @return Object 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function applyValue(str:String, iteration:LengthIterationIndex, parseValue:Function, operation:String, currentScope:Object, name:*, isAttribute:Boolean=false, scope:Object=null):Object{
			var i:int = iteration.index;
			var len:int = iteration.length;
			while(SPACES.indexOf(str.charAt(i))>=0 && i<len) i++;
			iteration.index = i;
			var value:Object;
			var tempValue:Object;
			if(operation==Arithmetic.ASSIGN){
				tempValue = parseValue(str, iteration, scope);
			}else if(operation==Arithmetic.INCREMENT){
				tempValue = Arithmetic.increment(currentScope[name]);
			}else if(operation==Arithmetic.DECREMENT){
				tempValue = Arithmetic.decrement(currentScope[name]);
			}else{
				tempValue = Arithmetic.byString(operation, currentScope[name], parseValue(str, iteration, scope));
			}
			value = (isAttribute ? currentScope.@[name] = tempValue : currentScope[name] = tempValue);
			return value;
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @param appd 
		* @param name 
		* @return Object 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getStaticValue(str:String, iteration:LengthIterationIndex, appd:ApplicationDomain=null, name:String=''):Object{
			if(!appd) appd = ApplicationDomain.currentDomain;
			if(!name.length) name = getNameString(str, iteration);
			if(name in PredefinedEval.CONSTANTS) return PredefinedEval.CONSTANTS[name];
			var ret:Object;
			var i:int;
			var chr:String;
			while(!appd.hasDefinition(name) || str.substr(iteration.index, 2)==VECTOR_TYPE_CONTAINER){
				i = iteration.index;
				chr = str.charAt(i);
				if(chr==DOT_CHAR){
					iteration.index = i+1;
					if(str.charAt(iteration.index)==VECTOR_TYPE_OPEN){
						var vectorType:String = getVectorType(str, iteration);
						name += DOT_CHAR+vectorType;
						break;
					}else{
						name += DOT_CHAR+getNameString(str, iteration, RESTRICTED_NAME_CHARS_OBJECT);
					}
				}else if(chr==NAMESPACE_SEPARATOR_PART){
					if(str.charAt(i+1)==NAMESPACE_SEPARATOR_PART){
						iteration.index = i+2;
						name += NAMESPACE_SEPARATOR+getNameString(str, iteration, RESTRICTED_NAME_CHARS_OBJECT);
					}else throw new EvalUtilsError(EvalUtilsError.getIncorrectCharMessage(i+1));
				}else break;
			}
			// trace(' ----------------- getDefinition', '"'+name+'"', str.substr(iteration.index));
			ret = appd.getDefinition(name);
			//iteration.index = i; index already saved inside cycle body
			return ret;
		}
		
		static public function getVectorType(str:String, iteration:LengthIterationIndex):String{
			var i:int = iteration.index;
			var j:int = i+1;
			var openCount:int = 1;
			var chr:String;
			while(openCount){
				var open:int = str.indexOf(VECTOR_TYPE_OPEN, j);
				var close:int = str.indexOf(VECTOR_TYPE_CLOSE, j);
				if(close>0){
					if(open>0 && open<close){
						j = open+1;
						openCount++;
						continue;
					}else{
						j = close+1;
						openCount--;
					}
				}else{
					throw new Error('Wrong Vector type container, can not parse.');
				}
			}
			iteration.index = j;
			//trace('----------- STRING LAST CHAR', str.charAt(j));
			return str.substring(i, j);
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @param parseValue 
		* @param scope 
		* @return QName 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getQName(str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object=null):QName{
			var qn:QName;
			var i:int = iteration.index;
			var chr:String = str.charAt(i);
			var nsuri:String;
			var name:String;
			if(chr==ANY_SIGN){
				nsuri = chr;
				i++;
			}else{
				nsuri = getNameData(str, iteration, parseValue, scope);
				i = iteration.index;
			}
			if(str.charAt(i)==NAMESPACE_SEPARATOR_PART && str.charAt(i+1)==NAMESPACE_SEPARATOR_PART){
				i+=2;
				chr = str.charAt(i);
				if(chr==ANY_SIGN){
					name = chr;
					iteration.index = i+1;
				}else{
					iteration.index = i;
					name = getNameData(str, iteration, parseValue, scope);
				}
			}
			if(name){
				if(nsuri==ANY_SIGN) qn = new QName(null, name);
				else{
					qn = new QName(scope is XML ? (scope as XML).namespace(nsuri) : getData(nsuri, new LengthIterationIndex(nsuri.length), parseValue, scope), name);
				}
			}else qn = new QName('', nsuri);
			return qn;
		}

		/** 
		* 
		* 
		* 
		* @private 
		* @param str 
		* @param iteration 
		* @param parseValue 
		* @param scope 
		* @return * 
		* @see aw.utils.iteration.LengthIterationIndex 
		* @langversion ActionScript 3.0 
		* @playerversion Flash 9.0.28.0 
		*/
		static public function getNameData(str:String, iteration:LengthIterationIndex, parseValue:Function, scope:Object=null):*{
			var i:int = iteration.index;
			var length:int = iteration.length;
			var ret:*;
			if(str.charAt(i)==DYNAMIC_NAME_OPEN){
				iteration.index = i+1;
				ret = parseValue(str, iteration, scope);
				i = iteration.index;
				while(i<length && str.charAt(i)!=DYNAMIC_NAME_CLOSE) i++;
				iteration.index = i+1;
			}else{
				ret = getNameString(str, iteration);
			}
			return ret;
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
		static public function getNameString(str:String, iteration:LengthIterationIndex, restriction:Object=null):String{
			if(!restriction) restriction = RESTRICTED_NAME_CHARS_OBJECT;
			var len:int = iteration.length;
			var i:int = iteration.index;
			var dest:String = str.charAt(i);
			for(i=i+1; i<len; i++){
				if(str.charAt(i) in restriction) break;
			}
			dest = str.substring(iteration.index, i);
			iteration.index = i;
			return dest;
		}
	}
}