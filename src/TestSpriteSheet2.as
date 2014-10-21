package {
	import com.as3game.asset.AssetManager;
	import com.spritesheet.textures.Texture;
	import com.spritesheet.textures.TextureAtlas;
	import com.spritesheet.textures.analyze.DataType;
	import com.spritesheet.SpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TestSpriteSheet2 extends Sprite {
		private var assetManager:AssetManager;
		
		public function TestSpriteSheet2() {
			SWFProfiler.init(stage, this);
			assetManager = AssetManager.getInstance();
			
			
			assetManager.getGroupAssets("spritesheets-json", ["data/json/jsonformat.json", "data/json/jsonformat.png"], onAnimLoaded);
			assetManager.getGroupAssets("spritesheets-xml", ["data/xml/xmlformat.xml", "data/xml/xmlformat.png"], onAnimLoadedXML);
			assetManager.getGroupAssets("spritesheets-jsonarray1", ["data/json-array/jsonarrayformat.json", "data/json-array/jsonarrayformat.png"], onAnimLoadedJsonArray1);
			
			assetManager.getGroupAssets("spritesheets-jsonarray2", ["data/json-array/xlbird.json", "data/json-array/xlbird.png"], onAnimLoadedJsonArray2);
		}
		
		private function onAnimLoaded():void {
			var bitmapData:BitmapData = assetManager.bulkLoader.getBitmapData("data/json/jsonformat.png");
			var atlas:* = assetManager.getContent("data/json/jsonformat.json");
			var textureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(bitmapData), atlas, DataType.FORMAT_JSON);
			var sp:SpriteSheet = new SpriteSheet(textureAtlas.getTextures("呼吸"), 15);
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("打击"), 14);
			sp.x = 100;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("左行走"), 14);
			sp.x = 250;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("挨打"), 14);
			sp.x = 400;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("攻击"), 14);
			sp.x = 550;
			sp.play();
			addChild(sp);
		}
		
		private function onAnimLoadedXML():void {
			var bitmapData:BitmapData = assetManager.bulkLoader.getBitmapData("data/xml/xmlformat.png");
			var atlas:* = assetManager.getContent("data/xml/xmlformat.xml");
			var textureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(bitmapData), atlas, DataType.FORMAT_XML);
			var sp:SpriteSheet = new SpriteSheet(textureAtlas.getTextures("呼吸"), 15);
			sp.y = 150;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("打击"), 14);
			sp.x = 100;
			sp.y = 150;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("左行走"), 14);
			sp.x = 250;
			sp.y = 150;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("挨打"), 14);
			sp.x = 400;
			sp.y = 150;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("攻击"), 14);
			sp.x = 550;
			sp.y = 150;
			sp.play();
			addChild(sp);
		}
		
		private function onAnimLoadedJsonArray1():void {
			var bitmapData:BitmapData = AssetManager.getInstance().bulkLoader.getBitmapData("data/json-array/jsonarrayformat.png");
			var atlas:* = AssetManager.getInstance().getContent("data/json-array/jsonarrayformat.json");
			var textureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(bitmapData), atlas, DataType.FORMAT_JSON_ARRAY);
			var sp:SpriteSheet = new SpriteSheet(textureAtlas.getTextures("呼吸"), 15);
			sp.y = 280;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("打击"), 14);
			sp.x = 100;
			sp.y = 280;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("左行走"), 14);
			sp.x = 250;
			sp.y = 280;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("挨打"), 14);
			sp.x = 400;
			sp.y = 280;
			sp.play();
			addChild(sp);
			
			sp = new SpriteSheet(textureAtlas.getTextures("攻击"), 14);
			sp.x = 550;
			sp.y = 280;
			sp.play();
			addChild(sp);
		}
		
		private function onAnimLoadedJsonArray2():void {
			var bitmapData:BitmapData = assetManager.bulkLoader.getBitmapData("data/json-array/xlbird.png");
			var atlas:* = assetManager.getContent("data/json-array/xlbird.json");
			var textureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmapData(bitmapData), atlas, DataType.FORMAT_JSON_ARRAY);
			var prefixs:Vector.<String> = textureAtlas.getPrefixs();
			var sp:SpriteSheet;
			for (var i:int = 0, len:int = prefixs.length; i < len; i++ ) {
				sp = new SpriteSheet(textureAtlas.getTextures(prefixs[i]), 8);
				sp.x = 38 * i + 1;
				sp.y = 400;
				sp.play();
				addChild(sp);
			}
		}
	}
}