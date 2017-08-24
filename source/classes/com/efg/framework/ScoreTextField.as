package  com.efg.framework
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class ScoreTextField extends Sprite
	{
		
		public var textField:TextField = new TextField();
		public var life:int;
		public var lifeCount:int;
		public var useMove:Boolean = false;
		public var useFade:Boolean = false;
		public var dx:Number=0;
		public var dy:Number = 0;
		public var value:Number=0; // temporary data storage
		public var endPoint:Point;
		public var rotateIncrement:int = 0;
		
		
		public function ScoreTextField(text:String, textFormat:TextFormat,x:Number,y:Number, life:int, value:Number=0) {
			this.x = x;
			this.y = y;
			this.life = life;
			this.lifeCount = 0;
			this.value = value;
			
			textField.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			textField.defaultTextFormat = textFormat;
			textField.selectable = false;
			textField.text = text;
			
			//textField.width = textField.textWidth;
			textField.height = textField.textHeight;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.x = -textField.textWidth * .5;
			textField.y = -textField.textHeight * .5;
			addChild(textField);
		}
		
		public function setMove(endPoint:Point, speed:Number):void {
			useMove = true;
			
			var xd:Number  = endPoint.x - x;
			var yd:Number  = endPoint.y - y;
			var distance:Number  = Math.sqrt(xd * xd + yd * yd);
			
			life = Math.floor(Math.abs(distance/speed));
			//trace("life=" + life);
			
			dx = (endPoint.x - x)/life;
			dy= (endPoint.y - y)/life;
			
		}
		
		public function setFade(life:int):void {
			
			
			useFade = true;
		}
		
		
		
		public function update():Boolean{
			//trace("scoreText update");
			var removeMe:Boolean = false;
			
			
			lifeCount++;
			if (lifeCount > life) {
				removeMe= true;
			}else {
				removeMe=false;
			}
			
			if (useMove) {
				x += dx;
				y += dy;
			}
			
			if (useFade) {
				//needs to be used with a life
				if (lifeCount <= life) {
					
					alpha -= 1 * (life/1000);
					//trace("lifeCount=" + lifeCount);
					//trace("alpha=" + alpha);
					if (alpha <= 0) {
						removeMe = true;
					}
				}
				
			}
			rotation += rotateIncrement;
			
			return removeMe;
			
		}
		
		public function dispose():void {
			removeChild(textField);
			textField = null;
		}
		
	}

}
