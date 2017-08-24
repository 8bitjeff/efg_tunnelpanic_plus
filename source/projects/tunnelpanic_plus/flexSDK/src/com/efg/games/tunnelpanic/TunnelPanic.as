package com.efg.games.tunnelpanic
{
	
	import flash.display.*
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import com.efg.framework.BasicBlitArrayObject;
	import com.efg.framework.BlitArrayAsset;
	import com.efg.framework.BasicBiltArrayParticle;
	import com.efg.framework.CustomEventLevelScreenUpdate;
	import com.efg.framework.CustomEventScoreBoardUpdate;
	import com.efg.framework.CustomEventSound;
	import com.efg.framework.BasicBlitObject;
	
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class TunnelPanic extends com.efg.framework.Game
	{
	
		
		public static const STATE_SYSTEM_GAME_PLAY:int = 0;
		public static const STATE_SYSTEM_PLAYER_EXPLODE:int = 1;
		
		private var systemFunction:Function;
		private var currentSystemState:int;
		private var nextSystemState:int;
		private var lastSystemState:int;
		
		
		
		
		private var customerScoreBoardEventScore:CustomEventScoreBoardUpdate = new CustomEventScoreBoardUpdate(CustomEventScoreBoardUpdate.UPDATE_TEXT,Main.SCORE_BOARD_SCORE, "");
		
		//Tunnel Panic game specific
		private var keyPressList:Array = [];
		private var keyListenersInit:Boolean = false;
	
		//player ship
		private var playerSprite:Sprite = new Sprite();
		private var playerShape:Shape = new Shape();
		private var playerSpeed:Number = 4;
		private var playerStarted:Boolean = false;
		
		//playfield
		private var playfieldSprite:Sprite = new Sprite();
		private var playfieldShape:Shape = new Shape();
		private var playfieldminX:int = 0;
		private var playfieldmaxX:int = 599;
		private var playfieldminY:int = 21;
		private var playfieldmaxY:int = 378;
		
		
		
		//obstacles
		private var obstaclePool:Array = [];
		private var obstacles:Array = [];
		private var tempObstacle:Bitmap;
		private var obstaclePoolLength:int = 200;
		
		
		//game play
		//how long to wai before increasing obstacle difficulty
		private var obstacleUpgradeWait:int = 10000;
		private var lastObstacleUpgrade:int;
		
		
		
		//obstacle frequency
		private var lastObstacleTime:int;
		private var obstacleDelay:int = 800;
		private var obstacleDelayMin:int = 50;
		private var obstacleDelayDecrease:int = 150;
		
		//center obstacles
		private var centerFrequency:int = 15;
		private var centerHeight:int = 10;
		private var centerWidth:int = 15;
		
		//obstacle height
		private var obstacleHeightMin:int = 40;
		private var obstacleHeightMax:int = 60;
		private var obstacleHeightLimit:int = 120;
		private var obstacleHeightIncrease:int = 20;
		
		//obstacleSpeed
		private var obstacleSpeed:int = 6;
		private var obstacleSpeedMax:int = 12;
		
		//obstacleColors
		private var obstacleColors:Array = [0xffffff, 0xff0000, 0x00ff00, 0x0000ff, 0x00ffff, 0xffff00, 0xffaaff, 0xaaff99, 0xcc6600, 0xff80c0, 0xcc00ff, 0x00cc33, 0x9933ff];
		private var obstacleColorIndex:int = 0;
		
		private var gravity:Number = 1;
		
		//exhaust blit canvas
		private var backgroundBitmapData:BitmapData = new BitmapData(600, 360, false, 0x000000);
		private var canvasBitmapData:BitmapData = new BitmapData(600, 360, true, 0x00000000);
		private var canvasBitmap:Bitmap = new Bitmap(canvasBitmapData);
		
		private var auroraEraseBitmapData:BitmapData = new BitmapData(8, 8, false, 0x00000000);
		private var auroraBitmapData:BitmapData = new BitmapData(600, 360, true, 0x00000000);
		private var auroraBitmap:Bitmap= new Bitmap(auroraBitmapData);
		private var auroraArray:Array = [];
		private var auroraParts:int = 2000;
		private var refreshAurora:Boolean = false;
		private var auroraRefreshStart:int = 0; //number to start on in the aurora arrary
		private var auroraRefreshEnd:int = 0; //number to end on in the aurora arrary
		private var auroraRefreshNum:int = auroraParts / 40; //number of parts to refresh per frame
		private var tempAuroraObject:BasicBlitObject;
		private var auroraPoint:Point = new Point(0, 0);
		
		private var blitPoint:Point = new Point(0, 0);
		
		private var exhaustPool:Array = [];
		private var exhaustParticles:Array = [];
		private var tempExhaustParticle:BasicBiltArrayParticle;
		private var exhaustPoolLength:int = 30;
		private var exhaustLength:int;
		private var exhaustAnimationList:Array = [];
		private var lastExhaustTime:int = 0;
		private var exhaustDelay:int = 50+((obstacleSpeedMax * 10) - (10 * obstacleSpeed));
		private var exhaustErase:BitmapData = new BitmapData(32, 32, true, 0x00000000);
		//score
		public var score:int = 0;
		private var lastScoreEvent:int = 0;
		private var scoreDelay:int = 1000;
		private var gameOver:Boolean = false;
		
		
		
		public function TunnelPanic() 
		{
			init();
		}
		
		/*
		override public function setRendering(profiledRate:int, framerate:int):void {
			var percent:Number=profiledRate / framerate
			//trace("framepercent=" + percent);
			
			if (percent>=.85) {
				frameRateMultiplier = 2;
			}
			//trace("frameRateMultiplier=" + frameRateMultiplier);
		}
		*/
		
		public function init():void {
			
			this.focusRect = false;
			
			createPlayerShip();
			createPlayfield();
			createObstaclePool();
			createExhaustPool();
			createAurora();
			canvasBitmap.y = 20;
			auroraBitmap.y = 20;
			addChild(auroraBitmap);
			addChild(canvasBitmap);
			addChild(playfieldSprite);
		
		
		}
		
		private function createPlayerShip():void {
			//draw vector ship and place it into a Sprite instance
			playerShape.graphics.clear();
			playerShape.graphics.lineStyle(2, 0xff00ff);
			playerShape.graphics.moveTo(15, 7);
			playerShape.graphics.lineTo(7, 24);
			playerShape.graphics.lineTo(15, 19);
			playerShape.graphics.moveTo(16, 19);
			playerShape.graphics.lineTo(24, 24);
			playerShape.graphics.lineTo(16, 7);
			
			playerShape.x = -16;
			playerShape.y = -16;
			playerSprite.addChild(playerShape);
		}
		
		private function createPlayfield():void {
			//draw playfield as two simple lines at top and bottom of screen
			
			playfieldShape.graphics.clear();
			playfieldShape.graphics.lineStyle(2, 0xffffff);
			playfieldShape.graphics.moveTo(playfieldminX, playfieldminY);
			playfieldShape.graphics.lineTo(playfieldmaxX, playfieldminY);
			playfieldShape.graphics.moveTo(playfieldminX, playfieldmaxY);
			playfieldShape.graphics.lineTo(playfieldmaxX, playfieldmaxY);
		
			playfieldSprite.addChild(playfieldShape);
			
			
			
			
			
		}
		
		private function createAurora():void {
			var rgbColor:uint = obstacleColors[obstacleColorIndex];
			for (var ctr:int = 0; ctr < auroraParts; ctr++) {
				
				var auroraObject:BasicBlitObject = new BasicBlitObject(new BitmapData(8, 8, true, 0x00000000));
				auroraArray.push(auroraObject);
			}
			
			
		}
		
		private function refreshAuroraParts(start:int,end:int ):void {
			trace("start: " + start + " , " + "end: " + end);
			var rgbColor:uint = obstacleColors[obstacleColorIndex];
			for (var ctr:int= start; ctr < end; ctr++) {
				tempAuroraObject = auroraArray[ctr];
				//dirty rect blit erase
				auroraPoint.x = tempAuroraObject.x;
				auroraPoint.y = tempAuroraObject.y;
				auroraBitmapData.copyPixels(auroraEraseBitmapData, tempAuroraObject.bitmapData.rect, auroraPoint);
				
				tempAuroraObject.x = int(Math.random() * 580);
				tempAuroraObject.y = int(Math.random() * 360);
				auroraPoint.x = tempAuroraObject.x;
				auroraPoint.y = tempAuroraObject.y;
				var randAlpha:Number = (Math.random() * 50) + 10;
				var argb:uint = 0;
				argb += (randAlpha<<24);
				argb += (rgbColor);
				tempAuroraObject.bitmapData.fillRect(tempAuroraObject.bitmapData.rect, argb);
				auroraBitmapData.copyPixels(tempAuroraObject.bitmapData, tempAuroraObject.bitmapData.rect, auroraPoint);
			}
			
		}
		
		
		private function createObstaclePool():void {
			for (var ctr:int = 0; ctr < obstaclePoolLength; ctr++) {
				var tempBitmapData:BitmapData = new BitmapData(1, 1, false, obstacleColors[obstacleColorIndex]);
				var tempObstacle:Bitmap = new Bitmap(tempBitmapData) 
				
				obstaclePool.push(tempObstacle);
			}
		}
		
		private function createExhaustPool():void {
			//create look for exhaust
			var tempBD:BitmapData = new BitmapData(32, 32, true, 0x00000000);
			tempBD.setPixel32(30, 13, 0xffff00ff);
			tempBD.setPixel32(29, 13, 0xffff00ff);
			tempBD.setPixel32(25, 13, 0xccff00ff);
			tempBD.setPixel32(24, 13, 0xccff00ff);
			tempBD.setPixel32(22, 13, 0x99ff00ff);
			tempBD.setPixel32(20, 13, 0x55ff00ff);
			tempBD.setPixel32(30, 15, 0xffff00ff);
			tempBD.setPixel32(29, 15, 0xffff00ff);
			tempBD.setPixel32(25, 15, 0xccff00ff);
			tempBD.setPixel32(24, 15, 0xccff00ff);
			tempBD.setPixel32(22, 15, 0x99ff00ff);
			tempBD.setPixel32(20, 15, 0x55ff00ff);
			tempBD.setPixel32(30, 14, 0xffff00ff);
			tempBD.setPixel32(29, 14, 0xffff00ff);
			tempBD.setPixel32(25, 14, 0xccff00ff);
			tempBD.setPixel32(24, 14, 0xccff00ff);
			tempBD.setPixel32(22, 14, 0x99ff00ff);
			tempBD.setPixel32(20, 14, 0x55ff00ff);
			
			var tempBlitArrayAsset:BlitArrayAsset= new BlitArrayAsset();
			tempBlitArrayAsset.createFadeOutBlitArrayFromBD(tempBD, 20);
			exhaustAnimationList = tempBlitArrayAsset.tileList;
			
			for (var ctr:int = 0; ctr < exhaustPoolLength; ctr++) {
				var tempExhaustParticle:BasicBiltArrayParticle = new BasicBiltArrayParticle(playfieldminX, playfieldmaxY, playfieldminY, playfieldmaxY);
				exhaustPool.push(tempExhaustParticle);
			}
			
		}
	
		override public function newGame():void {
			score = 0;
			obstacleColorIndex = 0;
			lastObstacleTime = 0;
			lastExhaustTime = 0;
			lastScoreEvent = 0;
			obstacleDelay= 1000;
			obstacleHeightMax= 10;
			obstacleSpeed= 4;
			playerStarted = false;
			gameOver = false;
			playerSprite.alpha = 1;
			refreshAurora = true;
			
			switchSystemState(STATE_SYSTEM_GAME_PLAY);
			//key listeners
			if (!keyListenersInit) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
				keyListenersInit = true;
				
			}
			
			updateScoreBoard();
			
			
		}
		
		override public function newLevel():void {
			
			stage.focus = this;
			
			
			dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_IN_GAME_MUSIC, true, 999, 8, 1));
		
			
			addChild(playerSprite);
			playerSprite.x = 300;
			playerSprite.y = 200;
			playerSprite.rotation = 90;
			playerStarted = true;
			lastObstacleUpgrade = getTimer();
			lastObstacleTime = getTimer();
			
		}
		
		override public function runGameTimeBased(paused:Boolean=false,timeDifference:Number=1):void {
			if (!paused) {
				systemFunction(timeDifference);
			}
			
		}
		
		public function switchSystemState(stateval:int):void {
			lastSystemState = currentSystemState;
			currentSystemState = stateval;
			
			switch(stateval) {
				
				case STATE_SYSTEM_GAME_PLAY: 
					systemFunction = systemGamePlay;
					break;
				
				case STATE_SYSTEM_PLAYER_EXPLODE :
					systemFunction = systemPlayerExplode;
					break;
				
			
			}
		}
		
		private function systemGamePlay(timeDifference:Number=0):void {
			if (playerStarted) {
				checkInput();
			}
			update(timeDifference);
			checkCollisions();
			render();					
			updateScoreBoard();
			checkforEndGame();
			
		}
		
		
		
		private function systemPlayerExplode(timeDifference:Number=0):void {
			

			playerSprite.alpha -=.005;
			if (playerSprite.alpha <= 0) {
				playerExplodeComplete();
			}
		
		
		}
		
		
		
		public function checkforEndGame():void {
			if (gameOver ) {
				playerStarted = false;
				switchSystemState(STATE_SYSTEM_PLAYER_EXPLODE);
				dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_EXPLODE, false, 1, 8, 1));
				trace("attempting to stop the sound track");
				dispatchEvent(new CustomEventSound(CustomEventSound.STOP_SOUND, Main.SOUND_IN_GAME_MUSIC, true));
			}
		}
		
		private function playerExplodeComplete():void {
				dispatchEvent(new Event(GAME_OVER) );
				lastScore = score;
				//trace("lastScore=" + lastScore);
				disposeAll();
		}
		
		///*** next iteration
		private function checkInput():void {
			if (keyPressList[32]) {
				playerSprite.y -= playerSpeed;
			}
		}
		
		private function keyDownListener(e:KeyboardEvent):void { 
			keyPressList[e.keyCode] = true;
			////trace("key down: " + e.keyCode);
			
		}
		
		private function keyUpListener(e:KeyboardEvent):void { //** new function in chapter 11
			keyPressList[e.keyCode] = false;
			////trace("key up: " + e.keyCode);
		}
		
		private function update(timeDifference:Number = 0):void {
			var timeBasedModifier:Number = (timeDifference / 1000)*timeBasedUpdateModifier;
			//score
			if (playerStarted && getTimer() > (lastScoreEvent + scoreDelay)) {
				score += (10 + obstacleSpeed);
			}
			//obstacles additions
			if (getTimer() > lastObstacleUpgrade +obstacleUpgradeWait) {
				lastObstacleUpgrade = getTimer();
				obstacleDelay -= obstacleDelayDecrease;
				if (obstacleDelay < obstacleDelayMin) {
					obstacleDelay = obstacleDelayMin;
					
				}
				//trace("obstacleDelay=" + obstacleDelay);
				obstacleHeightMax += obstacleHeightIncrease;
				
				if (obstacleHeightMax > obstacleHeightLimit) {
					obstacleHeightMax = obstacleHeightLimit;
					
				}
				//trace("obstacleHeightMax=" + obstacleHeightMax);
				obstacleSpeed++;
				if (obstacleSpeed > obstacleSpeedMax) {
					obstacleSpeed = obstacleSpeedMax;
					
				}
				//trace("obstacleSpeed=" + obstacleSpeed);
				
				obstacleColorIndex++;
				if (obstacleColorIndex == obstacleColors.length) {
					obstacleColorIndex = obstacleColors.length - 1;
				}
				//trace("obstacleColorIndex=" + obstacleColorIndex);

				exhaustDelay= 50+((obstacleSpeedMax * 10) - (10 * obstacleSpeed));
				
				refreshAurora = true;
				
			}
			
			
			if (refreshAurora) {
				
				auroraRefreshEnd = auroraRefreshStart + auroraRefreshNum;
				if (auroraRefreshEnd> auroraParts) {
					auroraRefreshStart = 0;
					auroraRefreshEnd = 0
					refreshAurora = false;
				}else {
					refreshAuroraParts(auroraRefreshStart, auroraRefreshEnd);
					auroraRefreshStart = auroraRefreshEnd;
				}
				
			}
			
			
			// add new obstacles
			var obstaclePoolCount:int = obstaclePool.length -1;
			if (getTimer() > (lastObstacleTime + obstacleDelay) && obstaclePoolCount>0) {
				////trace("creating an obstacle");
				lastObstacleTime = getTimer();
				tempObstacle = obstaclePool.pop();
				//tempObstacle = obstaclePool[obstaclePoolCount];
				tempObstacle.bitmapData.setPixel(0, 0, obstacleColors[obstacleColorIndex]);
				
		
				
				//is it going to be in the center?
				if (int(Math.random() * 100) < centerFrequency) {
					tempObstacle.y = 120 + Math.random()*200;
					tempObstacle.scaleY = centerHeight;
					tempObstacle.scaleX = centerWidth;
				}else {
					
					tempObstacle.scaleY = randomNumberFromRange(obstacleHeightMin, obstacleHeightMax);
					tempObstacle.scaleX = 5;
					(int(Math.random() * 2) == 0)? tempObstacle.y = playfieldminY : tempObstacle.y = (playfieldmaxY - tempObstacle.height);
				}
				tempObstacle.x = playfieldmaxX;
				
				
				
				obstacles.push(tempObstacle);
				addChild(tempObstacle);
				
			}
			
			//update obstacles
			var obstacleCount:int = obstacles.length - 1;
			
			for (var ctr:int=obstacleCount;ctr>=0;ctr--) {
				tempObstacle= obstacles[ctr];
				tempObstacle.x -= obstacleSpeed*timeBasedModifier;
				
				if (tempObstacle.x < playfieldminX) {
					tempObstacle.scaleY = 1;
					tempObstacle.scaleX = 1;
					obstaclePool.push(tempObstacle);
					obstacles.splice(ctr, 1);
					removeChild(tempObstacle);
				}
			}
			
			var exhaustPoolCount:int = exhaustPool.length -1;
		
			if (getTimer() > (lastExhaustTime + exhaustDelay) && exhaustPoolCount > 0 ) {
				lastExhaustTime = getTimer();
				tempExhaustParticle = exhaustPool.pop();
				//tempExhaustParticle = exhaustPool[exhaustPoolCount];
				//exhaustPool.splice(exhaustPoolCount, 1);
				tempExhaustParticle.lifeDelayCount=0;
				tempExhaustParticle.x=playerSprite.x-30;
				tempExhaustParticle.y = playerSprite.y-32;
				tempExhaustParticle.nextX=tempExhaustParticle.x;
				tempExhaustParticle.nextY=tempExhaustParticle.y;
				tempExhaustParticle.speed = obstacleSpeed;
				tempExhaustParticle.frame = 0;
				tempExhaustParticle.animationList =  exhaustAnimationList;
				tempExhaustParticle.bitmapData = tempExhaustParticle.animationList[tempExhaustParticle.frame];
				tempExhaustParticle.dx = -1;
				tempExhaustParticle.dy = 0;
				tempExhaustParticle.lifeDelay = 3;
				exhaustParticles.push(tempExhaustParticle);
				
				//trace("tempExhaustParticle.animationList[tempExhaustParticle.frame]=" + tempExhaustParticle.animationList[tempExhaustParticle.frame]);
				
			}
			
			
			exhaustLength = exhaustParticles.length - 1;
			canvasBitmapData.lock();
			for (ctr = exhaustLength; ctr >= 0; ctr--) {
				
				tempExhaustParticle = exhaustParticles[ctr];
				
				//dirty rect blit erase
				blitPoint.x = tempExhaustParticle.x;
				blitPoint.y = tempExhaustParticle.y;
				canvasBitmapData.copyPixels(exhaustErase, tempExhaustParticle.bitmapData.rect, blitPoint);
				if (tempExhaustParticle.update(timeBasedModifier)) { //return true if particle is to be removed
					tempExhaustParticle.frame = 0;
					exhaustPool.push(tempExhaustParticle);
					exhaustParticles.splice(ctr,1);
				}
				
			}
			canvasBitmapData.unlock();
			
			
			playerSprite.y += gravity;
		}
		
		private function randomNumberFromRange(min:int, max:int):int {
			return(int(Math.random() * (max - min)) + min);

		}
		
		private function checkCollisions():void {
			var playerHit:Boolean = false;
			if (playerSprite.y < playfieldminY+10 || playerSprite.y > playfieldmaxY-10) {
				//trace("hit outside bounds");
				playerHit = true;
			}
			
			for each (tempObstacle in obstacles) {
				if (playerSprite.hitTestObject(tempObstacle)) {
					//trace("hit obstacle");
					playerHit = true;
				}
			}
			
			if (playerHit) {
				gameOver = true;
			}
		}
		
		private function render():void {
			canvasBitmapData.lock();
			for each (tempExhaustParticle in exhaustParticles) {
				tempExhaustParticle.render(canvasBitmapData);
				
			}
			canvasBitmapData.unlock();
		}
		
		private function updateScoreBoard():void {
			customerScoreBoardEventScore.value = score.toString();
			dispatchEvent(customerScoreBoardEventScore);
		}
		
		private function disposeAll():void {
			
			//move all obstacles left in active to pool
			var obstacleCount:int = obstacles.length - 1;
			for (var ctr:int = obstacleCount; ctr >= 0; ctr--) {
				tempObstacle = obstacles[ctr];
				removeChild(tempObstacle);
				obstaclePool.push(tempObstacle);
				obstacles.splice(ctr,1);
			}
			
			
			var exhaustCount:int = exhaustParticles.length - 1;
			for (ctr = exhaustCount; ctr >= 0; ctr--) {
				tempExhaustParticle = exhaustParticles[ctr];
				
				//dirty rect blit erase
				blitPoint.x = tempExhaustParticle.x;
				blitPoint.y = tempExhaustParticle.y;
				canvasBitmapData.copyPixels(exhaustErase, tempExhaustParticle.bitmapData.rect, blitPoint);
				tempExhaustParticle.frame = 0;
				exhaustPool.push(tempExhaustParticle);
				exhaustParticles.splice(ctr,1);
			}
			
			//trace("disposed");
		
		}
		
		
	}
	

}