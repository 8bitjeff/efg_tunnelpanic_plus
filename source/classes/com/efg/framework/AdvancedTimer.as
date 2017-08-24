package com.efg.framework
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.getTimer;
	import flash.text.*;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class AdvancedTimer extends Sprite //so you can place it on the screen and see status
	
	{
		public static const ADVANCED_TIMER_UPDATE_NORMAL:int = 1;
		public static const ADVANCED_TIMER_UPDATE_EXCESS:int = 0;
		
		public var timerFrameRate:int = 0;
		private var timerPeriod:Number = 0;
		private var timerBeforeTime:int = 0;
		private var timerAfterTime:int = 0;
		private var timerTimerDiff:int = 0;
		private var timerSleepTime:int = 0;
		private var timerOverSleepTime:int = 0;
		private var SBTexcess:int = 0;
		private var gameTimer:Timer;
		private var profileTimer:Timer;
		public var neverUseUpdateAfterEvent:Boolean = true;
		public var timerUpdateType:int = ADVANCED_TIMER_UPDATE_NORMAL;
		public var xLocationAfterProfile:int = 0;
		public var yLocationAfterProfile:int = 0;
		public var showStats:Boolean = true;
		
		
		
		//public preperties
		public var profilerMaxFrameRate:int = 40;
		public var profilerMinFrameRate:int = 28;
		public var profilerRenderObjects:int = 500;
		public var profilerRenderFrames:int = 0;
		public var profilerRenderLoops:int = 10;
		public var profilerTurnOn:Boolean = false;
		public var profilerDisplayOnScreen:Boolean = false;
		public var profilerXLocation:int = 0;
		public var profilerYLocation:int = 0;
		public var timerUpdateAfterEvent:Boolean = false;
		
		
		//profiler
		
		private var profilerBackground:BitmapData = new BitmapData(400, 400, false, 0x000000);
		private var profilerCanvas:BitmapData = new BitmapData(400, 400, false, 0x000000);
		private var profilerBitmap:Bitmap = new Bitmap(profilerCanvas);
		private var profilerObject:BitmapData = new BitmapData(20, 20,false, 0xff0000);
		private var profilerFrameRateTotal:int=0;
		private var profilerFrameRateAverage:int = 0;
		private var profilerFrameRateEventCounter:int = 0;
		private var profilerFrameCount:int = 0;
		private var profilerTempObject:Object;
		private var profilerObjectArray:Array = [];
		private var profilerRenderPoint:Point = new Point(0, 0);
		private var profilerFrameRateArray:Array= [];
		
		private var format:TextFormat=new TextFormat();
		private var messageTextField:TextField = new TextField();
		
		private var main:GameFrameWorkAdvancedTimer;
		private var frameCounter:FrameCounter = new FrameCounter(); //added chapter 11
		
		
		
		public function AdvancedTimer(main:GameFrameWorkAdvancedTimer ) {
			this.main = main;
			
			addChild(frameCounter); 
			frameCounter.x = 0;	
			frameCounter.y = 0;
		}
		
		private function initGameTimer():void {
			trace("initGameTimer");
			timerPeriod = 1000 / timerFrameRate;
			gameTimer = new Timer(timerPeriod, 1); 
			gameTimer.addEventListener(TimerEvent.TIMER, runGame);
			gameTimer.start();
		}
		
		public function start():void {
			
			timerFrameRate = profilerMaxFrameRate;
			if (profilerTurnOn) {
				startProfile();
				
			}else {
				initGameTimer();
			}
		}
		
		
		private function runGame(e:TimerEvent):void {
			//trace("running runGame");
			
			//if (main.currentSystemState==FrameWorkStates.STATE_SYSTEM_GAME_PLAY) {
				timerBeforeTime = getTimer();
				timerOverSleepTime = (timerBeforeTime - timerAfterTime) - timerSleepTime;
				
				timerUpdateType = ADVANCED_TIMER_UPDATE_NORMAL;
				
				if (!main.paused) {
					main.systemFunction();
				}
				
				timerAfterTime = getTimer();
				timerTimerDiff = timerAfterTime - timerBeforeTime;
				timerSleepTime = (timerPeriod - timerTimerDiff) - timerOverSleepTime;        
				if (timerSleepTime <= 0) {
					SBTexcess -= timerSleepTime
					timerSleepTime = 1;
				}        
				gameTimer.reset();
				gameTimer.delay = timerSleepTime;
				gameTimer.start();
				
				while (SBTexcess > timerPeriod) {
					timerUpdateType = ADVANCED_TIMER_UPDATE_EXCESS;
					if (!main.paused) {
						main.systemFunction();
					}
					SBTexcess -= timerPeriod;
				}
				
				
			//}else {//*** added in chaper 11 for pause
			//	if (!main.paused) {
			//		main.systemFunction();
			//	}
		//	}//*** added in chaper 11 for pause
			
			if (timerUpdateAfterEvent) {
				e.updateAfterEvent();
			}
			
			frameCounter.countFrames();
			
		}
		
		private function startProfile():void {
			if (profilerDisplayOnScreen) {
				profilerBitmap.y = 20;
				profilerBitmap.x = 0;
			}else {
				profilerBitmap.x = main.stage.width + 10;
			}
			addChild(profilerBitmap);
			format.align = "center";
			format.size=24;
			format.font="Arial";
			format.color = 0xffffff
			format.bold = true;
			messageTextField.defaultTextFormat = format;
			messageTextField.text = "Profiling\nOptimal\nFrame Rate";
			
			messageTextField.width=200;
			messageTextField.height = 200;
			messageTextField.x = 100;
			messageTextField.y = 100;
			addChild(messageTextField);
			
			
			for (var ctr:int = 0; ctr < profilerRenderObjects; ctr ++) {
				 profileAddObject()
			}
			var profileRate:int = int((profilerMaxFrameRate + profilerMinFrameRate) / 2); // profile between the two
			profilerRenderFrames = profilerRenderLoops * profileRate;
			trace("profileRate=" + profileRate);
			trace("profilerRenderFrames=" + profilerRenderFrames);
			profileTimer = new Timer(timerPeriod); 
			profileTimer.addEventListener(TimerEvent.TIMER, runProfile);
			profileTimer.start();
			
		}
		
		private function runProfile(e:TimerEvent):void {
			
			profileUpdate();
			profileRender();
			if (frameCounter.countFrames()) {
				profilerFrameRateTotal += frameCounter.lastframecount;
				profilerFrameRateEventCounter++;
				trace("frameRate=" + frameCounter.lastframecount);
				trace("profilerFrameRateTotal=" + profilerFrameRateTotal);
				messageTextField.text = "Profiling\nOptimal\nFrame Rate\n" + String(int(profilerFrameCount / profilerRenderFrames * 100)) + "%";
				profilerFrameRateArray.push(frameCounter.lastframecount);
			}
		
			profilerFrameCount++;
			if (profilerFrameCount > profilerRenderFrames) {
				profileTimer.stop();
				profileCalculate();
			}
			e.updateAfterEvent();
			
		}
		
		private function profileCalculate():void {
			
			
			profilerFrameRateAverage = profilerFrameRateTotal / profilerFrameRateEventCounter;
			trace("profilerFrameRateEventCounter=" + profilerFrameRateEventCounter);
			trace("SBPFrameRateAverage=" + profilerFrameRateAverage);
			//get first and last events %
			
			var adjustedAverage:int=0;
			var adjustedTotal:int=0;
			var rate:int;
			
			profilerFrameRateArray.sort();
			trace("rates=" + String(profilerFrameRateArray));
			
			for (var ctr:int = 0; ctr < profilerFrameRateEventCounter; ctr++) {
				rate = profilerFrameRateArray[ctr];
				if (rate > profilerMaxFrameRate) {
					adjustedTotal += profilerMaxFrameRate;
				}else {
					adjustedTotal += rate;
				}
			
			}
			if (adjustedTotal > 0) {
				adjustedAverage = adjustedTotal / profilerFrameRateEventCounter;
			}else {
				adjustedAverage = profilerMinFrameRate;
			}
			
			
			trace("adjustedTotal=" + adjustedTotal);
			trace("profilerFrameRateEventCounter=" + profilerFrameRateEventCounter);
			trace("adjustedAverage=" + adjustedAverage);
			
			profilerFrameRateAverage = adjustedAverage;
			
			if (profilerFrameRateAverage < profilerMinFrameRate) {
				timerFrameRate = profilerMinFrameRate;
				timerUpdateAfterEvent = false;
			}else {
				if (!neverUseUpdateAfterEvent) {
					timerFrameRate = profilerFrameRateAverage;
					timerUpdateAfterEvent = true;
				}
			}
			
			if (neverUseUpdateAfterEvent) {
				timerUpdateAfterEvent = false;
			}
			
			dispose();
			initGameTimer();
			this.x = xLocationAfterProfile;
			this.y = yLocationAfterProfile;
			if (!showStats) {
				trace("not showing stats");
				removeChild(frameCounter);
			}else {
				trace("showing stats");
				frameCounter.profiledRate = timerFrameRate;
				frameCounter.showProfiledRate = true;
				frameCounter.updateAfterEvent = timerUpdateAfterEvent;
			}
		}
		
		
		private function profileAddObject():void {
			var profilerTempObject:Object = new Object();
			profilerTempObject.x=(Math.random() * 399);
			profilerTempObject.y=(Math.random() * 399);
			profilerTempObject.speed = (Math.random() * 5) + 1;
			profilerTempObject.dx=Math.cos(2.0*Math.PI*((Math.random()*360)-90)/360.0);
			profilerTempObject.dy = Math.sin(2.0 * Math.PI * ((Math.random()*360) - 90) / 360.0);
			profilerObjectArray.push(profilerTempObject);
		}
		
		
		private function profileUpdate():void {
			for each (profilerTempObject in profilerObjectArray) {
				profilerTempObject.x += profilerTempObject.dx * profilerTempObject.speed;
				profilerTempObject.y += profilerTempObject.dy * profilerTempObject.speed;
				if (profilerTempObject.x > profilerCanvas.width) {
					profilerTempObject.x = 0;
				}else if (profilerTempObject.x < 0) {
					profilerTempObject.x = profilerCanvas.width;
				}
				
				if (profilerTempObject.y > profilerCanvas.height) {
					profilerTempObject.y = 0;
				}else if (profilerTempObject.y < 0) {
					profilerTempObject.y = profilerCanvas.height;
				}
			}
		}
		
		private function profileRender():void {
			profilerCanvas.lock();
			profilerRenderPoint.x = 0;
			profilerRenderPoint.y = 0;
			profilerCanvas.copyPixels(profilerBackground, profilerBackground.rect, profilerRenderPoint);
			for each (profilerTempObject in profilerObjectArray) {
				
				
				profilerRenderPoint.x = profilerTempObject.x;
				profilerRenderPoint.y = profilerTempObject.y;
				
				//trace("profilerRenderPoint.x=" + profilerRenderPoint.x);
				//trace("profilerRenderPoint.y=" + profilerRenderPoint.y);
				profilerCanvas.copyPixels(profilerObject, profilerObject.rect, profilerRenderPoint);
			}
			profilerCanvas.unlock();
		}
		
		
		public function dispose():void {
			profileTimer.removeEventListener(TimerEvent.TIMER, runProfile);
			for (var ctr:int = 0; ctr < profilerObjectArray.length; ctr++) {
				profilerObjectArray[ctr] = null;
				profilerObjectArray.splice(1, 0);
			}
			
			removeChild(profilerBitmap);
			
			removeChild(messageTextField);
			profilerObjectArray = null;
			profilerBackground.dispose();
			profilerBackground = null;
			profilerCanvas.dispose();
			profilerBitmap = null;
			profileTimer = null;
			format = null;
			messageTextField = null;
		}
		
		
		
		
		
		
	}

}