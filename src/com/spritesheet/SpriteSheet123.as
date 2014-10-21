package com.spritesheet {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.as3game.time.GameTimer;
	import com.spritesheet.textures.Texture;
	
	public class SpriteSheet123 extends Sprite {
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
		
		public function SpriteSheet123(textures:Vector.<Texture>, fps:Number = 12) {
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
		
		/** Returns the texture of a certain frame. */
		public function getFrameTexture(frameID:int):Texture {
			if (frameID < 0 || frameID >= numFrames)
				throw new ArgumentError("Invalid frame id");
			return mTextures[frameID];
		}
		
		/** Returns the duration of a certain frame (in seconds). */
		public function getFrameDuration(frameID:int):Number {
			if (frameID < 0 || frameID >= numFrames)
				throw new ArgumentError("Invalid frame id");
			return mDurations[frameID];
		}
		
		public function play():void {
			mPlaying = true;
			GameTimer.getInstance().register(this.name, 1000 * mDefaultFrameDuration, 0, update);
		}
		
		public function pause():void {
			mPlaying = false;
			GameTimer.getInstance().unregister(this.name);
		}
		
		public function stop():void {
			mPlaying = false;
			currentFrame = 0;
			GameTimer.getInstance().unregister(this.name);
		}
		
		private function updateStartTimes():void {
			var numFrames:int = this.numFrames;
			
			mStartTimes.length = 0;
			mStartTimes[0] = 0;
			
			for (var i:int = 1; i < numFrames; ++i)
				mStartTimes[i] = mStartTimes[int(i - 1)] + mDurations[int(i - 1)];
		}
		
		// IAnimatable
		
		/** @inheritDoc */
		public function update(passedTime:Number):void {
			if (!mPlaying || passedTime <= 0.0)
				return;
			
			var finalFrame:int;
			var previousFrame:int = mCurrentFrame;
			var restTime:Number = 0.0;
			var breakAfterFrame:Boolean = false;
			var hasCompleteListener:Boolean = hasEventListener(Event.COMPLETE);
			var dispatchCompleteEvent:Boolean = false;
			var totalTime:Number = this.totalTime;
			
			if (mLoop && mCurrentTime >= totalTime) {
				mCurrentTime = 0.0;
				mCurrentFrame = 0;
			}
			
			if (mCurrentTime < totalTime) {
				mCurrentTime += passedTime;
				finalFrame = mTextures.length - 1;
				
				while (mCurrentTime > mStartTimes[mCurrentFrame] + mDurations[mCurrentFrame]) {
					if (mCurrentFrame == finalFrame) {
						if (mLoop && !hasCompleteListener) {
							mCurrentTime -= totalTime;
							mCurrentFrame = 0;
						} else {
							breakAfterFrame = true;
							restTime = mCurrentTime - totalTime;
							dispatchCompleteEvent = hasCompleteListener;
							mCurrentFrame = finalFrame;
							mCurrentTime = totalTime;
						}
					} else {
						mCurrentFrame++;
					}
					if (breakAfterFrame)
						break;
				}
				
				// special case when we reach *exactly* the total time.
				if (mCurrentFrame == finalFrame && mCurrentTime == totalTime)
					dispatchCompleteEvent = hasCompleteListener;
			}
			
			if (mCurrentFrame != previousFrame)
				texture = mTextures[mCurrentFrame];
			
			if (dispatchCompleteEvent)
				dispatchEvent(new Event(Event.COMPLETE));
			
			if (mLoop && restTime > 0.0)
				update(restTime);
		}
		
		/** Indicates if a (non-looping) movie has come to its end. */
		public function get isComplete():Boolean {
			return !mLoop && mCurrentTime >= totalTime;
		}
		
		// properties  
		
		/** The total duration of the clip in seconds. */
		public function get totalTime():Number {
			var numFrames:int = mTextures.length;
			return mStartTimes[int(numFrames - 1)] + mDurations[int(numFrames - 1)];
		}
		
		/** The time that has passed since the clip was started (each loop starts at zero). */
		public function get currentTime():Number {
			return mCurrentTime;
		}
		
		/** The total number of frames. */
		public function get numFrames():int {
			return mTextures.length;
		}
		
		/** Indicates if the clip should loop. */
		public function get loop():Boolean {
			return mLoop;
		}
		
		public function set loop(value:Boolean):void {
			mLoop = value;
		}
		
		/** The index of the frame that is currently displayed. */
		public function get currentFrame():int {
			return mCurrentFrame;
		}
		
		public function set currentFrame(value:int):void {
			mCurrentFrame = value;
			mCurrentTime = 0.0;
			
			for (var i:int = 0; i < value; ++i)
				mCurrentTime += getFrameDuration(i);
			
			texture = mTextures[mCurrentFrame];
		}
		
		/** The default number of frames per second. Individual frames can have different
		 *  durations. If you change the fps, the durations of all frames will be scaled
		 *  relatively to the previous value. */
		public function get fps():Number {
			return 1.0 / mDefaultFrameDuration;
		}
		
		public function set fps(value:Number):void {
			if (value <= 0)
				throw new ArgumentError("Invalid fps: " + value);
			
			var newFrameDuration:Number = 1.0 / value;
			var acceleration:Number = newFrameDuration / mDefaultFrameDuration;
			mCurrentTime *= acceleration;
			mDefaultFrameDuration = newFrameDuration;
			
			for (var i:int = 0; i < numFrames; ++i) {
				var duration:Number = mDurations[i] * acceleration;
				mDurations[i] = duration;
			}
			
			updateStartTimes();
		}
		
		/** Indicates if the clip is still playing. Returns <code>false</code> when the end
		 *  is reached. */
		public function get isPlaying():Boolean {
			if (mPlaying)
				return mLoop || mCurrentTime < totalTime;
			else
				return false;
		}
	}
}