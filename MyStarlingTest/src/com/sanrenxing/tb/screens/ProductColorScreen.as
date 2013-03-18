package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.MMovieClip;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.utils.MURLLoader;
	import com.sanrenxing.tb.vos.ProductColorElementData;
	import com.sanrenxing.tb.vos.ProductElementData;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import feathers.controls.ScrollContainer;
	
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
		
		public function ProductColorScreen()
		{
			super();
			
			loadData();
		}
		
		private function loadData():void {
			data = _model.currentProduct;
			
			const length:int = data.productColorImg.length;
			for(var i:int=0;i<length;i++) {
				var loader:MURLLoader = new MURLLoader();
				loader.owner = data.productColorImg[i];
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,function (event:flash.events.Event):void
				{
					((event.currentTarget.loader as MURLLoader).owner as ProductColorElementData).imgData = event.currentTarget.loader.content as Bitmap;
					loadFlag++
					if(loadFlag == length) {
						loadFlag = 0;
						initUI();
					}
				});
				//"assets/images/Border.jpg"
				loader.load(new URLRequest(data.productColorImg[i].imgUrl));
			}
		}
		
		public function init():void
		{
			initData();
			initUI();
		}
		
		protected function initData():void
		{
			data = _model.currentProduct;
			
			var frames:Vector.<Texture> = new Vector.<Texture>();
			var length:int = data.productColorImg.length;
			for(var i:int=0;i<length;i++) {
				frames.push(Texture.fromBitmap(data.productColorImg[i].imgData));
			}
			_productColor = new MMovieClip(frames,0);
			this.addChild(_productColor);
			
//			_colorPane = new ScrollContainer();
//			this.addChild(_colorPane);
			
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
			
		}
		
		protected function initUI():void
		{
			_productColor.x = this.width/2;
			_productColor.y = this.height/2;
			
//			var _colorPaneLayout:VerticalLayout = new VerticalLayout();
//			_colorPaneLayout.gap = 5;
//			_colorPaneLayout.paddingTop = 5;
//			_colorPane.layout = _colorPaneLayout;
//			_colorPane.y = -_colorPane.height;
//			
//			var _colorPaneTween:Tween= new Tween(_colorPane,0.7,Transitions.EASE_OUT_BACK);
//			_colorPaneTween.animate("y",0);
//			Starling.juggler.add(_colorPaneTween);
		}
		
		private function onTouchHandler(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this);
			
			trace(this.horizontalScrollPosition + "        " + this.verticalScrollPosition);
			if(touches.length == 2) {
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				var currentPosA:Point  = touchA.getLocation(parent);
				var previousPosA:Point = touchA.getPreviousLocation(parent);
				var currentPosB:Point  = touchB.getLocation(parent);
				var previousPosB:Point = touchB.getPreviousLocation(parent);
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				var sizeDiff:Number = currentVector.length / previousVector.length;
				trace(sizeDiff);
				
//				if(sizeDiff>1) {
//					if(_pictureGap>=_model.pictureMaxGap) return;
//					_pictureGap+=20;
//				} else {
//					if(_pictureGap<=0) return;
//					_pictureGap-=20;
//				}
//				
//				var length:int = pictureVector.length;
//				for(var i:int=0;i<length;i++) {
//					pictureVector[i].x = pictureVector[0].x + _pictureGap*i;
//					trace("pictureVector[i].initAngle   " +  pictureVector[i].initAngle + "_pictureGap/_model.pictureMaxGap   " + (_pictureGap/_model.pictureMaxGap));
//					
//					pictureVector[i].angle = pictureVector[i].initAngle*(1-(_pictureGap/_model.pictureMaxGap));
//				}
			}
		}
		
	}
}