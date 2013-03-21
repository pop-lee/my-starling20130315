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
		
		public static const CREATE_FAV_PRODUCT_SQL:String =
			"CREATE TABLE IF NOT EXISTS`app_product_attention` (" +
			"`product_id` INTEGER NOT NULL," + 
			"`product_obj` OBJECT DEFAULT NULL," + 
			"`is_read` BOOLEAN DEFAULT NULL," +
			"PRIMARY KEY (`product_id`)" + 
			");";
		
		public static const INSERT_FAV_PRODUCT_SQL:String = 
			"INSERT INTO `app_product_attention`(" + 
			"`product_id`, " + 
			"`product_obj`, " + 
			"`is_read`)" + 
			"VALUES (" + 
			":product_id," +
			":product_obj," +
			":is_read);";
		
		public static const SELECT_FAV_PRODUCT_SQL:String = 
			"SELECT" + 
			"`product_id`, " + 
			"`product_obj`, " + 
			"`is_read`" + 
			"FROM `app_product_attention`";
		
		public function Properties()
		{
		}
	}
}