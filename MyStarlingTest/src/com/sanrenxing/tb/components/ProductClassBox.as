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
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	public class ProductClassBox extends Sprite
	{
		public var data:ProductClassElementData;
		
		private var _label:TextField;
		private var _image:Image;
		
		private var _highLight:Image;
		
		private var _texture:Texture;
		private var _bgTexture:Texture;
		
		public function ProductClassBox(data:ProductClassElementData)
		{
			super();
			this.data = data;
			
//			_label = new TextField(300,30,data.className);
//			_label.x = -100;//_label.height;
//			addChild(_label);
			var mRenderTexture:RenderTexture = new RenderTexture(data.classImgData.width,data.classImgData.height);
			_bgTexture = Assets.getTexture("CLASSBOX_BG");
			mRenderTexture.draw(new Image(_bgTexture));
			_texture = Texture.fromBitmapData(data.classImgData);
			mRenderTexture.draw(new Image(_texture));
			data.classImgData.dispose();
				
			_image = new Image(mRenderTexture);
			addChild(_image);
			
		}
		
		public function showEffect():void
		{
			if(!_image) return;
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
		
		public function highLight():void
		{
			_highLight = new Image(Assets.getTexture("HIGHLIGHT"));
			this.addChild(_highLight);
		}
		public function unHighLight():void
		{
			if(_highLight) {
				this.removeChild(_highLight);
			}
		}
		
		override public function dispose():void
		{
			if(_highLight) {
				this.removeChild(_highLight);
				_highLight.dispose();
				_highLight =  null;
			}
			this.removeChild(_image);
			_image.dispose();
			_image = null;
			_texture.dispose();
			_texture = null;
//			_bgTexture.dispose();
//			_bgTexture = null;
			
			super.dispose();
		}
	}
}