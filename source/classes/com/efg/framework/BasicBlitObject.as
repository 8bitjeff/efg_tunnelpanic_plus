package com.efg.framework 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * used to contain and have basic positioning for a blit object
	 * Jeff Fulton
	 */
	public class BasicBlitObject 
	{
		public var bitmapData:BitmapData;
		public var x:Number;
		public var y:Number;
		
		public function BasicBlitObject(bitmapData:BitmapData) {
			this.bitmapData = bitmapData;
		}
		
	}
	
}