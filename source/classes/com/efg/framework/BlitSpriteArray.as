﻿package com.efg.framework{	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Sprite;			/**	 * ...	 * @author Jeff Fulton	 */	public class BlitSpriteArray extends Sprite {		public var bitmap:Bitmap;		public var bitmapData:BitmapData;		public var animationDelay:int=3;		public var animationCount:int=0;		public var animationLoop:Boolean=false;		public var tileList:Array;		public var currentTile:int;		public var nextX:Number=0;		public var nextY:Number = 0;		public var dx:Number=0;		public var dy:Number = 0;		public var doTileSwap:Boolean = false;		public var loopCounter:int = 0; // counts the number of animation loops if useCounter is set to true;		public var useLoopCounter:Boolean = false;				public function BlitSpriteArray( tileList:Array, firstFrame:int) {						this.tileList = tileList;			currentTile = firstFrame;			bitmapData = tileList[currentTile];			bitmap = new Bitmap(bitmapData);			bitmap.x = -.5 * width;			bitmap.y = -.5 * height;			addChild(bitmap);							}				public function updateCurrentTile():void {					if (animationLoop) {				if (animationCount > animationDelay) {					animationCount = 0;					currentTile++;					doTileSwap = true;					if (currentTile > tileList.length - 1) {						currentTile = 0;						if (useLoopCounter) loopCounter++;					}				}				animationCount++;			}					}				public function renderCurrentTile():void {						if (doTileSwap) {				bitmap.bitmapData = tileList[currentTile];				doTileSwap = false;			}								}				public function dispose():void {			bitmap.bitmapData.dispose();			bitmap = null;			tileList = null;		}			}	}