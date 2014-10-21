package com.as3game.spritesheet.analyze {
	import com.adobe.serialization.json.JSON;
	import com.as3game.spritesheet.SpriteFrame;
	
	/**
	 * 解析JSON格式的SpriteSheet数据描述文件
	 */
	public class JsonFormat {
		private var mMeta:Object;
		private var mFrames:Vector.<SpriteFrame>;
		private var mGroups:Object;
		
		public function JsonFormat(text:String) {
			var data:Object = com.adobe.serialization.json.JSON.decode(text);
			mMeta = data.meta;
			mFrames = new Vector.<SpriteFrame>();
			mGroups = {};
			
			var frames:Object = data.frames;
			var regex:RegExp = /^(.*?)(\d+)$/, 
				id:String, 
				index:int,
				match:Array,
				spriteFrame:SpriteFrame, 
				item:Object;
			for (var key:String in frames) {
				match = key.match(regex);
				if(match){
					id = match[1];
					index = parseInt(match[2]);
					if (!mGroups[id]) {
						mGroups[id] = [];
					}
					item = frames[key];
					spriteFrame = new SpriteFrame();
					spriteFrame.id = key;
					spriteFrame.x = item.frame.x;
					spriteFrame.y = item.frame.y;
					spriteFrame.width = item.frame.w;
					spriteFrame.height = item.frame.h;
					spriteFrame.offX = item.spriteSourceSize.x;
					spriteFrame.offY = item.spriteSourceSize.y;
					mGroups[id][index] = spriteFrame;
					mFrames.push(spriteFrame);
				}
			}
		}
		
		public function getData():Object {
			return {"meta": mMeta, "groups":mGroups, "frames": mFrames};
		}
	}
}