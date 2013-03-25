package
{
	import com.sanrenxing.tb.components.UserAttenctionBox;
	import com.sanrenxing.tb.models.CustomComponentTheme;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.models.UIModel;
	import com.sanrenxing.tb.screens.ProductClassScreen;
	import com.sanrenxing.tb.screens.ProductDetailScreen;
	import com.sanrenxing.tb.screens.ProductListScreen;
	import com.sanrenxing.tb.services.AppService;
	import com.sanrenxing.tb.utils.Assets;
	import com.sanrenxing.tb.utils.Properties;
	import com.sanrenxing.tb.vos.ProductClassElementData;
	import com.sanrenxing.tb.vos.ProductColorElementData;
	import com.sanrenxing.tb.vos.ProductDBData;
	import com.sanrenxing.tb.vos.ProductElementData;
	import com.sanrenxing.tb.vos.ProductHeatElementData;
	import com.sanrenxing.tb.vos.ProductPictureElementData;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.RemoteNotificationEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.notifications.NotificationStyle;
	import flash.notifications.RemoteNotifierSubscribeOptions;
	
	import mx.utils.RpcClassAliasInitializer;
	
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	public class Main extends starling.display.Sprite
	{
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenFadeTransitionManager;
		
		private var rootLogo:starling.display.Sprite = new starling.display.Sprite();;
		
		public function Main()
		{
			super();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler():void
		{
			
			//----------------------------------------create sqlite database
			var sqlConnection:SQLConnection = new SQLConnection();
			sqlConnection.open(_model.DATABASE_FILE);
			
			var createTable:SQLStatement = new SQLStatement();
			createTable.sqlConnection = sqlConnection;
			createTable.text = Properties.CREATE_FAV_PRODUCT_SQL;
			createTable.execute();
			sqlConnection.close();
			//----------------------------------------
			
			//----------------------------------------add pushNotification listener
			var subscribeOptions:RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions();
			var preferredStyles:Vector.<String> = new Vector.<String>();
			preferredStyles.push(NotificationStyle.ALERT ,NotificationStyle.BADGE,NotificationStyle.SOUND );
			subscribeOptions.notificationStyles = preferredStyles;
			_model.remoteNotifier.addEventListener(RemoteNotificationEvent.TOKEN,remoteNotificationHandler);
			_model.remoteNotifier.addEventListener(RemoteNotificationEvent.NOTIFICATION,remoteNotificationHandler);
			_model.remoteNotifier.subscribe(subscribeOptions);
			//----------------------------------------
			
			//register Class
			RpcClassAliasInitializer.registerClassAliases();
			
			//----------------------------------------init assets
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE,function loadDataHandler(event:flash.events.Event):void
			{
				var xmlList:XMLList = new XMLList(loader.data);
				var classList:XMLList = xmlList.elements("productClass");
				var classLength:int=classList.length();
				for(var i:int=0;i<classLength;i++) {
					var productClassXML:XML=classList[i];
					var productClassVO :ProductClassElementData = new ProductClassElementData();
					productClassVO.classImg = productClassXML.attribute("imgUrl");
					
					var productList:XMLList = productClassXML.elements("product");
					var productLength:int=productList.length();
					for(var j:int=0;j<productLength;j++) {
						var productXML:XML=productList[j];
						var productVO:ProductElementData = new ProductElementData();
						//					productVO.productName = productXML.attribute("productName");
						
						var colorList:XMLList = productXML.elements("color");
						var colorLength:int=colorList.length();
						
						productVO.productFrontImg = (colorList[0] as XML).attribute("imgUrl");
						for(var k:int=0;k<colorLength;k++) {
							var colorXML:XML=colorList[k];
							var productColorVO:ProductColorElementData = new ProductColorElementData();
							//						productColorVO.colorName = colorXML.attribute("colorName");
							//						productColorVO.colorIcon = colorXML.attribute("colorIcon");
							productColorVO.imgUrl = colorXML.attribute("imgUrl");
							
							productVO.productColorImg.push(productColorVO);
						}
						
						var heatList:XMLList = productXML.elements("heat");
						var heatLength:int=heatList.length();
						for(var l:int=0;l<heatLength;l++) {
							var heatXML:XML=heatList[l];
							var productHeatVO:ProductHeatElementData = new ProductHeatElementData();
							productHeatVO.imgUrl = heatXML.attribute("imgUrl");
							
							productVO.productHeatImg.push(productHeatVO);
						}
						
						var pictureList:XMLList = productXML.elements("picture");
						var pictureLength:int=pictureList.length();
						for(var a:int=0;a<pictureLength;a++) {
							var pictureXML:XML=pictureList[a];
							var productPictureVO:ProductPictureElementData = new ProductPictureElementData();
							productPictureVO.imgUrl = pictureXML.attribute("imgUrl");
							productVO.productPicture.push(productPictureVO);
						}
						productClassVO.productListVO.push(productVO);
					}
					_model.productVector.push(productClassVO);
				}
				
				loader.removeEventListener(flash.events.Event.COMPLETE,loadDataHandler);
				loader.close();
				Starling.juggler.delayCall(initUI,1);
			});
			loader.load(new URLRequest("assets/images/productDataNew.xml"));
		}
		
		private function initUI():void
		{
			_model.starling = this.stage;
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
			expLeftPaneBtn.addEventListener(starling.events.Event.TRIGGERED,function ():void
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
			backBtn.addEventListener(starling.events.Event.TRIGGERED,function ():void
			{
				_model.starling.dispatchEvent(new starling.events.Event("backEvent"));
			});
			_model.backBtn = backBtn;
			this.addChild(backBtn);
			
			initUserAttentionList();
			
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
			
			_model.stage.removeChild(_model.logo);
		}
		
		private function remoteNotificationHandler(e:RemoteNotificationEvent):void
		{
			if(e.type == RemoteNotificationEvent.TOKEN) {
				_model.TOKEN_ID = e.tokenId;
				if(_model.TOKEN_ID) {
					(new AppService()).addRegistUser();
				}
			} else {
				var productDBData:ProductDBData = new ProductDBData();
				productDBData.productName = e.data["productName"];
				productDBData.currentLowestPrice = e.data["currentLowestPrice"];
				productDBData.activityEndDate = e.data["activityEndDate"];
				productDBData.tbUrl = e.data["tbUrl"];
				
				var sqlConnection:SQLConnection = new SQLConnection();
				sqlConnection.open(_model.DATABASE_FILE);
				var insertTable:SQLStatement = new SQLStatement();
				insertTable.sqlConnection = sqlConnection;
				
				insertTable.text = Properties.INSERT_FAV_PRODUCT_SQL;
				insertTable.parameters[":product_id"] =1;
				insertTable.parameters[":product_obj"] = productDBData;
				insertTable.parameters[":is_read"] = false;
				insertTable.execute();
				
				var selectTable:SQLStatement = new SQLStatement();
				selectTable.sqlConnection = sqlConnection;
				selectTable.text = Properties.SELECT_FAV_PRODUCT_SQL;
				selectTable.execute();
				var sqlResult:SQLResult = selectTable.getResult();
				var entries:Array = sqlResult.data;
			}
			
		}
		
		private function initUserAttentionList():void
		{
			var sqlConnection:SQLConnection = new SQLConnection();
			sqlConnection.open(_model.DATABASE_FILE);
			var insertTable:SQLStatement = new SQLStatement();
			
			var selectTable:SQLStatement = new SQLStatement();
			selectTable.sqlConnection = sqlConnection;
			selectTable.text = Properties.SELECT_FAV_PRODUCT_SQL;
			selectTable.execute();
			var sqlResult:SQLResult = selectTable.getResult();
			var entries:Array = sqlResult.data;
			
			var listContainer:ScrollContainer = new ScrollContainer();
			this.addChild(listContainer);
			const layout:VerticalLayout = new VerticalLayout();
			listContainer.layout = layout;
			listContainer.width = 300;
			listContainer.height = 300;
			listContainer.y = 300;
			
			if(!entries) return;
			var length:int = entries.length;
			for(var i:int=0;i<length;i++) {
				var userAttentionBox:UserAttenctionBox = new UserAttenctionBox();
				userAttentionBox.isRead = entries[i].is_read;
				var productDBData:ProductDBData = new ProductDBData();
				productDBData.productName = entries[i].product_obj["productName"];
				productDBData.currentLowestPrice = entries[i].product_obj["currentLowestPrice"];
				productDBData.activityEndDate = entries[i].product_obj["activityEndDate"];
				productDBData.tbUrl = entries[i].product_obj["tbUrl"];
				userAttentionBox.data = productDBData;
				userAttentionBox.width = 300;
				userAttentionBox.height = 50;
				listContainer.addChild(userAttentionBox);
			}
			
		}
		
	}
}