package com.sanrenxing.tb.utils
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	
	public class MLoader extends Loader
	{
		public var owner:Object;
		
		public function MLoader()
		{
			super();
		}
		
		override public function load(request:URLRequest, context:LoaderContext=null):void 
		{
			
			if(context == null) {
				context = new LoaderContext();
			}
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			super.load(request,context);
		}
	}
}