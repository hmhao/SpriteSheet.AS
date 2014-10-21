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
	
	public class Texture {
		public var bitmapData:BitmapData;
		public var width:int;
		public var height:int;
		
		/** @private */
		public function Texture() {
			
		}
		
		public function dispose():void {
			bitmapData.dispose();
			bitmapData = null;
		}
		
		/** Creates a texture object from any of the supported data types, using the specified
		 *  options.
		 *
		 *  @param data:    Either an embedded asset class, a Bitmap, BitmapData.
		 *  @param options: Specifies options about the texture settings, e.g. scale factor.
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
		
		/** Creates a texture object from an embedded asset class.
		 *
		 *  @param assetClass: must contain either a Bitmap or a ByteArray with ATF data.
		 */
		public static function fromEmbeddedAsset(assetClass:Class):Texture {
			var texture:Texture;
			var asset:Object = new assetClass();
			
			if (asset is Bitmap) {
				texture = Texture.fromBitmap(asset as Bitmap);
			} else {
				throw new ArgumentError("Invalid asset type: " + getQualifiedClassName(asset));
			}
			
			asset = null; // avoid that object stays in memory (through 'onRestore' functions)
			return texture;
		}
		
		/** Creates a texture object from a bitmap.
		 *
		 *  @param bitmap:  the texture will be created with the bitmap data of this object.
		 */
		public static function fromBitmap(bitmap:Bitmap):Texture {
			return fromBitmapData(bitmap.bitmapData);
		}
		
		/** Creates a texture object from bitmap data.
		 *  Beware: you must not dispose 'data' if Starling should handle a lost device context;
		 *  alternatively, you can handle restoration yourself via "texture.root.onRestore".
		 *
		 *  @param data:  the texture will be created with the bitmap data of this object.
		 */
		public static function fromBitmapData(data:BitmapData):Texture {
			var texture:Texture = Texture.empty(data.width, data.height);
			texture.bitmapData = data;
			return texture;
		}
		
		/** Creates a texture that contains a region (in pixels) of another texture. The new
		 *  texture will reference the base texture; no data is duplicated. */
		public static function fromTexture(texture:Texture, region:Rectangle, offset:Point):Texture {
			region.width += offset.x;
			region.height += offset.y;
			var subTexture:Texture = Texture.empty(region.width, region.height);
			var bitmapData:BitmapData = new BitmapData(region.width, region.height, true, 0);
			bitmapData.copyPixels(texture.bitmapData, region, offset);
			subTexture.bitmapData = bitmapData;
			return subTexture;
		}
		
		/** Creates an empty texture of a certain size.
		 *  Beware that the texture can only be used after you either upload some color data
		 *  ("texture.root.upload...") or clear the texture ("texture.root.clear()").
		 *
		 *  @param width:  in points; number of pixels depends on scale parameter
		 *  @param height: in points; number of pixels depends on scale parameter
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