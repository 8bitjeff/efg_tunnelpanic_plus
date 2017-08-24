package com.efg.framework 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import mx.core.ByteArrayAsset;
	import flash.events.Event;
	
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class LogoScreen extends MovieClip{
		public var loader:Loader=new Loader;
		public var logo:ByteArrayAsset;
		public var clip:MovieClip;
		public var loadComplete:Boolean = false;
		public var clickThroughUrl:String;
		public var backgroundBitmap:Bitmap;
		public var backgroundBitmapData:BitmapData;
		public var clipLocation:Point;
		
		
	
		public function LogoScreen(logo:ByteArrayAsset, url:String = "", clipX:Number=0, clipY:Number=0, backWidth:Number = 0, backHeight:Number = 0, backColor:Number = 0x000000) {
			backgroundBitmapData = new BitmapData(backWidth, backHeight, false, backColor);
			//backgroundBitmapData = new BitmapData(600, 400, false, 0x000000);
			backgroundBitmap = new Bitmap(backgroundBitmapData);
			addChild(backgroundBitmap);
			clickThroughUrl = url;
			this.logo = logo;
			clipLocation = new Point(clipX, clipY);
			loader.contentLoaderInfo.addEventListener(Event.INIT,loadCompleteListener,false,0,true);
			loader.loadBytes(logo);
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		
		
		private function loadCompleteListener(e:Event):void {
			
			loadComplete = true;
			clip = MovieClip(loader.content);
			clip.x = clipLocation.x;
			clip.y = clipLocation.y;
			addChild(clip);
            clip.stop();
			addEventListener(MouseEvent.MOUSE_DOWN,backgroundclicked);
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