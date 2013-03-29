package com.sanrenxing.tb.vos
{
	import flash.display.BitmapData;

	public class ProductElementData
	{
		public var productId:String;
		
		public var productName:String;
		
		public var productFrontImg:String;
		
		public var productFrontImgData:BitmapData;
		
		public var productColorImg:Vector.<ProductColorElementData>=new Vector.<ProductColorElementData>();
		
		public var productHeatImg:Vector.<ProductHeatElementData>=new Vector.<ProductHeatElementData>();
		
		public var productPicture:Vector.<ProductPictureElementData> = new Vector.<ProductPictureElementData>();
		
		public function ProductElementData()
		{
		}
	}
}