package com.sanrenxing.tb.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Asynchronous extends EventDispatcher
	{
		public const CALL_COMPLETE:String = "callComplete";
		
		public function result:*;
		
		public function Asynchronous()
		{
		}
		
		public function call(func:Function,thisArg:*, argArray:*):void
		{
			result = func.call(thisArg,argArray);
			this.dispatchEvent(new Event(CALL_COMPLETE));
		}
	}
}