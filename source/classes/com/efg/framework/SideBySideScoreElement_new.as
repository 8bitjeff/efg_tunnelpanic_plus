package  com.efg.framework
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class SideBySideScoreElement extends Sprite
	{
		private var label:TextField = new TextField();
		private var content:TextField = new TextField();
		private var bufferWidth:Number;
		
		//special field functions
		//repeat values
		//999 repeat indefinitely
		//1 = change one time
		//2 to change color and then back again with 2 formats in the 
		public var textChange:Boolean = false;
		public var textChangeRepeat:int = 1; 
		public var textChangeRepeatCount:int = 0; 
	
		public var textChangeDelay:int = 3;
		public var textChangeDelayCount:int = 0;
		
		//the index is used to loop through a set of text formats for unlimited morphing effects
		public var textChangeIndexStart:int = 0;
		public var textChangeIndexEnd:int = 0;
		public var textChangeIndex:int = 0;
		
		public var labelFormats:Array=[];
		public var contentFormats:Array = [];
		
		public var labelFormatIndex:int = 0;
		public var contentFormatIndex:int = 0;
		
		private var changeLabel:Boolean = false;
		private var changeContent:Boolean = false;
		
		
		
		
		public function SideBySideScoreElement(x:Number, y:Number, bufferWidth:Number, labelText:String, labelTextFormat:TextFormat, labelWidth:Number, contentText:String, contentTextFormat:TextFormat, useEmbeddedFonts:Boolean=false) {
			this.x = x;
			this.y = y;
			
			labelFormats.push(labelTextFormat);
			contentFormats.push(contentTextFormat);
			
			//label.embedFonts = useEmbeddedFonts;
			//content.embedFonts = useEmbeddedFonts;
			
			label.embedFonts = true;
			content.embedFonts = true;
			
			label.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			content.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			this.bufferWidth= bufferWidth;
			label.autoSize=TextFieldAutoSize.LEFT;
			label.defaultTextFormat = labelTextFormat;
			label.text = labelText;
			content.autoSize=TextFieldAutoSize.LEFT;
			content.defaultTextFormat = contentTextFormat;
			content.text = contentText;
			label.x = 0;
			content.x = labelWidth + bufferWidth;
			addChild(label);
			addChild(content);
			
		}
		
		public function setLabelText(str:String):void {
			label.text = str;
		}
		
		public function setContentText(str:String):void {
			content.text = str;
		}
		
		public function setLabelFormats(tfArray:Array):void {
			labelFormats = tfArray;
			
		}
		
		public function setContentFormats(tfArray:Array):void {
			contentFormats = tfArray;
			
		}
		
		public function startTextChange(repeatNum:int, delay:int, startIndex:int, stopIndex:int, changeLabel:Boolean=false, changeContent:Boolean=false):void {
			textChange = true;
			textChangeRepeat = repeatNum;
			textChangeDelay=delay;
			textChangeIndexStart = startIndex;
			textChangeIndexEnd = stopIndex;
			textChangeIndex = textChangeIndexStart;
			this.changeLabel = changeLabel;
			this.changeContent = changeContent;
			textChangeDelayCount = 0;
			textChangeRepeatCount = 0;
		}
		
		public function textChangeReset(labelTF:TextFormat, contentTF:TextFormat):void {
			label.defaultTextFormat = labelTF;
			content.defaultTextFormat = contentTF;
		}
		
		
		public function update():void {
			
			if (textChange) {
				
				textChangeRepeatCount++;
				if (textChangeRepeat==999 || textChangeRepeatCount<=textChangeRepeat) {
					
					textChangeDelayCount++;
					trace("delayCount=" + textChangeDelayCount);
					if (textChangeDelayCount > textChangeDelay) {
						textChangeDelayCount = 0;
						textChangeIndex++;
						if (textChangeIndex > textChangeIndexEnd) {
							textChangeIndex = textChangeIndexStart;
						}
						
						if (changeLabel) {
							label.defaultTextFormat = labelFormats[textChangeIndex];
						}
						
						if (changeLabel) {
							content.defaultTextFormat = contentFormats[textChangeIndex];
						}
						
					}
				}else { // repeat over
					trace("repeat over");
					textChange = false;
				}
			}
		}
		
	}
	
}
