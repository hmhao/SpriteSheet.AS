package com.spritesheet.textures {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import com.spritesheet.textures.analyze.*;
	/**
	 * 动画序列帧数据
	 */
	public class TextureAtlas {
		private var mAtlasTexture:Texture;
		private var mTextureInfos:Dictionary;
		
		/** helper objects */
		private static var sNames:Vector.<String> = new <String>[];
		
		/** Create a texture atlas from a texture by parsing the regions from a file. */
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
		
		/** Disposes the atlas texture. */
		public function dispose():void {
			mAtlasTexture.dispose();
		}
		
		/** Retrieves a subtexture by name. Returns <code>null</code> if it is not found. */
		public function getTexture(name:String):Texture {
			var info:TextureInfo = mTextureInfos[name];
			if (info == null)
				return null;
			else
				return Texture.fromTexture(mAtlasTexture, info.region, info.offset);
		}
		
		/** Returns all textures that start with a certain string, sorted alphabetically. */
		public function getTextures(prefix:String = "", result:Vector.<Texture> = null):Vector.<Texture> {
			if (result == null)
				result = new <Texture>[];
			for each (var name:String in getNames(prefix, sNames))
				result.push(getTexture(name));
			sNames.length = 0;
			return result;
		}
		
		/** Returns all texture names that start with a certain string, sorted alphabetically. */
		public function getNames(prefix:String = "", result:Vector.<String> = null):Vector.<String> {
			if (result == null)
				result = new <String>[];
			for (var name:String in mTextureInfos)
				if (name.indexOf(prefix) == 0)
					result.push(name);
			result.sort(Array.CASEINSENSITIVE);
			return result;
		}
		
		/** Returns the region rectangle associated with a specific name. */
		public function getRegion(name:String):Rectangle {
			var info:TextureInfo = mTextureInfos[name];
			return info ? info.region : null;
		}
		
		/** Returns the offset point associated with a specific name. */
		public function getOffset(name:String):Point {
			var info:TextureInfo = mTextureInfos[name];
			return info ? info.offset : null;
		}
		
		/** The base texture that makes up the atlas. */
		public function get texture():Texture {
			return mAtlasTexture;
		}
	}
}