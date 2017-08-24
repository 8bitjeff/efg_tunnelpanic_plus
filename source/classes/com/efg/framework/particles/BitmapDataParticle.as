/**
* ...
* @author Default
* @version 0.1
*/


package com.efg.framework.particles {
	import flash.display.Bitmap;
	
	public class BitmapDataParticle extends BitmapData {
		public var dx:Number;
		public var dy:Number;
		public var lifespan:Number; // holds # of cycles of frames tgis particle is alive
		public var velocity:Number;
		public var lifecount:Number = 0;
		public var frameArray:Array;
		public var frameCount:int=0;
		public var frameDelay:int=0;
		public var fadeout:Boolean=false;
		public var fadeoutAfterFrame:int=1;
		public var x:Number=0;
		public var y:Number=0;
		
		
		public function BitmapDataParticle(frameArray:Array, width:Number, height:Number):void {
			super(width, height, true, 0x00000000);
			trace("particle created");
			this.frameArray = frameArray;
		}
		
	}
	
}
