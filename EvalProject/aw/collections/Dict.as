package aw.collections{
	import aw.collections.Hash;
	
	import flash.utils.Dictionary;

	public dynamic class Dict extends Dictionary{
		protected var _useWeakKeys:Boolean;
		public function Dict(weakKeys:Boolean=false):void{
			_useWeakKeys = weakKeys;
			super(_useWeakKeys);
		}
		public function useWeakKeys():Boolean{
			return this._useWeakKeys;
		}
		public function getKeys():Array{
			var arr:Array = [];
			for(var p:* in this) arr.push(p);
			return arr;
		}
		public function getValues():Array{
			var arr:Array = [];
			for each(var p:* in this) arr.push(p);
			return arr;
		}
		public function toHash():Hash{
			var obj:Object = {};
			for(var p:* in this) obj[String(p)] = this[p];
			var hash:Hash = new Hash();
			hash.object_utils::source = obj;
			return hash;
		}
		public function toHashObject():Object{
			var obj:Object = {};
			for(var p:* in this) obj[String(p)] = this[p];
			return obj;
		}
		public function keyOf(value:Object):Object{
			for(var p:* in this){
				if(this[p]===value) return p;
			}
			return null;
		}
		public function getNumItems():int{
			var i:int=0;
			for(var p:* in this) i++;
			return i;
		}
		public function clear():void{
			for(var p:* in this) delete this[p];
		}
		public function each(handler:Function):void{
			for(var p:* in this) handler(p, this[p], this);
		}
		public function clone():Dict{
			var ret:Dict = new Dict(this._useWeakKeys);
			for(var p:* in this) ret[p] = this[p];
			return ret;
		}
		public function merge(dictionary:Dictionary, ...args:Array):Dict{
			var ret:Dict = this.clone();
			args.unshift(dictionary);
			var len:int = args.length;
			for(var i:int=0; i<len; i++){
				dictionary = args[i] as Dictionary;
				for(var p:* in dictionary) ret[p] = dictionary[p];
			}
			return ret;
		}
		public function swap():Dict{
			var dict:Dict = new Dict(this._useWeakKeys);
			for(var p:* in this) dict[this[p]] = p;
			return dict;
		}
	}
}