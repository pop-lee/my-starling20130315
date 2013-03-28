package com.sanrenxing.tb.vos
{
	[RemoteClass(alias="com.sanrenxing.utils.ResultObject")]
	[Bindable]
	public class ResultObject
	{
		public var resultCode:int;
		public var resultData:Object;
		
		public function ResultObject()
		{
		}
	}
}