package
{
	import com.sanrenxing.tb.models.ModelLocator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
	
	import starling.core.Starling;

	[SWF(frameRate="60",backgroundColor="#2f2f2f")]
	public class Test extends Sprite
	{
		[Embed(source = "assets/images/theme1/root_logo.png")]
		public static const ROOT_LOGO:Class;
		
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		private var mStarling:Starling;
		
		private var loader:Loader;
		
		public static var bitmap:Bitmap;
		
		public function Test()
		{
//			initData();
			
			//日志输出
			var traceTarget:TraceTarget = new TraceTarget();
			traceTarget.filters = []; //这样写过滤器，就是输出全部类了
			traceTarget.includeDate = true; //输出信息是否包含日期
			traceTarget.includeTime = true; //输出信息是否包含时间
			traceTarget.includeLevel = true; //输出信息是否包含等级
			traceTarget.includeCategory = true; //输出信息是否包含class名
			traceTarget.level = LogEventLevel.ALL; //设定输出的等级
			Log.addTarget(traceTarget);
			
			// init logo
//			var bmd:BitmapData = new BitmapData(this.stage.fullScreenWidth,this.stage.fullScreenHeight,false,0xe8e4e5);
//			var obj:Object = new ROOT_LOGO();
//			var logoBitmapData:BitmapData = (new ROOT_LOGO()).bitmapData as BitmapData;
//			bmd.copyPixels(
//				logoBitmapData,
//				new Rectangle(0,0,logoBitmapData.width,logoBitmapData.height),
//				new Point((this.stage.fullScreenWidth-logoBitmapData.width)/2,(this.stage.fullScreenHeight-logoBitmapData.height)/2));
			_model.logo = new ROOT_LOGO();//new Bitmap(bmd);
			stage.addChild(_model.logo);
			_model.stage = stage;
			
			// Init Stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Init Starling
			Starling.multitouchEnabled = true; // useful on mobile devices
			Starling.handleLostContext = true; // deactivate on mobile devices (to save memory)
			
			mStarling = new Starling(Main, stage);
			mStarling.simulateMultitouch = true;
			mStarling.enableErrorChecking = false;
			mStarling.showStats = true;
			mStarling.start();
			
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			
			// this event is dispatched when stage3D is set up
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			_model.screenWidth = this.stage.stageWidth;
			_model.screenHeight = this.stage.stageHeight;
			_model.productWidth = 480;
			_model.pictureMaxGap = 520;
			//			_model.productHeight = 320;
			_model.focusDividedTouchSpeed = 0.3;
			_model.unfocusProductSpace = _model.productWidth/3;
			_model.focusDividedUnfocusSpeed = 2;
			_model.focusProductSpace = _model.unfocusProductSpace*_model.focusDividedUnfocusSpeed/2;
			_model.productsScale = 0.5;
			_model.showCount4Stage = 5;
			
			this.mStarling.stage.stageWidth = this.stage.stageWidth;
			this.mStarling.stage.stageHeight = this.stage.stageHeight;
			
			const viewPort:Rectangle = this.mStarling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
			try
			{
				this.mStarling.viewPort = viewPort;
			}
			catch(error:Error) {}
		}
		
		private function onContextCreated(event:Event):void
		{
			// set framerate to 30 in software mode
			
			if (Starling.context.driverInfo.toLowerCase().indexOf("software") != -1)
				Starling.current.nativeStage.frameRate = 30;
		}
	}
}