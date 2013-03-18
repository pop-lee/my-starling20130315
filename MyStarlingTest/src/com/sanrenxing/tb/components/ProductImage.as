package com.sanrenxing.tb.components
{
	import com.sanrenxing.tb.vos.ProductElementData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class ProductImage extends Sprite
	{
		public var data:ProductElementData;
		
		private var _image:Image;
		
		public function ProductImage(data:ProductElementData)
		{
			super();
			
			this.data = data;
			
			_image = new Image(Texture.fromBitmap(data.productFrontImgData));
			_image.x = -_image.width/2;
			_image.y = -_image.height/2;
			addChild(_image);
		}
	}
}