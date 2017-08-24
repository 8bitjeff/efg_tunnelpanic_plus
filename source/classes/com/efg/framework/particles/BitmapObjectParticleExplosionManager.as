package com.efg.framework.particles 
{
	import com.efg.framework.BlitArrayAsset;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class BitmapObjectParticleExplosionManager extends Bitmap {
		
		private var rotateArray:Array;
		private var fadeArray:Array;
		private var fadeAndRotateArray:Array;
		
		private var activeParts:Array;
		private var poolParts:Array;
		
		private var basePartBitmapData:BitmapData;
		
		private var rotateBlitArrayAsset:BlitArrayAsset;
		private var fadeBlitArrayAsset:BlitArrayAsset;
		private var fadeAndRotateBlitArrayAsset:BlitArrayAsset;
		
		//add glowing option?
		private var randomGlow:Boolean = false;
		
		private var tempParticle:BitmapDataParticle;
		
		public function BitmapObjectParticleExplosionManager(basePartBitmapData:BitmapData, poolAmount:int,rotationInc:int, rotationOffset:int, fadeSteps:int, randomGlow:Boolean=false ) {
			this.basePartBitmapData = basePartBitmapData;
			this.randomGlow
			
			fadeAndRotateBlitArrayAsset = new BlitArrayAsset();
			fadeAndRotateBlitArrayAsset.createFadeAndRotateArrayFromBD(basePartBitmapData,rotationInc,rotationOffset);
			fadeAndRotateArray = fadeAndRotateBlitArrayAsset.tileList;
			
			rotateBlitArrayAsset = new BlitArrayAsset();
			rotateBlitArrayAsset.createRotationBlitArrayFromBD(basePartBitmapData,rotationInc,rotationOffset);
			rotateArray = rotateBlitArrayAsset.tileList;
			
			fadeBlitArrayAsset = new BlitArrayAsset();
			fadeBlitArrayAsset.createFadeOutBlitArrayFromBD(basePartBitmapData, fadeSteps);
			fadeArray = fadeBlitArrayAsset.tileList;
			
			if (randomGlow) {
				// fill this out with glow options
			}
			
			
			//create pool
			for (var ctr:int = 0; ctr < poolAmount; ctr++) {
				var newBitmapParticle:BitmapParticle = new BitmapParticle();
				poolParts.push(newBitmapParticle);
			}
			
		}
		
		private function getParticleFromPool():BitmapParticle {
		
				if (activeParts.length > 0) {
					return(activeParts.pop());
					
				}else {
					return (new BitmapParticle());
				}
		}
		
		private function putParticleBackInPool(activeElementId:int) {
			tempParticle = ativeParts[activeElementId];
			//tempParticle.frame = 0;
			poolParts.push(tempParticle);
			activeParts.splice(activeElementId,1);
		}
		
		public function createExplosion(x:Number,y:Number,numParts:int, velocity:Number, gravity:Number, angle:Number, dispursement:Number,useGlow:Boolean ):void {
			
		}
		
	}

}