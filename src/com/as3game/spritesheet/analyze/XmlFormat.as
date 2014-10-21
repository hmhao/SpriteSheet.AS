package com.as3game.spritesheet.analyze {
	import com.as3game.spritesheet.SpriteFrame;
	
	/**
	 * 解析XML格式的SpriteSheet数据描述文件
	 * @author Tylerzhu
	 */
	public class XmlFormat {
		private var mMeta:Object;
		private var mFrames:Vector.<SpriteFrame>;
		private var mGroups:Object;
		
		public function XmlFormat(xml:XML) {
			mFrames = new Vector.<SpriteFrame>();
			mGroups = {};
			var xmlList:XMLList = xml.SubTexture,
				regex:RegExp = /^(.*?)(\d+)$/, 
				id:String, 
				index:int,
				match:Array,
				spriteFrame:SpriteFrame;
			for (var i:int = 0; i < xmlList.length(); i++) {
				match = String(xmlList[i].@name).match(regex);
				if(match){
					id = match[1];
					index = parseInt(match[2]);
					if (!mGroups[id]) {
						mGroups[id] = [];
					}
					spriteFrame = new SpriteFrame();
					spriteFrame.id = String(xmlList[i].@name);
					spriteFrame.x = int(xmlList[i].@x);
					spriteFrame.y = int(xmlList[i].@y);
					spriteFrame.width = int(xmlList[i].@width);
					spriteFrame.height = int(xmlList[i].@height);
					spriteFrame.offX = -1 * int(xmlList[i].@frameX);
					spriteFrame.offY = -1 * int(xmlList[i].@frameY);
					spriteFrame.centerX = Number(xmlList[i].@centerX);
					spriteFrame.centerY = Number(xmlList[i].@centerY);
					mGroups[id][index] = spriteFrame;
					mFrames.push(spriteFrame);
				}
			}
		}
		
		public function getData():Object {
			return {"meta": mMeta, "groups": mGroups, "frames": mFrames};
		}
	
	}

}