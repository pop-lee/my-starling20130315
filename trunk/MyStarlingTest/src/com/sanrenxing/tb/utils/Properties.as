package com.sanrenxing.tb.utils
{
	public class Properties
	{
//		public static const CREATE_SQL:String = 
//			"CREATE TABLE IF NOT EXISTS`app_user_attention` (" +
//			"`product_id` INTEGER NOT NULL," + 
//			"`product_name` TEXT DEFAULT NULL," + 
//			"`current_lowest_price` INTEGER DEFAULT NULL," + 
//			"`activity_end_date` DATA DEFAULT NULL," + 
//			"`tb_url` TEXT DEFAULT NULL," + 
//			"PRIMARY KEY (`product_id`)" + 
//			");";
		
		public static const DROP_PUSH_NOTIFICATION_TABLE_SQL:String = 
			"drop table `app_push_notification`;";
		
		public static const DROP_PRODUCT_ATTENTION_TABLE_SQL:String = 
			"drop table `app_user_attention`;";
		
		public static const CREATE_NOTIFICATION_PRODUCT_SQL:String =
			"CREATE TABLE IF NOT EXISTS`app_push_notification` (" +
			"`product_id` INTEGER NOT NULL," + 
			"`product_obj` OBJECT DEFAULT NULL," + 
			"`is_read` BOOLEAN DEFAULT NULL," +
			"PRIMARY KEY (`product_id`)" + 
			");";
		
		public static const INSERT_NOTIFICATION_PRODUCT_SQL:String = 
			"INSERT INTO `app_push_notification`(" + 
			"`product_id`, " + 
			"`product_obj`, " + 
			"`is_read`)" + 
			"VALUES (" + 
			":product_id," +
			":product_obj," +
			":is_read);";
		
		public static const SELECT_NOTIFICATION_PRODUCT_SQL:String = 
			"SELECT" + 
			"`product_id`, " + 
			"`product_obj`, " + 
			"`is_read`" + 
			"FROM `app_push_notification`";
		
		
		public static const CREATE_UAER_ATTENTION_SQL:String =
			"CREATE TABLE IF NOT EXISTS`app_user_attention` (" +
			"`product_id` varchar(70) NOT NULL," + 
			"`attention_date` datetime DEFAULT NULL," + 
			"PRIMARY KEY (`product_id`)" + 
			");";
		
		public static const INSERT_ATTENTION_PRODUCT_SQL:String = 
			"INSERT INTO `app_user_attention`(" + 
			"`product_id`, " +  
			"`attention_date`)" + 
			"VALUES (" + 
			":product_id," +
			":attention_date);";
		
		public static const SELECT_ATTENTION_PRODUCT_SQL:String = 
			"SELECT" + 
			"`product_id`, " + 
			"`attention_date`" + 
			"FROM `app_user_attention`";
		
		public static const SELECT_ATTENTION_PRODUCT_BY_PRODUCTID_SQL:String = 
			"SELECT" + 
			"`product_id`, " + 
			"`attention_date`" + 
			"FROM `app_user_attention`" +
			"WHERE `product_id`= :product_id;";
		
		public function Properties()
		{
		}
	}
}