package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.ProductDetailContainer;
	import com.sanrenxing.tb.events.GestureEvent;
	import com.sanrenxing.tb.models.CustomComponentTheme;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.services.AppService;
	import com.sanrenxing.tb.utils.Assets;
	import com.sanrenxing.tb.utils.Properties;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class ProductDetailScreen extends Screen
	{
		private var _container:ProductDetailContainer;
		private var _colorPane:ScrollContainer;
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		private var _screenVector:Vector.<ScrollContainer>=new Vector.<ScrollContainer>();
		private var _curScreenIndex:int;
		private var _colorScreen:ProductColorScreen;
		private var _heatScreen:ProductHeatScreen;
		private var _viewScreen:ProductPictureScreen;
		
		private var attentionBtn:Button;
		
		public function ProductDetailScreen()
		{
			super();
			
		}
		
		override protected function initialize():void
		{
			var layout:VerticalLayout = new VerticalLayout();
			
			this._container = new ProductDetailContainer();
			this._container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this._container.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this._container.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.scrollerProperties.snapToPages = true;
			this.addChild(_container);
			
			attentionBtn = new Button();
			attentionBtn.x = 900;
			attentionBtn.y = -150;
//			attentionBtn.height = 132;
			attentionBtn.isToggle = true;
			attentionBtn.nameList.add(CustomComponentTheme.ATTENTION_BTN);
			attentionBtn.addEventListener(Event.TRIGGERED,attentionProduct);
			_model.starling.addChild(attentionBtn);
			showAttentionBtn();
			
			var sqlConnection:SQLConnection = new SQLConnection();
			sqlConnection.open(_model.DATABASE_FILE);
			var insertTable:SQLStatement = new SQLStatement();
			insertTable.sqlConnection = sqlConnection;
			
			var selectTable:SQLStatement = new SQLStatement();
			selectTable.sqlConnection = sqlConnection;
			selectTable.text = Properties.SELECT_ATTENTION_PRODUCT_BY_PRODUCTID_SQL;
			selectTable.parameters[":product_id"] =_model.currentProduct.productId;
			selectTable.execute();
			var sqlResult:SQLResult = selectTable.getResult();
			var entries:Array = sqlResult.data;
			if(entries&&entries.length>0) {
				attentionBtn.isSelected = true;
			}
			
			
			this._container.layout = layout;
			
			_colorScreen = new ProductColorScreen();
			_colorScreen.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			_colorScreen.backgroundSkin = new Image(Assets.getTexture("COLOR_BG"));
//			_colorScreen.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.addChild(_colorScreen);
			
			//-------------------颜色面板注释------------------------------------//
//			var _colorPaneLayout:VerticalLayout = new VerticalLayout();
//			_colorPaneLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
//			_colorPaneLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
//			_colorPaneLayout.gap = 10;
//			_colorPaneLayout.paddingTop = 60;
//			_colorPaneLayout.paddingBottom = 10;
//			
//			_colorPane = new ScrollContainer();
//			_colorPane.width = 136;
//			_colorPane.height = 0;
//			_colorPane.maxHeight = 300;
//			_colorPane.layout = _colorPaneLayout;
//			_colorPane.nameList.add(CustomComponentTheme.COLOR_PANE_BACKGROUND);
//			_colorPane.addEventListener(TouchEvent.TOUCH,onTouchColorPaneHandler);
//			_colorScreen.addChild(_colorPane);
//			
//			var cl:int = _model.currentProduct.productColorImg.length;
//			for(var c:int = 0;c < 1;c++) {
//				var colorBtn:ColorButton = new ColorButton();
//				colorBtn.colorIcon = _model.currentProduct.productColorImg[c].colorIcon;
//				trace(_model.currentProduct.productColorImg[c].colorIcon);
//				_colorPane.addChild(colorBtn);
//				this._colorPane.height += 76;
//			}
			//-------------------颜色面板注释------------------------------------//
			
			_heatScreen =  new ProductHeatScreen();
			_heatScreen.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			_heatScreen.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			_heatScreen.backgroundSkin = new Image(Assets.getTexture("AROUND_BG"));
//			_heatScreen.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.addChild(_heatScreen);
			_viewScreen = new ProductPictureScreen();
			_viewScreen.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			_viewScreen.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			_viewScreen.backgroundSkin = new Image(Assets.getTexture("PICTURE_BG"));
//			_viewScreen.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.addChild(_viewScreen);
			
			_screenVector.push(_colorScreen,_heatScreen,_viewScreen);
			
			enterEffect();
			
			if(!_model.starling.hasEventListener("backEvent")) {
				_model.starling.addEventListener("backEvent",backHandler);
			}
		}
		
		override protected function draw():void
		{
			this._container.width = this.actualWidth;
			this._container.height = this.actualHeight;
			
//			this._colorPane.x = 750;
//			this._colorPane.y = -this._colorPane.height;
			
			_colorScreen.width = this.actualWidth;
			_colorScreen.height = this.actualHeight;
			_colorScreen.init();
			_heatScreen.width = this.actualWidth;
			_heatScreen.height = this.actualHeight;
			_heatScreen.init();
			_viewScreen.width = this.actualWidth;
			_viewScreen.height = this.actualHeight;
			_viewScreen.init();
		}
		
		protected function enterEffect():void
		{
			
//			var moveColorPaneTween:Tween = new Tween(this._colorPane,0.3);
//			moveColorPaneTween.animate("y",0);
//			Starling.juggler.delayCall(Starling.juggler.add,0.35,moveColorPaneTween);
			
			
//			var moveColorPaneTween:Tween = new Tween(
		}
		
		protected function leaveEffect():void
		{
			
		}
		
		private function onGestureSwipeHandler(event:GestureEvent):void
		{
			if(event.offsetY == -1) {
				if(_curScreenIndex==_screenVector.length-1) {
					return;
				}
//				_container.scrollToPageIndex(0,++_curScreenIndex,1);
//				(_container.getChildAt(_curScreenIndex) as LazyLoadContainer).init();
			} else if(event.offsetY == 1) {
				if(_curScreenIndex==0) {
					return;
				}
//				_container.scrollToPageIndex(0,--_curScreenIndex,1);
//				(_container.getChildAt(_curScreenIndex) as LazyLoadContainer).init();
			}
		}
		
		private function showAttentionBtn():void
		{
			var _model:ModelLocator = ModelLocator.getInstance();
			var moveAttentionBtnTween:Tween = new Tween(attentionBtn,0.5);
			moveAttentionBtnTween.animate("y",0);
			Starling.juggler.add(moveAttentionBtnTween);
		}
		
		private function hideAttentionBtn():void
		{
			var _model:ModelLocator = ModelLocator.getInstance();
			var moveAttentionBtnTween:Tween = new Tween(attentionBtn,0.5);
			moveAttentionBtnTween.animate("y",-150);
			Starling.juggler.add(moveAttentionBtnTween);
		}
		
		private function attentionProduct(event:Event):void
		{
//			(new AppService()).addUserAttention(_model.currentProduct.productId);
		}
		
		private function onTouchColorPaneHandler(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(stage);
			
			var len:int = touches.length;
			
			if(len>0&&touches[0].phase == "began") {
				this._container.isGestureFlag = 3;
			}
			
			for(var i:int=0;i<len;i++) {
				if(touches[i].phase != "ended") {
					return;
				}
			}
			this._container.isGestureFlag = 0;
		}
		
		private function backHandler(event:Event):void
		{
			this.dispatchEvent(new starling.events.Event("toProductList"));
			hideAttentionBtn();
		}
		
	}
}