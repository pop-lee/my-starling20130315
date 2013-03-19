package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.PictureBox;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.utils.MLoader;
	import com.sanrenxing.tb.vos.ProductElementData;
	import com.sanrenxing.tb.vos.ProductPictureElementData;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.events.FeathersEventType;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class ProductPictureScreen extends ScrollContainer
	{
		private var data:ProductElementData;
		
		private var _container:ScrollContainer;
		
		private var pictureVector:Vector.<PictureBox> = new Vector.<PictureBox>;
		
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		private var _pictureGap:int;
		
		private var _isOpenStatus:Boolean = false;//标记当前图片是否为展开状态
		
		private var loadFlag:int=0;
		
		public function ProductPictureScreen()
		{
			super();
			
			loadData();
		}
		
		private function loadData():void {
			data = _model.currentProduct;
			
			const length:int = data.productPicture.length;
			for(var i:int=0;i<length;i++) {
				var loader:MLoader = new MLoader();
				loader.owner = data.productPicture[i];
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,function (event:flash.events.Event):void
				{
					((event.currentTarget.loader as MLoader).owner as ProductPictureElementData).imgData = event.currentTarget.loader.content as Bitmap;
					loadFlag++
					if(loadFlag == length) {
						loadFlag = 0;
						initUI();
						loader.unload();
					}
				});
				//"assets/images/Border.jpg"
				loader.load(new URLRequest(data.productPicture[i].imgUrl));
			}
		}
		
		protected function initUI():void
		{
			var picturesLength:int = data.productPicture.length;
			_pictureGap = 0;
			for(var i:int=0;i<picturesLength;i++) {
				var picture:PictureBox = new PictureBox(data.productPicture[i].imgData);
				picture.initAngle = (Math.ceil(Math.random()*10))*6-30;
				picture.angle = picture.initAngle;
				picture.x = this.actualWidth/2;
				picture.y = this.actualHeight/2;
				pictureVector.push(picture);
				this.addChild(picture);
			}
			
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		
		private function onTouchHandler(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(stage);
			
			var length:int = pictureVector.length;
			trace(touches.length);
			if(touches.length == 2) {
				this.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
				
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
				
				if(sizeDiff>1) {
					if(_pictureGap>=_model.pictureMaxGap) return;
					_pictureGap+=100* Math.abs(1-sizeDiff);
				} else {
					if(_pictureGap<=0) return;
					_pictureGap-=200* Math.abs(1-sizeDiff);
				}
				
				
				for(var i:int=0;i<length;i++) {
					Starling.juggler.removeTweens(pictureVector[i]);
					
					pictureVector[i].x = pictureVector[0].x + _pictureGap*i;                                     
//					trace("pictureVector[i].initAngle   " +  pictureVector[i].initAngle + "_pictureGap/_model.pictureMaxGap   " + (_pictureGap/_model.pictureMaxGap));
					
					pictureVector[i].angle = pictureVector[i].initAngle*(1-(_pictureGap/_model.pictureMaxGap));
				}
				if(pictureVector[0]) {
					pictureVector[0].dispatchEvent(new starling.events.Event(FeathersEventType.RESIZE,false));
				}
				
				if(touches[0].phase == "ended" || touches[1].phase == "ended") {
					this.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
					
					if(_isOpenStatus) {
						if(_pictureGap<_model.productWidth*5/6) {
							closePic();
						} else {
							expansionPic();
						}
					} else {
						if(_pictureGap>_model.productWidth/6) {
							expansionPic();
						} else {
							closePic();
						}
					}
//					if(_pictureGap>_model.productWidth/3) {
//						for(var a:int=0;a<length;a++) {
//							var openTween:Tween = new Tween(pictureVector[a],1,Transitions.EASE_OUT);
//							_pictureGap = _model.pictureMaxGap;
//							openTween.animate("x",pictureVector[0].x + _pictureGap*a);
//							openTween.animate("angle",0);
//							_isOpenStatus = true;
//							Starling.juggler.add(openTween);
//						}
//					} else {
//						for(var b:int=0;b<length;b++) {
//							var closeTween:Tween = new Tween(pictureVector[b],1,Transitions.EASE_OUT);
//							_pictureGap = 0;
//							closeTween.animate("x",pictureVector[0].x);
//							closeTween.animate("angle",pictureVector[b].initAngle);
//							_isOpenStatus = false;
//							Starling.juggler.add(closeTween);
//						}
//					}
				}
//				this.removeChildAt(0);
			}
		}
		
		private function expansionPic():void
		{
			var length:int = pictureVector.length;
			_pictureGap = _model.pictureMaxGap;
			for(var a:int=0;a<length;a++) {
				var openTween:Tween = new Tween(pictureVector[a],1,Transitions.EASE_OUT);
				openTween.animate("x",pictureVector[0].x + _pictureGap*a);
				openTween.animate("angle",0);
				_isOpenStatus = true;
				Starling.juggler.add(openTween);
			}
		}
		
		private function closePic():void
		{
			var length:int = pictureVector.length;
			_pictureGap = 0;
			for(var b:int=0;b<length;b++) {
				var closeTween:Tween = new Tween(pictureVector[b],1,Transitions.EASE_OUT);
				closeTween.animate("x",pictureVector[0].x);
				closeTween.animate("angle",pictureVector[b].initAngle);
				_isOpenStatus = false;
				Starling.juggler.add(closeTween);
			}
		}
	}
}