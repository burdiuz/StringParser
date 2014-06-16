package aw.utils{

		/**
		* Наиболее часто используемые методы обработки строк.
		* 
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
	public class StringUtils extends Object{

		/**
		* Список пробельных символов, которые применяются к фунциям типа trim, по умолчанию.
		* @public (constant)
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public const TRIMSTRING:String = ' \t\n\r';

		/**
		* Удаление пробельных или указаных символов по краям строки.
		* 
		* @param s Исходная строка.
		* @param signs Строка символов подлежащих удалению.
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function trim(string:String, signs:String=TRIMSTRING):String{
			var length:int = string.length;
			if(!length) return string;
			var index:uint = 0;
			while(index<length && signs.indexOf(string.charAt(index))>=0) index++;
			string = string.substr(index);
			length = string.length;
			if(length){
				index = length-1;
				while(index>=0 && signs.indexOf(string.charAt(index))>=0) index--;
				string = string.substring(0, ++index);
			}
			return string;
		}

		/**
		* Удаление пробельных или указаных символов с начала строки.
		* 
		* @param s Исходная строка.
		* @param signs Строка символов подлежащих удалению.
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function leftTrim(string:String, signs:String=TRIMSTRING):String{
			var length:int = string.length;
			if(!length) return string;
			var index:uint = 0;
			while(index<length && signs.indexOf(string.charAt(index))>=0) index++;
			return string.substr(index);
		}

		/**
		* Удаление пробельных или указаных символов с конца строки.
		* 
		* @param s Исходная строка.
		* @param signs Строка символов подлежащих удалению.
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function rightTrim(string:String, signs:String=TRIMSTRING):String{
			if(!string.length) return string;
			var index:uint = string.length-1;
			while(index>=0 && signs.indexOf(string.charAt(index))>=0) index--;
			return string.substring(0, ++index);
		}

		/**
		* Заполнение строки символами с конца до нужной длины.
		* 
		* @param str Исходная строка.
		* @param num Необходимая длина строки.
		* @param fill Строка символов которыми будет заполнена строка.
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function rightFill(string:String, count:uint, fill:String='0'):String{
			while(string.length<count) string = string+fill;
			return string;
		}

		/**
		* Заполнение строки символами с начала до нужной длины.
		* 
		* @param str Исходная строка.
		* @param num Необходимая длина строки.
		* @param fill Строка символов которыми будет заполнена строка.
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function leftFill(string:String, count:uint, fill:String='0'):String{
			while(string.length<count) string = fill+string;
			return string;
		}

		/**
		* Возвращает строку с уникальными символами из исходной строки.
		* 
		* @param str Исходная строка.
		* @param sort Указывает на необходимость сортировки.
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function getUniqueSymbols(string:String, sort:Boolean = false):String{
			var out:String = '';
			var length:uint = string.length;
			var char:String = null;
			for(var index:uint=0; index<length; index++){
				if(out.indexOf(char = string.substr(index, 1))<0) out += char;
			}
			if(sort){
				out = (out.split('').sort(Array.UNIQUESORT) as Array).join("");
			}
			return out;
		}

		/**
		* Переворачивает строку.
		* 
		* @param str Исходная строка.
		* @param par Количество символов находящихся в группе. Если указать 2, то строка "абвгде" будет возвращена в таком виде: "багвед".
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function reverse(string:String, par:uint=0):String{
			if(!par) return fullReverse(string);
			else{
				var out:String = '';
				var length:uint = string.length;
				var temp:String = '';
				for(var index:uint=0; index<length; index+=par){
					out += fullReverse(string.substr(index, par));
				}
				return out;
			}
		}

		/**
		* Простой переворот строки.
		* 
		* @param str Исходная строка.
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function fullReverse(string:String):String{
			var arr:Array = string.split('');
			arr.reverse();
			return arr.join('');
		}

		/**
		* Разбивка строки на отрезки одинаковой длины.
		* 
		* @param str Исходная строка.
		* @param num Длина исходных отрезков.
		* @return Array
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function split(string:String, count:uint=0):Array{
			if(!count) return string.split('');
			else{
				var out:Array = [];
				var length:uint = string.length;
				for(var index:uint=0; index<length; index+=count){
					out.push(string.substr(index, count));
				}
				return out;
			}
		}

		/**
		* @private
		* @param ... args
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function randomCharFromCode(... args):String{
			var from:uint = (!args[0] || args[0]<=0) ? 1 : args[0];
			var to:uint = (!args[1] || args[1]<=0)  ? 255 : args[1];
			var len:uint = (!args[2] || args[2]<=0) ? 1 : args[2];
			var out:String = '';
			var code:uint = Math.round(from+Math.random()*(to-from));
			for(var i:uint=0; i<len; i++) out += String.fromCharCode(code+i);
			return out;
		}

		/**
		*
		* @private
		* @param str Исходная строка.
		* @param fromCode
		* @param sym
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function cloneStringByCode(str:String, fromCode:uint, sym:String = ''):String{
			if(!sym) sym = getUniqueSymbols(str, true);
			var fcode:Number = fromCode-sym.charCodeAt(0);
			var len:uint = sym.length;
			var fnum:uint = 0;
			var rchar:String = null;
			var fchar:String = null;
			var out:String = str;
			for(var i:uint=0; i<len; i++) {
				rchar = String.fromCharCode(fcode+sym.charCodeAt(i));
				fchar = sym.charAt(i);
				while((fnum = str.indexOf(fchar, fnum))>=0) out = out.substr(0, fnum)+rchar+out.substr(++fnum);
				fnum = 0;
			}
			return out;
		}

		/**
		* Возвращает самый младший код символа из исходной строки.
		* 
		* @param str Исходная строка.
		* @return uint
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function getLowestCodeAt(str:String):uint{
			return getUniqueSymbols(str, true).charCodeAt(0);
		}

		/**
		* Возвращает самый старший код символа из исходной строки.
		* 
		* @param str Исходная строка.
		* @return uint
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function getHighestCodeAt(str:String):uint{
			str = getUniqueSymbols(str, true);
			return str.charCodeAt(str.length-1);
		}

		/**
		* Возвращает строку из числа. Если указать длину, то строка будет заполнена нулями спреди до необходимой длины.
		* 
		* @param num Число для преобразования.
		* @param length Длина строки.
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function numberToString(num:*, length:uint):String{
			var str:String = String(num);
			while(str.length<length) str = '0'+str;
			return str;
		}

		/**
		* Метка параметра шаблона
		* 
		* @public
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public const TEMPLATE_MARK:String = '$';

		/**
		* Возвращает строку из шаблона с заменёнными параметрами. Шаблон вида "Error: {$0} need to be {$1} type."
		* 
		* @param str Шаблонная строка
		* @param args Массив параметров для шаблона
		* @return String
		* @playerversion Flash 9.0.28.0
		* @langversion 3.0
		*/
		static public function createByTemplate(str:String, ...args:Array):String{
			var len:int = args.length;
			for(var i:int=0; i<len; i++) str = str.replace('{$'+String(i)+'}', args[i]);
			return str;
		}
		static public function escapeHTMLEntities(str:String):String{
			return (<root>{str}</root>).text().toXMLString();
		}
	}
}