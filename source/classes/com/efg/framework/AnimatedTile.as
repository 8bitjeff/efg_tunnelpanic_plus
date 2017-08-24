package com.efg.framework 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class AnimatedTile 
	{
		public var tileList:Array;
		public var currentTile:int;
		public var animationDelay:int;
		public var animationCount:int = 0;
		public var tileRow:int;
		public var tileCol:int;
		
		
		public function AnimatedTile(tileRow:int, tileCol:int,tileList:Array,startTile:int,animationDelay:int) {
			this.tileRow = tileRow;
			this.tileCol = tileCol;
			this.tileList = tileList;
			this.currentTile = startTile;
			this.animationDelay = animationDelay;
			
		}
		
		public function updateTile():Boolean {
			//returns true if animation loop is over
			var animationLoopComplete:Boolean = false;
			animationCount++;
			if (animationCount > animationDelay) {
				currentTile++
				if (currentTile == tileList.length) {
					currentTile = 0;
					animationLoopComplete = true;
				}
			}
			
			return animationLoopComplete;
		}
		
		public function dispose():void {
			tileList = null;
		}
		
	}
	
}