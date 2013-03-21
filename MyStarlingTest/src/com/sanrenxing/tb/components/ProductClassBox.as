package com.sanrenxing.tb.components
{
	import com.sanrenxing.tb.utils.Assets;
	import com.sanrenxing.tb.vos.ProductClassElementData;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class ProductClassBox extends Sprite
	{
		public var data:ProductClassElementData;
		
		private var _label:TextField;
		private var _image:Image;
		
		public function ProductClassBox(data:ProductClassElementData)
		{
			super();
			this.data = data;
			
//			_label = new TextField(300,30,data.className);
//			_label.x = -100;//_label.height;
//			addChild(_label);
			
			_image = new Image(Texture.fromBitmap(data.classImgData));
			addChild(_image);
			
			_image.addEventListener(TouchPhase.BEGAN, onTouch);
		}
		
		public function showEffect():void
		{
			this.visible = true;
			
			_image.scaleX = _image.scaleY = 0.5;
			_image.x = 300;
			_image.y = (this.height - _image.height/2)/2;
			
			var tween:Tween = new Tween(_image,0.5,Transitions.EASE_OUT);
			var tween2:Tween = new Tween(_image,0.7,Transitions.EASE_OUT);
			tween.scaleTo(1);
			tween2.moveTo(0,0);
			Starling.juggler.add(tween);
			Starling.juggler.add(tween2);
		}
		
		private function onTouch(event:TouchPhase):void
		{
			trace("mouseClick");
		}
	}
}