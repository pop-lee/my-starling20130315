package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.MMovieClip;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.utils.MLoader;
	import com.sanrenxing.tb.vos.ProductColorElementData;
	import com.sanrenxing.tb.vos.ProductElementData;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import feathers.controls.ScrollContainer;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	[Event(name="toProductHeatScreen",type="starling.events.Event")]
	
	public class ProductColorScreen extends ScrollContainer
	{
		private var data:ProductElementData;
		
		private var _colorPane:ScrollContainer;
		private var _productColor:MMovieClip;
		
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		private var loadFlag:int=0;
		
		private var _firX:int;
		private var _firF:int;
		private var _preX:int;  //捕捉上一阵的mouseX
		private var _curX:int;  //捕捉当前帧的mouseX
		private var _dir:int;  //代表滑动方向-1为向左,1为向右
		private var _oldDir:int;
		
		public function ProductColorScreen()
		{
			super();
			
			loadData();
		}
		
		private function loadData():void {
			data = _model.currentProduct;
			
			const length:int = data.productColorImg.length;
			for(var i:int=0;i<length;i++) {
				var loader:MLoader = new MLoader();
				loader.owner = data.productColorImg[i];
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,function (event:flash.events.Event):void
				{
					((event.currentTarget.loader as MLoader).owner as ProductColorElementData).imgData = event.currentTarget.loader.content as Bitmap;
					loadFlag++
					if(loadFlag == length) {
						loadFlag = 0;
						initUI();
						loader.unload();
					}
				});
				//"assets/images/Border.jpg"
				loader.load(new URLRequest(data.productColorImg[i].imgUrl));
			}
		}
		
		protected function initUI():void
		{
			data = _model.currentProduct;
			
			var frames:Vector.<Texture> = new Vector.<Texture>();
			var length:int = data.productColorImg.length;
			for(var i:int=0;i<length;i++) {
				frames.push(Texture.fromBitmap(data.productColorImg[i].imgData));
			}
			_productColor = new MMovieClip(frames,1);
			_productColor.stop();
			this.addChild(_productColor);
			
//			_colorPane = new ScrollContainer();
//			this.addChild(_colorPane);
			
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
			
			_productColor.x = (this.width-_productColor.width)/2;
			_productColor.y = (this.height-_productColor.height)/2;
			
		}
		
		private function onTouchHandler(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(stage);
			
			var len:int = touches.length;
			
			if(len == 0) return;
			
			var touch:Touch = touches[0];
			if(len == 1) {
				
				var pos:Point = touch.getLocation(this);
				if(touch.phase == "began") {
					_firX = _curX = _preX = pos.x;
					_firF = _productColor.currentFrame;
				} else if(touch.phase == "moved") { 
					_preX = _curX;
					_curX = touch.getLocation(stage).x;
					
					_dir = (_curX>_preX)?-1:1;
					if(_oldDir != _dir) {
						_oldDir = _dir;
						_firX = _curX = _preX = pos.x;
						_firF = _productColor.currentFrame;
					}
					
					var _f:int = _firF + ((_curX-_firX)/100%_productColor.numFrames);
					trace(_f + "    " + _firF + "      "  + ((_curX-_firX)/100%_productColor.numFrames));
					if(_f<0) {
						_f = _f%_productColor.numFrames+_productColor.numFrames;
					} else if(_f>0) {
						_f = _f%_productColor.numFrames;
					}
					trace(_f);
					_productColor.currentFrame = _f;
					
//					var oldReverseFlag:Boolean = _productColor.isReverse;
//					if(_productColor.isReverse!=oldReverseFlag) {
//						_firF = _productColor.currentFrame;
//						_firX = _preX;
//					}
//					
//					var curF:int = (_firF + (Math.ceil(Math.abs(_curX-_firX))/100))%_productColor.numFrames;
//					if(curF!=0) {
//						_productColor.currentFrame = curF;
//						trace(_productColor.isReverse + "   " + _firF + "    "  + curF);
//					}
				}
			}
		}
		
	}
}