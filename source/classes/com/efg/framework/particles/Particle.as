/**
* ...
* @author Default
* @version 0.1
*/

package com.efg.framework.particles {
	import flash.display.Sprite;
		
	public class Particle extends Sprite {
		public var dx:Number;
		public var dy:Number;
		public var x_next:Number; // holds the next xpos before render
		public var y_next:Number; //holds the next ypos before render
		public var alpha_next:Number; // holds the next alpha before render
		public var lifespan:Number; // holds # of cycles of frames tgis particle is alive
		public var rotation_next:Number; // holds the next rotation before render
		public var velocity:Number;
		public var lifecount:Number=0;
		public var fade:Boolean; // true = fade out alpha
		public var shapeContainer:Sprite=new Sprite();
		public function Particle():void {
			trace("particle created");
		}
		
		
		public function render():void {
			x=x_next;
			y=y_next;
			rotation=rotation_next;
			alpha=alpha_next;
			addChild(shapeContainer);
		}
		
	}
	
}
