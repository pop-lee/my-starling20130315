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
		
		private var _texture:Texture;
		
		public function ProductImage(data:ProductElementData)
		{
			super();
			
			this.data = data;
			
			_texture = Texture.fromBitmapData(data.productFrontImgData);
			_image = new Image(_texture);
			data.productFrontImgData.dispose();
			_image.x = -_image.width/2;
			_image.y = -_image.height/2;
			addChild(_image);
		}
		
		
		override public function dispose():void
		{
			this.removeChild(_image);
			_image.dispose();
			_image = null;
			_texture.dispose();
			_texture = null;
			data = null;
			super.dispose();
		}
	}
}