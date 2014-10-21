package com.spritesheet.textures.analyze {
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author hmh
	 */
	public class TextureInfo {
		public var region:Rectangle;
		public var offset:Point;
		
		public function TextureInfo(region:Rectangle, offset:Point) {
			this.region = region;
			this.offset = offset;
		}
	}
}