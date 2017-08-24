package com.efg.framework.classicarcade 
{
	import com.efg.framework.BlitSprite;
	import com.efg.framework.TileSheet;
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class SpaceRockBlitSprite extends BlitSprite {
		
		public var moveSpeed;
		
		
		public function SpaceRockBlitSprite(tileSheet:TileSheet, tileList:Array, firstFrame:int)  {
			super(tileSheet, tileList, firstFrame);
		}
		
		public function update():void {
			
		}
		
	}

}