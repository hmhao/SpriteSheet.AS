package com.spritesheet.textures {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import com.spritesheet.textures.analyze.*;
	/**
	 * 动画序列帧数据
	 * @author hmh
	 */
	public class TextureAtlas {
		private var mAtlasTexture:Texture;
		private var mTextureInfos:Dictionary;
		
		/** helper objects */
		private static var sNames:Vector.<String> = new <String>[];
		
		/** 通过解析文件中的区域集来创建一个texture的texture atlas. */
		public function TextureAtlas(texture:Texture, atlas:*, dataType:String) {
			mAtlasTexture = texture;
			switch (dataType) {
				case DataType.FORMAT_JSON: 
					mTextureInfos = TextureDataFormat.JsonFormat(atlas as String);
					break;
				case DataType.FORMAT_JSON_ARRAY: 
					mTextureInfos = TextureDataFormat.JsonArrayFormat(atlas as String);
					break;
				case DataType.FORMAT_XML: 
					mTextureInfos = TextureDataFormat.XmlFormat(atlas as XML);
					break;
				default: 
			}
		}
		
		/** 销毁atlas的texture. */
		public function dispose():void {
			mAtlasTexture.dispose();
		}
		
		/** 按name检索一个texture。如果没找到则返回null. */
		public function getTexture(name:String):Texture {
			var info:TextureInfo = mTextureInfos[name];
			if (info == null)
				return null;
			else
				return Texture.fromTexture(mAtlasTexture, info.region, info.offset);
		}
		
		/** 返回指定前缀名的所有textures, 按字母顺序排列. */
		public function getTextures(prefix:String = "", result:Vector.<Texture> = null):Vector.<Texture> {
			if (result == null)
				result = new <Texture>[];
			for each (var name:String in getNames(prefix, sNames))
				result.push(getTexture(name));
			sNames.length = 0;
			return result;
		}
		
		/** 返回指定前缀名的所有names, 按字母顺序排列. */
		public function getNames(prefix:String = "", result:Vector.<String> = null):Vector.<String> {
			if (result == null)
				result = new <String>[];
			for (var name:String in mTextureInfos)
				if (name.indexOf(prefix) == 0)
					result.push(name);
			result.sort(function(a:String, b:String):int {
				var regex:RegExp = /^(.*?)(\d+)$/, i:int, j:int, match:Array;
				match = a.match(regex);
				match && (i = int(match[2]));
				match = b.match(regex);
				match && (j = int(match[2]));
				return i > j ? 1 : -1;
			});
			return result;
		}
		
		/** 返回所有唯一的prefix. */
		public function getPrefixs():Vector.<String> {
			var result:Vector.<String> = new <String>[];
			var regex:RegExp = /^(.*?)(\d+)$/, prefix:String, match:Array;
			for (var name:String in mTextureInfos) {
				match = name.match(regex);
				if (match && result.indexOf(match[1]) == -1) {
					result.push(match[1]);
				}
			}
			result.sort(Array.CASEINSENSITIVE);
			return result;
		}
		
		/** 返回指定name关联的矩形区域. */
		public function getRegion(name:String):Rectangle {
			var info:TextureInfo = mTextureInfos[name];
			return info ? info.region : null;
		}
		
		/** 返回指定name关联的偏移点. */
		public function getOffset(name:String):Point {
			var info:TextureInfo = mTextureInfos[name];
			return info ? info.offset : null;
		}
		
		/** atlas的基本texture. */
		public function get texture():Texture {
			return mAtlasTexture;
		}
	}
}