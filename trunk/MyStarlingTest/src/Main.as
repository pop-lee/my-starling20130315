package
{
	import com.sanrenxing.tb.models.CustomComponentTheme;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.models.UIModel;
	import com.sanrenxing.tb.screens.ProductClassScreen;
	import com.sanrenxing.tb.screens.ProductDetailScreen;
	import com.sanrenxing.tb.screens.ProductListScreen;
	import com.sanrenxing.tb.utils.Assets;
	import com.sanrenxing.tb.vos.ProductClassElementData;
	
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenFadeTransitionManager;
		
		
		public function Main()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private var productClassVO:ProductClassElementData;
		
		private function addedToStageHandler():void
		{
			_model.stage = this.stage;
			_model.currentTheme = new CustomComponentTheme(this.stage);
			
			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);
			
			var leftContainer:ScrollContainer = new ScrollContainer();
			leftContainer.nameList.add(CustomComponentTheme.CONTROL_PANE_BACKGROUND);
			leftContainer.width = 260;
			leftContainer.height = _model.screenHeight;
			leftContainer.x = -250;
			_model.leftPane = leftContainer;
			this.addChild(leftContainer);
			
			var expLeftPaneBtn:Button = new Button();
			expLeftPaneBtn.nameList.add(CustomComponentTheme.EXP_LEFT_PANE_BTN);
			expLeftPaneBtn.y = 150;
			expLeftPaneBtn.addEventListener(Event.TRIGGERED,function ():void
			{
				if(_model.leftPaneIsOpen) {
					_model.leftPaneIsOpen = false;
					expLeftPaneBtn.defaultSkin = new Image(Assets.getTexture("EXP_LEFT_PANE_BTN"));
					UIModel.closeLeftPane();
				} else {
					_model.leftPaneIsOpen = true;
					expLeftPaneBtn.defaultSkin = new Image(Assets.getTexture("CLOSE_LEFT_PANE_BTN"));
					UIModel.expLeftPane()
				}
			});
			_model.expLeftPaneBtn = expLeftPaneBtn;
			leftContainer.addChild(expLeftPaneBtn);
			
			var backBtn:Button = new Button();
			backBtn.nameList.add(CustomComponentTheme.BACK_BTN);
			backBtn.x = -50;
			backBtn.y = 100;
			backBtn.addEventListener(Event.TRIGGERED,function ():void
			{
				_model.stage.dispatchEvent(new Event("backEvent"));
			});
			_model.backBtn = backBtn;
			this.addChild(backBtn);
			
			var logo:Image = new Image(Assets.getTexture("LOGO"));
			logo.x = 50;
			this.addChild(logo);
			
			this._navigator.addScreen(_model.PRODUCT_CLASS_SCREEN, new ScreenNavigatorItem(
				ProductClassScreen,
				{
					toProductList:_model.RPODUCT_LIST_SCREEN
				}
			));
			this._navigator.addScreen(_model.RPODUCT_LIST_SCREEN, new ScreenNavigatorItem(
				ProductListScreen,
				{
					toProductDetail:_model.PRODUCT_DETAIL_SCREEN,
					toProductClass:_model.PRODUCT_CLASS_SCREEN
				}
			));
			
			this._navigator.addScreen(_model.PRODUCT_DETAIL_SCREEN,new ScreenNavigatorItem(
				ProductDetailScreen,
				{
					toProductList:_model.RPODUCT_LIST_SCREEN
				}
			));
			
			this._navigator.showScreen(_model.PRODUCT_CLASS_SCREEN);
			
			this._transitionManager = new ScreenFadeTransitionManager(this._navigator);
			this._transitionManager.duration=1;
			
		}
		
	}
}