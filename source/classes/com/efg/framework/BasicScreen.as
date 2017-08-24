package  com.efg.framework
{
	// Import necessary classes from the flash library
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class BasicScreen extends Sprite {
		
		
		public var displayText:TextField = new TextField();
		public var backgroundBitmapData:BitmapData;
		public var backgroundBitmap:Bitmap;
		public var okButton:SimpleBlitButton;
		public var imageButton:ImageButton;
	
		
		public var imageBitmapData:BitmapData;
		public var imageBitmap:Bitmap;
		
		public var useImageButton:Boolean = false;
		
		
		//ID is passed into the constructor. When the OK button is clicked, a custom event sends this id back to Main
		private var id:int;
		
		//Constructor accepts our two passed in vars and then calls init
		public function BasicScreen(id:int,width:Number, height:Number, isTransparent:Boolean, color:uint) {
			this.id = id;
			backgroundBitmapData = new BitmapData(width, height, isTransparent, color);
			backgroundBitmap = new Bitmap(backgroundBitmapData);
			addChild(backgroundBitmap);
		}
		
		public function addImage(bitmapData:BitmapData):void {
			imageBitmapData = bitmapData;
			imageBitmap = new Bitmap(imageBitmapData);
			addChild(imageBitmap);
		}
		
		public function createDisplayText(text:String, width:Number, location:Point, textFormat:TextFormat):void {
			displayText.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			displayText.y = location.y;
			displayText.x = location.x;
			displayText.width = width;
			displayText.defaultTextFormat=textFormat;
			displayText.text = text;
			addChild(displayText);
		}
		
		public function createOkButton(text:String,location:Point, width:Number, height:Number, textFormat:TextFormat, offColor:uint=0x000000, overColor:uint=0xff0000, positionOffset:Number=0):void {
			useImageButton = false;
			okButton = new SimpleBlitButton(location.x, location.y, width, height, text, 0xffffff, 0xff0000, textFormat, positionOffset);
			addChild(okButton);
			okButton.addEventListener(MouseEvent.MOUSE_OVER, okButtonOverListener, false, 0, true);
			okButton.addEventListener(MouseEvent.MOUSE_OUT, okButtonOffListener, false, 0, true);
			okButton.addEventListener(MouseEvent.CLICK, okButtonClickListener, false, 0, true);
		}
	
		public function createImageButton(imageOff:BitmapData,  imageOver:BitmapData, location:Point):void {
			useImageButton = true;
			imageButton = new ImageButton(imageOff, imageOver, location);
			imageButton.addEventListener(MouseEvent.MOUSE_OVER, okButtonOverListener, false, 0, true);
			imageButton.addEventListener(MouseEvent.MOUSE_OUT, okButtonOffListener, false, 0, true);
			imageButton.addEventListener(MouseEvent.CLICK, okButtonClickListener, false, 0, true);
			addChild(imageButton);
		}
		
		
		
		public function setDisplayText(text:String):void {
			displayText.text = text;
		}
		
		
		//Listener functions 
		//okButtonClicked fires off a custom event and sends the "id" to the listener.
		private function okButtonClickListener(e:MouseEvent):void {
			dispatchEvent(new CustomEventButtonId(CustomEventButtonId.BUTTON_ID,id));
		}
		
		private function okButtonOverListener(e:MouseEvent):void {
			
			if (useImageButton) {
				imageButton.changeButton(ImageButton.OVER);
			}else{
				okButton.changeBackGroundColor(SimpleBlitButton.OVER);
			}
		}
		
		private function okButtonOffListener(e:MouseEvent):void {
			if (useImageButton) {
				imageButton.changeButton(ImageButton.OFF);
			}else{
				okButton.changeBackGroundColor(SimpleBlitButton.OFF);
			}
		}
		
	}
	
}