package com.sanrenxing.tb.vos
{
	[RemoteClass(alias="com.sanrenxing.vos.UserAttention")]
	[Bindable]
	public class UserAttentionVO
	{
		public var userDeviceId:String;
		public var productId:String;//淘宝中为item_id
		public var currentLowestPrice:int;
		public var attentionPrice:int;
		/**
		 * 用户关注商品状态
		 * -1 默认 未推送通知
		 * 0 已推送 未读通知
		 * 1 已推送 已读通知
		 */
		public var attentionStatus:int;
		
		public function UserAttentionVO()
		{
		}
	}
}