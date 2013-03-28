package com.sanrenxing.tb.models
{
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScrollContainer;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Stage;

	public class UIModel extends DataModel
	{
		public var logo:Bitmap;
		
		public var currentTheme:MetalWorksMobileTheme;
		
		public const PRODUCT_CLASS_SCREEN:String = "productClassScreen";
		public const RPODUCT_LIST_SCREEN:String = "productListScreen";
		public const PRODUCT_DETAIL_SCREEN:String = "productDetailScreen";
		public const PRODUCT_COLOR_SCREEN:String = "productColorScreen";
		public const PRODUCT_HEAT_SCREEN:String = "productHeatScreen";
		public const PRODUCT_SHOW_SCREEN:String = "productShowScreen";
		
		public var stage:flash.display.Stage;
		
		public var starling:starling.display.Stage;
		/**
		 * 设备屏幕尺寸宽度
		 */
		public var screenWidth:int;
		/**
		 * 设备屏幕尺寸高度
		 */
		public var screenHeight:int;
//		
		/**
		 * 商品展示的原宽度
		 */
		public var productWidth:int;
//		/**
//		 * 商品展示的原高度
//		 */
//		public var productHeight:int;
		/**
		 * (商品列表试图)聚焦商品的移动速度与非聚焦商品移动速度的比值
		 */
		public var focusDividedUnfocusSpeed:Number;
		/**
		 * (商品列表试图)聚焦商品的移动速度与触摸速度的比值
		 */
		public var focusDividedTouchSpeed:Number;
		/**
		 * (商品列表试图)聚焦商品移动范围的1/2
		 */
		public var focusProductSpace:int;
		/**
		 * (商品列表试图)非聚焦商品之间的相隔距离
		 */
		public var unfocusProductSpace:int;
		/**
		 * (商品列表试图)非聚焦商品缩放的倍数
		 */
		public var productsScale:Number;
		/**
		 * (商品列表试图)舞台同时显示的商品个数
		 */
		public var showCount4Stage:int;
		/**
		 * 图片之间最大间距
		 */
		public var pictureMaxGap:int;
		/**
		 * 返回按钮
		 */
		public var backBtn:Button;
		/**
		 * 侧边面板
		 */
		public var topPane:ScrollContainer;
		/**
		 * 展开收缩侧边面板按钮
		 */
		public var expLeftPaneBtn:Button;
		
		public var leftPaneIsOpen:Boolean=false;
		
		public function UIModel()
		{
		}
		
		public static function showTopPane():void
		{
			var _model:ModelLocator = ModelLocator.getInstance();
//			_model.topPane.y = 0;
			var moveControlPaneTween:Tween = new Tween(_model.topPane,0.5);
			moveControlPaneTween.animate("y",0);
			Starling.juggler.add(moveControlPaneTween);
//			
//			_model.backBtn.x = -50;
//			var moveBackBtnTween:Tween = new Tween(_model.backBtn,0.5);
//			moveBackBtnTween.animate("x",0);
////			Starling.juggler.add(moveBackBtnTween);
//			Starling.juggler.delayCall(Starling.juggler.add,0.2,moveBackBtnTween);
//			
//			_model.expLeftPaneBtn.x = 150;
//			var moveExpBtnTween:Tween = new Tween(_model.expLeftPaneBtn,0.5);
//			moveExpBtnTween.animate("x",200);
//			Starling.juggler.delayCall(Starling.juggler.add,0.4,moveExpBtnTween);
		}
		public static function hideTopPane():void
		{
			var _model:ModelLocator = ModelLocator.getInstance();
//			_model.topPane.y = -60;
			var moveControlPaneTween:Tween = new Tween(_model.topPane,0.5);
			moveControlPaneTween.animate("y",-60);
			Starling.juggler.add(moveControlPaneTween);
		}
		
//		public static function expLeftPane():void
//		{
//			var _model:ModelLocator = ModelLocator.getInstance();
//			var moveControlPaneTween:Tween = new Tween(_model.leftPane,0.5);
//			moveControlPaneTween.animate("x",0);
//			Starling.juggler.add(moveControlPaneTween);
//		}
//		public static function closeLeftPane():void
//		{
//			var _model:ModelLocator = ModelLocator.getInstance();
//			var moveControlPaneTween:Tween = new Tween(_model.leftPane,0.5);
//			moveControlPaneTween.animate("x",-200);
//			Starling.juggler.add(moveControlPaneTween);
//		}
		
	}
}