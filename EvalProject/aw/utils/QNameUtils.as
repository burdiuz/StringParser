package aw.utils{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * 
	 * @author Galaburda Oleg http://actualwave.com
	 * 
	 */
	public class QNameUtils extends Object{
		static private const proxyIsAttributeMethod:Function = (new Proxy()).flash_proxy::isAttribute;
		static public const ANY_LOCAL_NAME:String = "*";
		static public const ANY_NAMESPACE:String = null;
		static public const BASE_NAMESPACE:String = "";
		static public const ANY_NAMESPACE_STRING:String = "*";
		static public const STRING_SEPARATOR:String = "::";
		static public function isAttribute(name:*):Boolean{
			return name is QName ? proxyIsAttributeMethod(name) : false;
		}
		static private var _converter:ConverterProxy;
		static public function setAttribute(name:*, isAttribute:Boolean=true):QName{
			if(isAttribute){
				if(!_converter) _converter = new ConverterProxy();
				name = _converter.@[name];
			}else name = name is QName ? new QName(name.uri, name.localName) : new QName("", name);
			return name;
		}
		static private const STRING_SEPARATOR_LENGTH:int = STRING_SEPARATOR.length;
		static public function parse(value:String):QName{
			var index:int = value.lastIndexOf(STRING_SEPARATOR);
			var name:QName;
			if(index<0){
				name = new QName("", value); 
			}else{
				var uri:* = value.substr(0, index);
				if(uri==ANY_NAMESPACE_STRING) uri = null;
				name = new QName(uri, value.substr(index+STRING_SEPARATOR_LENGTH));
			}
			return name;
		}
		static public function create(uri:*=ANY_NAMESPACE, localName:*=ANY_LOCAL_NAME, attribute:Boolean=false):QName{
			var name:QName = new QName(uri, localName);
			return attribute ? setAttribute(name) : name;
		}
	}
}
import flash.utils.Proxy;
import flash.utils.flash_proxy;

class ConverterProxy extends Proxy{
	public function ConverterProxy():void{
		super();
	}
	override flash_proxy function getProperty(name:*):*{
		return name;
	}
}