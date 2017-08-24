package com.efg.framework 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class CollisionUtils
	{
		
		public static function circleIntersect(x1:Number, x2:Number, y1:Number, y2:Number, radius1:Number, radius2:Number):Boolean{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			return dist < radius1 + radius2 
		}
		
		public static function  boundingBoxCollide(object1:flash.display.DisplayObject, object2:flash.display.DisplayObject):Boolean {
			var left1:Number = object1.x;
			var left2:Number = object2.x;
			var right1:Number = object1.x + object1.width*.90;
			var right2:Number = object2.x + object2.width*.90;
			var top1:Number = object1.y;
			var top2:Number = object2.y;
			var bottom1:Number = object1.y + object1.height*.90;
			var bottom2:Number = object2.y + object2.height*.90;
			
			if (bottom1 < top2) return(false);
			if (top1 > bottom2) return(false);
			
			if (right1 < left2) return(false);
			if (left1 > right2) return(false);
			
			return(true);
			
		}
		
		
		
		
		
	}

}