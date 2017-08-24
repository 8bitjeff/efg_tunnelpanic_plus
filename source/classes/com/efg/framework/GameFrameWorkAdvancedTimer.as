package com.efg.framework
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class GameFrameWorkAdvancedTimer extends GameFrameWork {
		
	
		//added in chapter 11
		
		//Game is our custom class to hold all logic for the game. 
		//public var gameAdvancedTimer:GameAdvancedTimer;
		
		public var advancedTimer:AdvancedTimer;
	
		
		
		
		
		// Our construction only calls init(). This way, we can re-init the entire system if necessary
		public function GameFrameWorkAdvancedTimer() {
			
		}
		

		override public function startTimer():void {
			advancedTimer.start();
			addChild(advancedTimer);
		}
		
		override public function systemGamePlay():void {
			
			game.runGameAdvancedTimer(advancedTimer.timerUpdateType)
			
			
		}
		
		
	}
	
}

