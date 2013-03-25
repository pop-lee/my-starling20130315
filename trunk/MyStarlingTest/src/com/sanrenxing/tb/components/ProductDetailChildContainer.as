package com.sanrenxing.tb.components
{
	import feathers.controls.ScrollContainer;
	
	public class ProductDetailChildContainer extends ScrollContainer
	{
		public var parentContainer:ProductDetailContainer;
		
		public var isInitilized:Boolean = false;
		
		public function ProductDetailChildContainer()
		{
			super();
		}
		
		public function init():void
		{
			if(isInitilized) return;
			isInitilized = true;
		}
	}
}