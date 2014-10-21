package com.spritesheet.textures {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import com.spritesheet.errors.AbstractClassError;
	import com.spritesheet.utils.getNextPowerOfTwo;
	/**
	 * @author hmh
	 */
	public class Texture {
		public var bitmapData:BitmapData;
		public var width:int;
		public var height:int;
		
		public function Texture() {
			
		}
		
		public function dispose():void {
			bitmapData.dispose();
			bitmapData = null;
		}
		
		/** 从任意支持的数据类型创建一个texture对象.
		 *
		 *  @param data:    嵌入的资源类,位图或位图数据.
		 */
		public static function fromData(data:Object):Texture {
			var texture:Texture = null;
			
			if (data is Bitmap)
				data = (data as Bitmap).bitmapData;
			
			if (data is Class) {
				texture = fromEmbeddedAsset(data as Class);
			} else if (data is BitmapData) {
				texture = fromBitmapData(data as BitmapData);
			} else
				throw new ArgumentError("Unsupported 'data' type: " + getQualifiedClassName(data));
			
			return texture;
		}
		
		/** 从嵌入的资源类创建一个texture对象.
		 *
		 *  @param assetClass: 必须是一个位图.
		 */
		public static function fromEmbeddedAsset(assetClass:Class):Texture {
			var texture:Texture;
			var asset:Object = new assetClass();
			
			if (asset is Bitmap) {
				texture = Texture.fromBitmap(asset as Bitmap);
			} else {
				throw new ArgumentError("Invalid asset type: " + getQualifiedClassName(asset));
			}
			
			asset = null; // 避免对象保持在内存
			return texture;
		}
		
		/** 从一个位图创建一个texture对象.
		 *
		 *  @param bitmap:  texture对象将由此位图的数据创建.
		 */
		public static function fromBitmap(bitmap:Bitmap):Texture {
			return fromBitmapData(bitmap.bitmapData);
		}
		
		/** 从一个位图数据创建一个texture对象.
		 *
		 *  @param data:  texture对象将由此位图数据创建.
		 */
		public static function fromBitmapData(data:BitmapData):Texture {
			var texture:Texture = Texture.empty(data.width, data.height);
			texture.bitmapData = data;
			return texture;
		}
		
		/** 从给定的texture中创建一个指定区（像素）的subtexture.
		 * 	新的subtexture将参考texture,没有数据重复. */
		public static function fromTexture(texture:Texture, region:Rectangle, offset:Point):Texture {
			region.width += offset.x;
			region.height += offset.y;
			var subTexture:Texture = Texture.empty(region.width, region.height);
			var bitmapData:BitmapData = new BitmapData(region.width, region.height, true, 0);
			bitmapData.copyPixels(texture.bitmapData, region, offset);
			subTexture.bitmapData = bitmapData;
			return subTexture;
		}
		
		/** 创建一个指定尺寸的空.
		 *
		 *  @param width:  宽.
		 *  @param height: 高.
		 */
		public static function empty(width:Number, height:Number):Texture {
			var actualWidth:int, actualHeight:int;
			var origWidth:int = width;
			var origHeight:int = height;
			var potWidth:int = getNextPowerOfTwo(origWidth);
			var potHeight:int = getNextPowerOfTwo(origHeight);
			
			var texture:Texture = new Texture();
			texture.width = origWidth;
			texture.height = origHeight;
			/*texture.width = potWidth;
			 texture.height = potHeight;*/
			return texture;
		}
	}
}