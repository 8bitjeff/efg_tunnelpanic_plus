package com.efg.framework 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class SponsorScreen extends Sprite {
	   
		public var logo:BitmapData;																			
		public var clickThroughUrl:String;
		public var bitmap:Bitmap;
		public var backgroundBitmap:Bitmap;
		public var backgroundBitmapData:BitmapData;
	
		public function SponsorScreen(logo:BitmapData,url:String = "", bitmapX:Number=0, bitmapY:Number=0, backWidth:Number = 0, backHeight:Number = 0, backColor:Number = 0x000000) {
			backgroundBitmapData = new BitmapData(backWidth, backHeight, false, backColor);
			backgroundBitmap = new Bitmap(backgroundBitmapData);
			addChild(backgroundBitmap);
			this.logo = logo;
			clickThroughUrl = url;
			bitmap = new Bitmap(logo);
			bitmap.x = bitmapX;
			bitmap.y = bitmapY;
			addChild(bitmap);
			addEventListener(MouseEvent.MOUSE_DOWN, backgroundclicked);
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		public function backgroundclicked(e:MouseEvent):void {
			var request:URLRequest = new URLRequest(clickThroughUrl);
			
            try {            
				trace("navigating to URL");
                navigateToURL(request);
            }
            catch (error:Error) {
                trace("*** <Error in Update URRequest> " + error.message);
            }
			
		}
		
	}

}