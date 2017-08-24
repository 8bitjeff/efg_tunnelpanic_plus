package  com.efg.framework
{
	// Import necessary classes from the flash libraries
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jeff Fulton and Steve Fulton
	 */
	public class ScoreBoard extends Sprite
	{
		//create text format objects for our various colors of text ( white)
		
		public var textElements:Object;
		public var muteIndicator:TextField = new TextField;
		public var pausedIndicator:TextField = new TextField;
		public var tempElement:SideBySideScoreElement
		
		//Constructor calls init() only
		public function ScoreBoard() 
		{
			init();
		}
		
		
		private function init():void {
			
			textElements = {};
		}
		
		
		public function createTextElement(key:String, obj:SideBySideScoreElement):void {
			textElements[key] = obj;
			addChild(obj);			
		}
		
		//update() is called by Main after receiving a custom event from the Game class
		//1. two values are passed in:
		//2. key - represents the text name of the scoreBoard object to update ex: "score"
		//3. Value - representes the new value for the Object
		public function update(key:String, value:String):void {
			//trace("key=" + key);
			//trace("value=" + value);
			tempElement= textElements[key];
			tempElement.setContentText(value);
			
			//tempElement.update();
			
			
		}
		
		public function showMuteIndicator():void {
			addChild(muteIndicator);
		}
		
		public function hideMuteIndicator():void {
			removeChild(muteIndicator);
		}
		
		public function showPausedIndicator():void {
			addChild(pausedIndicator);
		}
		
		public function hidePausedIndicator():void {
			removeChild(pausedIndicator);
		}
		
		public function setMuteIndicator(text:String, location:Point, textFormat:TextFormat, width:int, useEmbeddedFonts:Boolean=false):void {
			//muteIndicator.embedFonts = useEmbeddedFonts
			muteIndicator.embedFonts = true;
			muteIndicator.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			muteIndicator.width = width;
			muteIndicator.x = location.x;
			muteIndicator.y = location.y;
			muteIndicator.text = text;
			muteIndicator.setTextFormat(textFormat);
			
		}
		
		public function setPausedIndicator(text:String, location:Point, textFormat:TextFormat, width:int, useEmbeddedFonts:Boolean=false):void {
			//pausedIndicator.embedFonts = useEmbeddedFonts;
			pausedIndicator.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			pausedIndicator.embedFonts = true;
			pausedIndicator.width = width;
			pausedIndicator.x = location.x;
			pausedIndicator.y = location.y;
			pausedIndicator.text = text;
			pausedIndicator.setTextFormat(textFormat);
			
		}
		
		public function updateFieldColor(paused:Boolean):void {
			
		}
		
	}
	
}