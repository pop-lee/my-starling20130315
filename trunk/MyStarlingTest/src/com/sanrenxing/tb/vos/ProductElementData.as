package com.sanrenxing.tb.vos
{
	import flash.display.Bitmap;

	public class ProductElementData
	{
		public var productName:String;
		
		public var productFrontImg:String;
		
		public var productFrontImgData:Bitmap;
		
		public var productColorImg:Vector.<ProductColorElementData>=new Vector.<ProductColorElementData>();
		
		public var productPicture:Vector.<ProductPictureElementData> = new Vector.<ProductPictureElementData>();
		
		public function ProductElementData()
		{
		}
	}
}