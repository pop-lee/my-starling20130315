package com.sanrenxing.tb.components
{
	import com.sanrenxing.tb.utils.Assets;
	
	import flash.display.BitmapData;
	
	import feathers.core.FeathersControl;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class PictureBox extends FeathersControl
	{
		public var initAngle:int;
		private var _angle:int;
		
		private var _image:Image;
		private var _sprite:Sprite;
		
		public function PictureBox(bitmap:BitmapData)
		{
			super();
			
			_sprite = new Sprite();
			_sprite.addChild(new Image(Assets.getTexture("PIC_BG")));
			addChild(_sprite);
			
			_image = new Image(Texture.fromBitmapData(bitmap));
			_image.x = (_sprite.width-_image.width)/2;
			_image.y = (_sprite.height-_image.height)/2;
			_sprite.addChild(_image);
			_sprite.x = -_sprite.width/2;
			_sprite.y = -_sprite.height/2;
			
			setSize(_sprite.width,_sprite.height);
		}
		
		public function set angle(value:int):void
		{
			if(value == _angle) return;
			_angle = value;
			_sprite.rotation = value*Math.PI/180;
			
			_sprite.x += -(_sprite.bounds.left + (_sprite.width/2));
			_sprite.y += -(_sprite.bounds.top + (_sprite.height/2));
			setSize(_sprite.width,_sprite.height);
		}
		
		public function get angle():int
		{
			return _angle;
		}
	}
}