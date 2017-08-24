package com.efg.framework 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class ImageButton extends Sprite
	{
		public static const OFF:int = 1;
		public static const OVER:int = 2;
		
		public var buttonBitmap:Bitmap;
		public var offBitmapData:BitmapData;
		public var overBitmapData:BitmapData;
		
		public function ImageButton(off:BitmapData, over:BitmapData, location:Point) {
			offBitmapData = off;
			overBitmapData = over;
			buttonBitmap = new Bitmap(offBitmapData);
			addChild(buttonBitmap);
			x = location.x;
			y = location.y;
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		public function changeButton(typeval:int):void {
			if (typeval == OFF) {
				buttonBitmap.bitmapData = offBitmapData;
			}else {
				buttonBitmap.bitmapData = overBitmapData;
			}
		}
		
	}

}