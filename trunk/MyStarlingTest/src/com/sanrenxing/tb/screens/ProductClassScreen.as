package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.ProductClassBox;
	import com.sanrenxing.tb.models.CustomComponentTheme;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.utils.Assets;
	import com.sanrenxing.tb.utils.MLoader;
	import com.sanrenxing.tb.vos.ProductClassElementData;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.HorizontalLayout;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	[Event(name="toProductList",type="starling.events.Event")]
	
	public class ProductClassScreen extends Screen
	{
		public var data:ProductClassElementData;
		
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		private var _container:ScrollContainer;
		
		private var _productClassList:Vector.<ProductClassBox> = new Vector.<ProductClassBox>();
		
		private var loadFlag:int = 0;
		
		private var isMove:Boolean = false;
		private var firX:int = 0;
		private var firY:int = 0;
		
		private var _currentTouchBox:ProductClassBox;
		
		public function ProductClassScreen()
		{
			super();
			
			loadData();
		}
		
		private function loadData():void
		{
			const classLength:int = _model.productVector.length;
			for(var i:int=0;i<classLength;i++) {
				var loader:MLoader = new MLoader();
				loader.owner = _model.productVector[i];
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,function (event:flash.events.Event):void
				{
					((event.currentTarget.loader as MLoader).owner as ProductClassElementData).classImgData = event.currentTarget.loader.content as Bitmap;
					loadFlag++
					if(loadFlag == classLength) {
						loadFlag = 0;
						initUI();
						loader.unload();
					}
				});
				//"assets/images/Border.jpg"
				loader.load(new URLRequest(_model.productVector[i].classImg));
			}
		}
		
		private function initUI():void
		{
			const layout:HorizontalLayout = new HorizontalLayout();
			layout.verticalAlign=HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.paddingLeft = 50;
			layout.paddingRight = 50;
			layout.gap = 15;
			
			this._container = new ScrollContainer();
			this._container.layout = layout;
			//when the scroll policy is set to on, the "elastic" edges will be
			//active even when the max scroll position is zero
			this._container.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			//			this._container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this._container.scrollerProperties.snapScrollPositionsToPixels = true;
//			this._container.nameList.add(CustomComponentTheme.CLASS_BG);
			this._container.backgroundSkin = new Image(Assets.getTexture("CLASS_BG"));
			this.addChild(this._container);
			
			var productClassBox:ProductClassBox;
			const classLength:int = _model.productVector.length;
			for(var i:int=0;i<classLength;i++) {
				productClassBox = new ProductClassBox(_model.productVector[i]);
				productClassBox.visible = false;
				productClassBox.addEventListener(TouchEvent.TOUCH, onTouch); 
				_productClassList.push(productClassBox);
				this._container.addChild(productClassBox);
				Starling.juggler.delayCall(productClassBox.showEffect,i*0.5);
			}
			
			this._container.width = this.actualWidth;
			this._container.height = this.actualHeight;
			
			if(_model.logo) {
				_model.stage.removeChild(_model.logo);
				_model.logo = null;
			}
		}
		
		private function onTouch (e:TouchEvent):void 
		{
			// get the mouse location related to the stage 
			var touch:Touch = e.getTouch(stage); 
			if(touch==null) return;
			var pos:Point = touch.getLocation(stage); 
//			var classBtn:ProductClassBox = e.currentTarget as ProductClassBox;
			
			if(touch.phase == "began") {
				if(!_currentTouchBox) {
					_currentTouchBox = e.currentTarget as ProductClassBox;
					_currentTouchBox.highLight();
				}
				firX = pos.x;
				firY = pos.y;
			}
			
			if(touch.phase == "ended") {
				if(isMove) {
					isMove=false;
					if(_currentTouchBox) {
						_currentTouchBox.unHighLight();
						_currentTouchBox = null;
					}
				} else {
					toProductListScreen((e.currentTarget as ProductClassBox).data);
				}
			}
			
			if(touch.phase == "moved") {
				if(Math.abs(pos.x-firX)>20||Math.abs(pos.y-firY)>20) {
					if(_currentTouchBox) {
						_currentTouchBox.unHighLight();
						_currentTouchBox = null;
					}
					isMove = true;
				}
			}
		}
		
		protected function toProductListScreen(data:ProductClassElementData):void
		{
			_model.currentProductClass = data;
			this.dispatchEvent(new starling.events.Event("toProductList"));
		}
	}
}