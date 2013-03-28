package com.sanrenxing.tb.models
{
	import com.sanrenxing.tb.components.ColorButton;
	import com.sanrenxing.tb.components.UserAttenctionBox;
	import com.sanrenxing.tb.utils.Assets;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	public class CustomComponentTheme extends MetalWorksMobileTheme
	{
//		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 50, 50);
		protected static const COLOR_PANE_SCALE9_GRID:Rectangle = new Rectangle(12, 66, 112, 380);
		
		public static const MAIN_BACKGROUND:String = "mainBackGround";
		public static const BACK_BTN:String = "backBtn";
		public static const EXP_LEFT_PANE_BTN:String = "expLeftPaneBtn";
		public static const CONTROL_PANE_BACKGROUND:String = "controlPaneBackground";
		public static const ATTENTION_BTN:String = "attentionBtn";
		public static const COLOR_PANE_BACKGROUND:String = "colorPaneBackground";
		
		public static const CLASS_BG:String = "classBG";
		
		public var backButtonUpSkinTextures:Texture;
		public var backButtonDownSkinTextures:Texture;
		
		public function CustomComponentTheme( root:DisplayObjectContainer, scaleToDPI:Boolean = true )
		{
			super( root, scaleToDPI );
		}
		
		override protected function initializeRoot():void
		{
//			this.primaryBackgroundTexture = Assets.getTexture("MAIN_BG");
			super.initializeRoot();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// set new initializers here
			
			//set screen bg
			this.setInitializerForClass( ScrollContainer, classScreenBackgroundInitializer,CLASS_BG);
			
			this.setInitializerForClass(UserAttenctionBox, buttonInitializer);
			this.setInitializerForClass( Button, backButtonInitializer, BACK_BTN );
			this.setInitializerForClass( Button, expLeftPaneBtnInitializer,EXP_LEFT_PANE_BTN);
//			this.setInitializerForClass( ScrollContainer, mainBackgroundInitializer, MAIN_BACKGROUND );
			this.setInitializerForClass( ScrollContainer, controlPaneBackgroundInitializer, CONTROL_PANE_BACKGROUND );
			this.setInitializerForClass( ScrollContainer, colorPaneBackgroundInitializer, COLOR_PANE_BACKGROUND );
			
			this.setInitializerForClass( Button, attentionBtnInitializer, ATTENTION_BTN );
			this.setInitializerForClass( ColorButton, colorButtonInitializer );
		}
		
		public function classScreenBackgroundInitializer(container:ScrollContainer):void
		{
			container.backgroundSkin = new Image(Assets.getTexture("CLASS_BG"));
		}
		
		public function backButtonInitializer(button:Button):void
		{
//			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
//			skinSelector.defaultValue = this.buttonDisabledSkinTextures;
//			skinSelector.setValueForState(this.buttonUpSkinTextures, Button.STATE_DOWN, false);
//			skinSelector.imageProperties = 
//				{
//					width: 60 * this.scale,
//					height: 60 * this.scale,
//					textureScale: this.scale
//				};
//			button.stateToSkinFunction = skinSelector.updateValue;
			button.defaultSkin = new Image(Assets.getTexture("BACK_BTN_UP"));
			button.downSkin = new Image(Assets.getTexture("BACK_BTN_DOWN"));
		}
		
		public function expLeftPaneBtnInitializer(button:Button):void
		{
			button.defaultSkin = new Image(Assets.getTexture("EXP_LEFT_PANE_BTN"));
//			button.downSkin = new Image(Assets.getTexture("CLOSE_LEFT_PANE_BTN"));
		}
		
		public function mainBackgroundInitializer(container:ScrollContainer):void
		{
			container.backgroundSkin = new TiledImage(Assets.getTexture("MAIN_BG"));
		}
		
		public function controlPaneBackgroundInitializer(container:ScrollContainer):void
		{
			container.backgroundSkin = new Image(Assets.getTexture("CONTROL_PANE_BG"));
		}
		
		public function colorPaneBackgroundInitializer(container:ScrollContainer):void
		{
			container.backgroundSkin = new Scale9Image(new Scale9Textures(Assets.getTexture("COLOR_PANE_BG"), COLOR_PANE_SCALE9_GRID));
		}
		
		public function attentionBtnInitializer(button:Button):void
		{
			button.defaultSkin = new Image(Assets.getTexture("ATTENTION_BTN_UP"));
			button.selectedDownSkin =  new Image(Assets.getTexture("ATTENTION_BTN_UP"));
			button.downSkin = new Image(Assets.getTexture("ATTENTION_BTN_DOWN"));
			button.selectedUpSkin = new Image(Assets.getTexture("ATTENTION_BTN_DOWN"));
		}
		
		public function colorButtonInitializer(button:ColorButton):void
		{
			button.defaultSkin = new Image(Assets.getTexture(button.colorIcon));
		}
		
	}
}