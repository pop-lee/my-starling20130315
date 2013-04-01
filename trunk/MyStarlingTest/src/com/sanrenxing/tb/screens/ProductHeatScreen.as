package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.MMovieClip;
	import com.sanrenxing.tb.components.ProductDetailChildContainer;
	import com.sanrenxing.tb.events.GestureEvent;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.utils.MBinaryLoader;
	import com.sanrenxing.tb.vos.ProductElementData;
	import com.sanrenxing.tb.vos.ProductHeatElementData;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import feathers.controls.ScrollContainer;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	public class ProductHeatScreen extends ProductDetailChildContainer
	{
		private var data:ProductElementData;
		
//		private var _container:ScrollContainer;
		
		private var productMovie:MMovieClip;
		
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		private var _firX:int;
		private var _firF:int;
		private var _preX:int;  //捕捉上一阵的mouseX
		private var _curX:int;  //捕捉当前帧的mouseX
		private var _preT:int;  //捕捉上一阵的mouseX
		private var _curT:int;  //捕捉当前帧的mouseX
		
		private var loadFlag:int=0;
		
		/**
		 * 当前交互是否为移动
		 */
		private var _isClick:Boolean=false;
		/**
		 * 存储每帧的图像纹理
		 */
		private var frames:Vector.<Texture> = new Vector.<Texture>();
		
		public function ProductHeatScreen()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			loadData();
		}
		
		private function loadData():void {
			data = _model.currentProduct;
			
			const length:int = data.productHeatImg.length;
			trace("========================"+new Date());
			for(var i:int=0;i<length;i++) {
				var loader:MBinaryLoader = new MBinaryLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.owner = data.productHeatImg[i];
				loader.addEventListener(flash.events.Event.COMPLETE,function loadCompleteHandler(event:flash.events.Event):void
				{
//					var byteArray:ByteArray = new ByteArray();
//					byteArray.readUTFBytes(event.currentTarget.data);
					((event.currentTarget as MBinaryLoader).owner as ProductHeatElementData).imgData = event.currentTarget.data;
					loadFlag++;
					if(loadFlag == length) {
						trace("========================"+new Date());
						loadFlag = 0;
						initUI();
						loader.removeEventListener(flash.events.Event.COMPLETE,loadCompleteHandler);
						loader.close();
					}
				});
				loader.load(new URLRequest(data.productHeatImg[i].imgUrl));
			}
		}
		
		protected function initUI():void
		{
			trace("========================"+new Date());
//			_container = new ScrollContainer();
			
			var length:int = data.productHeatImg.length;
			for(var i:int=0;i<length;i++) {
//				Starling.juggler.delayCall(Texture.fromBitmapData,0,data.productHeatImg[i].imgData.bitmapData);
				frames.push(Texture.fromAtfData(data.productHeatImg[i].imgData));
				trace("========================"+new Date());
			}
			trace("========================"+new Date());
			productMovie = new MMovieClip(frames, 4);
			productMovie.x = (this.width - productMovie.width)/2;
			productMovie.y = (this.height - productMovie.height)/2;
			productMovie.x = (this.width-600)/2;//(this.width - productMovie.width)/2;
			productMovie.y = (this.height-441)/2;//(this.height - productMovie.height)/2;
			
			productMovie.stop();
			
			Starling.juggler.add(productMovie);
			
			addChild(productMovie);
			
			if(!this.hasEventListener(TouchEvent.TOUCH)) {
				this.addEventListener(TouchEvent.TOUCH, onTouch); 
			}
		}
		
		private function onTouch(event:TouchEvent):void
		{
			if(this.parentContainer.isScrolling) return;
			
			var touches:Vector.<Touch> = event.getTouches(stage);
			
			var len:int = touches.length;
			
			if(len == 0) return;
			
			var touch:Touch = touches[0];
			if(len == 1) {
				
				var pos:Point = touch.getLocation(this);
				if(touch.phase == "began") {
					_firX = _curX = _preX = pos.x;
					_curT = _preT = getTimer();
					_firF = productMovie.currentFrame;
					productMovie.pause();
				} else if(touch.phase == "moved") { 
					_preX = _curX;
					_curX = touch.getLocation(stage).x;
					_preT = _curT;
					_curT = getTimer();
					
					var oldReverseFlag:Boolean = productMovie.isReverse;
					productMovie.isReverse = (_curX>_preX);
					if(productMovie.isReverse!=oldReverseFlag) {
						_firF = productMovie.currentFrame;
						_firX = _preX;
					}
						
					var curF:int = (_firF + (Math.ceil(Math.abs(_curX-_firX))/20))%productMovie.numFrames;
					if(curF!=0) {
						productMovie.currentFrame = curF;
						trace(productMovie.isReverse + "   " + _firF + "    "  + curF);
					}
				}
			}
			
			for(var i:int=0;i<len;i++) {
				if(touches[i].phase != "ended") {
					return;
				}
			}
			
			var elapsedTime:Number = (getTimer() - _preT) / 1000;
			var xVelocity:Number = (touch.getLocation(stage).x - _preX) / elapsedTime;
			productMovie.isReverse = (xVelocity>0);
			
			var fps:int = Math.floor(Math.abs(xVelocity)/200);
			if(fps!=0) {
				productMovie.fps =  Math.floor(Math.abs(xVelocity)/200);
				productMovie.play();
			}
		}
		
//		private function onGestureHandler(event:GestureEvent):void
//		{
//			if(event.offsetY == -1) {
//				this.dispatchEvent(new starling.events.Event("toProductColorScreen"));
//			} else if(event.offsetY == 1) {
//				this.dispatchEvent(new starling.events.Event("toProductShowScreen"));
//			}
//		}
		
		override public function dispose():void
		{
			this.removeEventListener(TouchEvent.TOUCH, onTouch); 
			
			if(productMovie) {
				this.removeChild(productMovie);
				productMovie.dispose();
				productMovie = null;
			}
			
			var length:int = frames.length;
			for(var i:int=0;i<length;i++) {
				frames[i].dispose();
				frames[i] = null;
			}
			frames = null;
			super.dispose();
		}
		
	}
}