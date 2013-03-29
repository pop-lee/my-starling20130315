package com.sanrenxing.tb.vos
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class ProductClassElementData
	{
		public var className:String;
		
		public var classImg:String;
		
		public var classImgData:BitmapData;
		
		public var productListVO:Vector.<ProductElementData>=new Vector.<ProductElementData>();
		
		
		public function ProductClassElementData()
		{
		}
	}
}