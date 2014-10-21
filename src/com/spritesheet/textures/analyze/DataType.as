package com.spritesheet.textures.analyze {
	
	/**
	 * 与Flash cs导出的数据格式对应，目前实现了以下3种
	 * 	1. JSON
	 * 	2. JSON-Array
	 * 	3. XML
	 */
	public class DataType {
		public static const FORMAT_JSON:String = "format_json";
		public static const FORMAT_JSON_ARRAY:String = "format_json_array";
		public static const FORMAT_XML:String = "format_xml";
		
		public function DataType() {
		
		}
	}
}