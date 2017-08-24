package com.efg.framework 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.filters.ColorMatrixFilter;

	/**
	 * ...
	 * @author ...
	 */
	public class BlitArrayAsset 
	{
		
		public var tileList:Array;
		private var point0:Point = new Point(0, 0);
		
		
		public function createFadeAndRotateArrayFromBD(sourceBitmapData:BitmapData, inc:int, offset:int = 0):Array {
			
			
			tileList = [];
			
			
			var rotation:int = offset; 
			
			while (rotation<(360+offset)){
				var angleInRadians:Number = Math.PI * 2 * (rotation / 360);
				var rotationMatrix:Matrix = new Matrix();
				rotationMatrix.translate(-sourceBitmapData.width*.5,-sourceBitmapData.height*.5);
				rotationMatrix.rotate(angleInRadians);
				rotationMatrix.translate(sourceBitmapData.width*.5,sourceBitmapData.height*.5);
				var matrixImage:BitmapData = new BitmapData(sourceBitmapData.width, sourceBitmapData.height, true, 0x00000000);
				matrixImage.draw(sourceBitmapData, rotationMatrix);
				tileList.push(matrixImage.clone());
				rotation += inc;
				matrixImage.dispose();
				matrixImage = null;
				rotationMatrix = null;
			}
			
			trace("tileList.length=" + tileList.length);
			trace("tileList[0]=" + tileList[0]);
			var steps:int = tileList.length-1;
			var stepAmount:Number = 1 / steps;
			
			for (var ctr:int = 0; ctr <= steps; ctr++) {
				trace("tileList[ctr]=" + tileList[ctr]);
				var tempBitmapData:BitmapData = tileList[ctr].clone();
				var alpha:Number=1 - (ctr*stepAmount)
				var alphaMatrix:ColorMatrixFilter = new ColorMatrixFilter(
												[1,0,0,0,0,
												0, 1, 0, 0, 0,
												0, 0, 1, 0, 0,
												0, 0, 0, alpha, 0]);
				
				
				tempBitmapData.applyFilter(tempBitmapData, tempBitmapData.rect, point0, alphaMatrix);
				
				tileList[ctr] = tempBitmapData.clone();
				tempBitmapData.dispose();
				alphaMatrix = null;
				
				
			}						
			
			
			return(tileList);
		}
		
		
		public function createRotationBlitArrayFromBD(sourceBitmapData:BitmapData, inc:int, offset:int = 0):Array {
			trace("sourceBitmapData.width=" + sourceBitmapData.width);
			trace("sourceBitmapData.height=" + sourceBitmapData.height);
			tileList = [];
			var rotation:int = offset; 
			
			while (rotation<(360+offset)){
				var angleInRadians:Number = Math.PI * 2 * (rotation / 360);
				var rotationMatrix:Matrix = new Matrix();
				rotationMatrix.translate(-sourceBitmapData.width*.5,-sourceBitmapData.height*.5);
				rotationMatrix.rotate(angleInRadians);
				rotationMatrix.translate(sourceBitmapData.width*.5,sourceBitmapData.height*.5);
				var matrixImage:BitmapData = new BitmapData(sourceBitmapData.width, sourceBitmapData.height, true, 0x00000000);
				matrixImage.draw(sourceBitmapData, rotationMatrix);
				tileList.push(matrixImage.clone());
				rotation += inc;
				matrixImage.dispose();
				matrixImage = null;
				rotationMatrix = null;
			}
			return(tileList);
			
		}
		
		public function createFadeOutBlitArrayFromBD(sourceBitmapData:BitmapData, steps:int ):Array{
			var stepAmount:Number = 1 / steps;
			tileList = [];
			
			for (var ctr:int = 0; ctr <= steps; ctr++) {
				var alpha:Number=1 - (ctr*stepAmount)
				var alphaMatrix:ColorMatrixFilter = new ColorMatrixFilter(
												[1,0,0,0,0,
												0, 1, 0, 0, 0,
												0, 0, 1, 0, 0,
												0, 0, 0, alpha, 0]);
				var matrixImage:BitmapData = new BitmapData(sourceBitmapData.width, sourceBitmapData.height, true, 0x00000000);
				matrixImage.applyFilter(sourceBitmapData, matrixImage.rect, point0, alphaMatrix);
				tileList.push(matrixImage.clone());
				matrixImage.dispose();
				matrixImage = null;
				alphaMatrix = null;
			}								
			return(tileList);
		}
	
		
	}
	
}