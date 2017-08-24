package com.efg.framework 
{
	import flash.sampler.NewObjectSample;
	
	/**
	 * ...
	 * Translation of Robert Penner's Vector Class into AS3
	 */
	public class MathVector 
	{
		public var x:Number;
		public var y:Number;
		
		public function MathVector(x:Number, y:Number) {
			reset(x, y);
		}
		
		public function toString():String {
			var rx:Number = Math.round(x * 1000) / 1000;
			var ry:Number = Math.round(y * 1000) / 1000;
			
			return "[" + rx + ", " + ry + "]";
		}
		
		public function reset(x:Number,y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		public function getClone():MathVector {
			return new MathVector(this.x, this.y);
		}
		
		public function equals(v:MathVector):Boolean {
			return (this.x == v.x && this.y = v.y);
		}
		
		public function plus(v:MathVector):void {
			this.x += v.x;
			this.y += v.y;
		}
		
		public function plusNew(v:MathVector):MathVector {
			return new MathVector(this.x + v.x, this.y + v.y);
		}
		
		public function minus(v:MathVector):void {
			this.x -= v.x;
			this.y -= v.y;
		}
		
		public function minusNew(v:MathVector):MathVector {
			return new MathVector(this.x - v.x, this.y - v.y);
		}
		
		public function negate():void {
			//negation is reversing the vector
			this.x = -this.x;
			this.y = -this.y;
		}
		
		public function negateNew():MathVector {
			return new MathVector(this.x, - this.y);
		}
		
		public function scale(scale:Number):void {
			//changes length od vector by scale
			this.x *= scale;
			this.y *= scale;
		}
		
		public function scaleNew(scale):MathVector {
			return new MathVector(this.x * scale, this.y * scale);
		}
		
		public function getLength():Number {
			return Math.sqrt (this.x * this.x + this.y * this.y);
		}
		
		public function setlength(length:Number):void {
			var r:Number = this.getLengh();
			if (r) {
				this.scale(length / r);
			}else {
				this.x = length;
			}
		}
		
		public function getAngle():Number {
			return Math.atan2(this.y, this.x) * (180/Math.PI);
		}
		
		public function setAngle(angle:Number):void {
			var r:Number = this.getLength();
		}
		
		public function getAngle():Number {
			return Math.atan2(this.y, this.x) * (180/Math.PI);
		}
		
		public function setAngle():void {
			var r:Number = this.getLength();
			this.x = r * Math.cos(angle*(Math.PI/180));
			this.y = r * Math.sin(angle*(Math.PI /180));
		}
		
		public function rotate(angle:Number):void {
			var ca:Number = Math.cos(angle * (Math.PI / 180));
			var sa:Number = Math.sin(angle * (Math.PI / 180));
			with (this) {
				var rx:Number = x * ca - y * sa;
				var ry:Number = x * sa - y * ca;
				x = rx;
				y = ry;
			}
		}
		
		public function rotateNew(angle:Number):MathVector {
			var v:MathVector = new MathVector(this.x, this.y);
				v.rotate(angle);
				return v;
		
		}
		
		public function dot(v:MathVector):Number {
			//returns dot product of this vector multiplied by the passed in vector
			return (this.x * v.x + this.y * v.y);
		}
		
		public function getNormal():MathVector {
			return new MathVector( -this.y, this.x);
		}
		
		public function isPerpTo(v:MathVector):Boolean {
			return (this.dot(v) == 0);
		}
		
		public function angleBetween(v:MathVector):Number {
			var dp:Number = this.dot(v);
			var cosAngle:Number = dp / (this.getLength() * v.getLength());
			return Math.acos(cosAngle * (Math.PI / 180));
		}
		
		
		
	}
	
}