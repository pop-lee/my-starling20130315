package com.sanrenxing.tb.utils
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class MBinaryLoader extends URLLoader
	{
		public var owner:Object;
		
		public function MBinaryLoader(request:URLRequest=null)
		{
			super(request);
			
			this.dataFormat = URLLoaderDataFormat.BINARY;
		}
	}
}