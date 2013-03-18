package com.sanrenxing.tb.components
{
	import flash.display.Bitmap;
	
	import feathers.core.FeathersControl;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class PictureBox extends FeathersControl
	{
		public var initAngle:int;
		private var _angle:int;
		
		private var _image:Image;
		
		public function PictureBox(bitmap:Bitmap)
		{
			super();
			
			_image = new Image(Texture.fromBitmap(bitmap));
			_image.x = -_image.width/2;
			_image.y = -_image.height/2;
			addChild(_image);
			
			setSize(_image.width,_image.height);
		}
		
		public function set angle(value:int):void
		{
			if(value == _angle) return;
			_angle = value;
			_image.rotation = value*Math.PI/180;
			
			_image.x += -(_image.bounds.left + (_image.width/2));
			_image.y += -(_image.bounds.top + (_image.height/2));
			setSize(_image.width,_image.height);
		}
		
		public function get angle():int
		{
			return _angle;
		}
	}
}