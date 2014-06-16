package aw.utils{

	/** 
	* It’s a class calling for methods and functions from references directly, 
	* without calling Function.call() or Function.apply(). It contains hidden 
	* methods for calling functions by the number of arguments (the maximum 
	* number of arguments is 15), each of the methods contains the following 
	* code for calling a function from reference 
<listing version="3.0">
		static private function callNMethod(func:Function, args:Array):&#042;{
			return func(args[0], args[1], args[2], args[3], ...args[N]);
		}
</listing>
	* for calling a function by name of a class member 
<listing version="3.0">
		static private function callNByName(obj:Object, name:&#042;, args:Array):&#042;{
			return obj[name](args[0], args[1], args[2], args[3], ...args[N]);
		}
</listing>
	* You can get access to a specific method according to the number of arguments with methods MethodCaller.getCaller() and MethodCaller.getCallerByMethod().
	* 
	* @public 
	* @author Galaburda a_[w] Oleg	  http://www.actualwave.com 
	*/
	public class MethodCaller extends Object{
		static private const methodCallers:Array = [call0Method, call1Method, call2Method, call3Method, call4Method, call5Method, call6Method, call7Method, call8Method, call9Method, call10Method, call11Method, call12Method, call13Method, call14Method, call15Method];
		//static private const byNameCallers:Array = [call0ByName, call1ByName, call2ByName, call3ByName, call4ByName, call5ByName, call6ByName, call7ByName, call8ByName, call9ByName, call10ByName, call11ByName, call12ByName, call13ByName, call14ByName, call15ByName];
		static public function call(func:Function, ...args:Array):*{
			return methodCallers[args.length](func, args);
		}
		static public function apply(func:Function, args:Array):*{
			return methodCallers[args.length](func, args);
		}
		/*
		static public function callByName(obj:Object, name:*, ...args:Array):*{
			return byNameCallers[args.length](obj, name, args);
		}
		static public function applyByName(obj:Object, name:*, args:Array):*{
			return byNameCallers[args.length](obj, name, args);
		}
		*/
		static public function getCaller(args:Array):Function{
			return methodCallers[args.length];
		}
		static public function getCallerByMethod(handler:Function):Function{
			return methodCallers[handler.length];
		}
		static private function call0Method(func:Function, args:Array=null):*{
			return func();
		}
		static private function call1Method(func:Function, args:Array):*{
			return func(args[0]);
		}
		static private function call2Method(func:Function, args:Array):*{
			return func(args[0], args[1]);
		}
		static private function call3Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2]);
		}
		static private function call4Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3]);
		}
		static private function call5Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4]);
		}
		static private function call6Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5]);
		}
		static private function call7Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
		}
		static private function call8Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
		}
		static private function call9Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
		}
		static private function call10Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
		}
		static private function call11Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
		}
		static private function call12Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
		}
		static private function call13Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
		}
		static private function call14Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]);
		}
		static private function call15Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]);
		}
		static private function call16Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15]);
		}
		static private function call17Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16]);
		}
		static private function call18Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17]);
		}
		static private function call19Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18]);
		}
		static private function call20Method(func:Function, args:Array):*{
			return func(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19]);
		}
		/*
		static private function call0ByName(obj:Object, name:*, args:Array=null):*{
			return obj[name]();
		}
		static private function call1ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0]);
		}
		static private function call2ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1]);
		}
		static private function call3ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2]);
		}
		static private function call4ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3]);
		}
		static private function call5ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4]);
		}
		static private function call6ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5]);
		}
		static private function call7ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
		}
		static private function call8ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
		}
		static private function call9ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
		}
		static private function call10ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
		}
		static private function call11ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
		}
		static private function call12ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
		}
		static private function call13ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
		}
		static private function call14ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]);
		}
		static private function call15ByName(obj:Object, name:*, args:Array):*{
			return obj[name](args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]);
		}
		*/
	}
}