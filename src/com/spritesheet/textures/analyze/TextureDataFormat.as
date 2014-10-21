package com.spritesheet.textures.analyze {
	import com.adobe.serialization.json.JSON;
	import flash.utils.Dictionary;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	/**
	 * 解析SpriteSheet数据描述文件
	 * @author hmh
	 */
	public class TextureDataFormat {
		
		public static function JsonFormat(text:String):Dictionary {
			var data:Object = com.adobe.serialization.json.JSON.decode(text);
			var textureInfos:Dictionary = new Dictionary();
			var frames:Object = data.frames;
			var item:Object, region:Rectangle, offset:Point;
			for (var key:String in frames) {
				item = frames[key];
				region = new Rectangle(item.frame.x, item.frame.y, item.frame.w, item.frame.h);
				offset = new Point(item.spriteSourceSize.x, item.spriteSourceSize.y);
				textureInfos[key] = new TextureInfo(region, offset);
			}
			return textureInfos;
		}
		
		public static function JsonArrayFormat(text:String):Dictionary {
			var data:Object = com.adobe.serialization.json.JSON.decode(text);
			var textureInfos:Dictionary = new Dictionary();
			var frames:Object = data.frames;
			var item:Object, region:Rectangle, offset:Point;
			if (data.meta) {
				frames = data.frames;
				for each (item in frames) {
					region = new Rectangle(item.frame.x, item.frame.y, item.frame.w, item.frame.h);
					offset = new Point(item.spriteSourceSize.x, item.spriteSourceSize.y);
					textureInfos[item.filename] = new TextureInfo(region, offset);
				}
			} else {
				frames = data;
				for (var name:String in frames) {
					for each (item in frames[name]) {
						region = new Rectangle(item.x, item.y, item.w, item.h);
						offset = new Point(0, 0);
						textureInfos[name] = new TextureInfo(region, offset);
					}
				}
			}
			return textureInfos;
		}
		
		public static function XmlFormat(xml:XML):Dictionary {
			var xmlList:XMLList = xml.SubTexture;
			var textureInfos:Dictionary = new Dictionary();
			var region:Rectangle, offset:Point;
			for (var i:int = 0; i < xmlList.length(); i++) {
				region = new Rectangle(int(xmlList[i].@x), int(xmlList[i].@y), int(xmlList[i].@width), int(xmlList[i].@height));
				offset = new Point(-1 * int(xmlList[i].@frameX), -1 * int(xmlList[i].@frameY));
				textureInfos[String(xmlList[i].@name)] = new TextureInfo(region, offset);
			}
			return textureInfos;
		}
	}
}