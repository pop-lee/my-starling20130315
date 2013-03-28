package com.sanrenxing.tb.services
{
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.utils.Properties;
	import com.sanrenxing.tb.vos.ResultObject;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class AppService extends AbstractService
	{
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		public function AppService()
		{
			this.destination = "appService";
		}
		
		public function addRegistUser():void
		{
			var call:AsyncToken;
			call = this.getServiceInstance().addRegistUser(_model.TOKEN_ID);
			call.addResponder(this.getResponsder(addRegistUserResult));
			
			function addRegistUserResult(event:ResultEvent):void
			{
				trace("addRegistUserSuccess");
			}
		}
		
		public function addUserAttention(productId:String):void
		{
			var call:AsyncToken;
			call = this.getServiceInstance().addUserAttention(_model.TOKEN_ID,productId);
			call.addResponder(this.getResponsder(addUserAttentionResult));
			
			function addUserAttentionResult(event:ResultEvent):void
			{
				if(event.result.resultCode == 0) { //success
					var productId:String = event.result.resultData as String;
					
					var sqlConnection:SQLConnection = new SQLConnection();
					sqlConnection.open(_model.DATABASE_FILE);
					var insertTable:SQLStatement = new SQLStatement();
					insertTable.sqlConnection = sqlConnection;
					
					insertTable.text = Properties.INSERT_ATTENTION_PRODUCT_SQL;
					insertTable.parameters[":product_id"] =productId;
					insertTable.parameters[":attention_date"] = new Date();
					insertTable.execute();
					
					var selectTable:SQLStatement = new SQLStatement();
					selectTable.sqlConnection = sqlConnection;
					selectTable.text = Properties.SELECT_ATTENTION_PRODUCT_SQL;
					selectTable.execute();
					var sqlResult:SQLResult = selectTable.getResult();
					var entries:Array = sqlResult.data;
				}
				trace("addRegistUserSuccess");
			}
		}
		
	}
}