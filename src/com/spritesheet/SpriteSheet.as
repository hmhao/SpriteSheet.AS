package com.spritesheet {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.as3game.time.GameTimer;
	import com.spritesheet.textures.Texture;
	
	public class SpriteSheet extends Sprite {
		private var mTextures:Vector.<Texture>;
		private var mDurations:Vector.<Number>;
		private var mStartTimes:Vector.<Number>;
		
		private var mDefaultFrameDuration:Number;
		private var mCurrentTime:Number;
		private var mCurrentFrame:int;
		private var mLoop:Boolean;
		private var mPlaying:Boolean;
		
		private var mTexture:Texture;
		private var mCanvas:Bitmap;
		
		public function SpriteSheet(textures:Vector.<Texture>, fps:Number = 12) {
			if (textures.length > 0) {
				init(textures, fps);
			} else {
				throw new ArgumentError("Empty texture array");
			}
		}
		
		private function init(textures:Vector.<Texture>, fps:Number):void {
			if (fps <= 0)
				throw new ArgumentError("Invalid fps: " + fps);
			var numFrames:int = textures.length;
			
			mDefaultFrameDuration = 1.0 / fps;
			mLoop = true;
			mPlaying = true;
			mCurrentTime = 0.0;
			mCurrentFrame = 0;
			mTextures = textures.concat();
			mDurations = new Vector.<Number>(numFrames);
			mStartTimes = new Vector.<Number>(numFrames);
			
			for (var i:int = 0; i < numFrames; ++i) {
				mDurations[i] = mDefaultFrameDuration;
				mStartTimes[i] = i * mDefaultFrameDuration;
			}
			mCanvas = new Bitmap();
			this.addChild(mCanvas);
		}
		
		private function set texture(value:Texture):void {
			if (value == null) {
				throw new ArgumentError("Texture cannot be null");
			} else if (value != mTexture) {
				mTexture = value;
				mCanvas.bitmapData = mTexture.bitmapData;
			}
		}
		
		public function play():void {
			mPlaying = true;
			texture = mTextures[mCurrentFrame];
			GameTimer.getInstance().register(this.name, 1000 * mDefaultFrameDuration, 0, update);
		}
		
		public function stop():void {
			mPlaying = false;
			mCurrentFrame = 0;
			GameTimer.getInstance().unregister(this.name);
		}
		
		public function update(count:uint):void {
			mCurrentFrame++;
			if (mCurrentFrame >= mTextures.length) {
				if (mLoop) {
					mCurrentFrame = 0;
				} else {
					GameTimer.getInstance().unregister(this.name);
					return;
				}
			}
			texture = mTextures[mCurrentFrame];
		}
		
		/** Indicates if the clip should loop. */
		public function get loop():Boolean {
			return mLoop;
		}
		
		public function set loop(value:Boolean):void {
			mLoop = value;
		}
		
		/** The total number of frames. */
		public function get numFrames():int {
			return mTextures.length;
		}
		
		/** The index of the frame that is currently displayed. */
		public function get currentFrame():int {
			return mCurrentFrame;
		}
		
		/** The default number of frames per second. Individual frames can have different
		 *  durations. If you change the fps, the durations of all frames will be scaled
		 *  relatively to the previous value. */
		public function get fps():Number {
			return 1.0 / mDefaultFrameDuration;
		}
		
		/** Indicates if the clip is still playing. Returns <code>false</code> when the end
		 *  is reached. */
		public function get isPlaying():Boolean {
			if (mPlaying)
				return mLoop || mCurrentFrame < mTextures.length;
			else
				return false;
		}
	}
}