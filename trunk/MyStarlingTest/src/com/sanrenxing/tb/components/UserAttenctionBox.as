package com.sanrenxing.tb.components
{
	import com.sanrenxing.tb.utils.Assets;
	import com.sanrenxing.tb.vos.ProductDBData;
	
	import feathers.controls.Button;
	import feathers.events.FeathersEventType;
	
	import starling.display.Image;
	import starling.events.Event;
	
	public class UserAttenctionBox extends Button
	{
		public var data:ProductDBData;
		
		private var _isRead:Boolean;
		
		public var isReadIcon:Image;
		
		public function UserAttenctionBox()
		{
			super();
			
			this.isToggle = false;
		}
		
		override protected function initialize():void
		{
			this.label = data.productName;
			
			this.addEventListener(Event.TRIGGERED,clickhandler);
			
			super.initialize();
		}
		
		override protected function draw():void {
			super.draw();
		}
		
		public function set isRead(value:Boolean):void
		{
			if(value) {
				if(isReadIcon) {
					this.removeChild(isReadIcon);
					isReadIcon = null;
				}
			} else {
				isReadIcon = new Image(Assets.getTexture("T"));
				this.addChild(isReadIcon);
			}
		}
		public function get isRead():Boolean
		{
			return _isRead;
		}
		
		private function clickhandler(event:Event):void
		{
			if(this.isSelected) {
				this.isSelected = false;
				closeBtn();
			} else {
				this.isSelected = true;
				expBtn();
				this.dispatchEvent(new starling.events.Event(FeathersEventType.RESIZE,false));
			}
		}
		
		public function expBtn():void
		{
			if(!_isRead) {
				isRead = true;
			}
			this.height = 100;
		}
		
		public function closeBtn():void
		{
			this.height = 50;
		}
	}
}