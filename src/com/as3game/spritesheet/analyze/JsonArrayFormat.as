package com.as3game.spritesheet.analyze {
	import com.adobe.serialization.json.JSON;
	import com.as3game.spritesheet.SpriteFrame;
	
	/**
	 * 解析JSON Array格式的SpriteSheet数据描述文件
	 * @author Tylerzhu
	 */
	public class JsonArrayFormat {
		private var mMeta:Object;
		private var mFrames:Vector.<SpriteFrame>;
		private var mGroups:Object;
		
		public function JsonArrayFormat(text:String) {
			var data:Object = com.adobe.serialization.json.JSON.decode(text);
			mMeta = data.meta;
			mFrames = new Vector.<SpriteFrame>();
			mGroups = {};
			var regex:RegExp = /^(.*?)(\d+)$/, 
				id:String, 
				index:int, 
				match:Array, 
				spriteFrame:SpriteFrame, 
				item:Object,
				frames:Object;
			if (mMeta) {
				frames = data.frames;
				for each (item in frames) {
					match = item.filename.match(regex);
					if (match) {
						id = match[1];
						index = parseInt(match[2]);
						if (!mGroups[id]) {
							mGroups[id] = [];
						}
						spriteFrame = new SpriteFrame();
						spriteFrame.id = item.filename;
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
			} else {
				frames = data;
				for (id in frames) {
					mGroups[id] = [];
					for (var i:int = 0; i < frames[id].length; i++) {
						item = frames[id][i];
						spriteFrame = new SpriteFrame();
						spriteFrame.id = id;
						spriteFrame.x = item.x;
						spriteFrame.y = item.y;
						spriteFrame.width = item.w;
						spriteFrame.height = item.h;
						spriteFrame.offX = 0;
						spriteFrame.offY = 0;
						mGroups[id].push(spriteFrame);
						mFrames.push(spriteFrame);
					}
				}
			}
		}
		
		public function getData():Object {
			return {"meta": mMeta, "groups":mGroups, "frames": mFrames};
		}
	}

}