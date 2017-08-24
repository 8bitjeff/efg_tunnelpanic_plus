package  com.efg.framework
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import com.efg.framework.TileSheet;

	/**
	 * ...
	 * @author ...
	 */
	public class AdvancedBlitArrayObject extends BasicBlitArrayObject{

		
		public function AdvancedBlitArrayObject(xMin:int,xMax:int, yMin:int, yMax:int, tileSheet:TileSheet, animationTiles:Array, startFrame:int) 
		{
			super(xMin, xMax, yMin, yMax);
			trace("start blit copy");
			var tilesPerRow:int=tileSheet.tilesPerRow;
			var tileSize:int = tileSheet.tileWidth;
			var rect:Rectangle = new Rectangle();
			var point:Point = new Point(0, 0);
			
		
			
			for (var ctr:int = 0; ctr < animationTiles.length; ctr++) {
				trace("ctr=", ctr);
				trace("animationList.length=", animationList.length);
				var tileNum:int = animationList[ctr];
				var sourceX:int=(tileNum % tilesPerRow)*tileSize;
				var sourceY:int = (int(tileNum / tilesPerRow)) * tileSize;
				rect.x = sourceX;
				rect.y = sourceY;
				rect.height = tileSize;
				rect.width = tileSize;
				var tileBitmapData:BitmapData=new BitmapData(tileSize,tileSize,true,0x00000000);
				tileBitmapData.copyPixels(tileSheet.sourceBitmapData,rect,point);
				animationList.push(tileBitmapData);
			}
			
		}
		
	}

}