/**
* ...
* @author Default
* @version 0.1
*/

package com.efg.framework.particles {
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
		
	public class ParticleExplosion extends Sprite {
		public var completed:Boolean=false;
		public var started:Boolean=false;
		private var aParticles:Array=[];
		private var container:Sprite;
		private var numParticles:Number=0;
		private var velocityMin:Number;
		private var velocityMax:Number
		private var lifespan:Number; // number of franes to run the explosion
		private var angle:Number; //0-360  example: 0 + dispursement of 360 = full circle
		private var gravity:Number;
		private var fade:Boolean; // false will not fade
		private var fadeStart:Number; // 0-1 the start alpha of particle;
		private var dispursement:Number; // added to angle randomly ro create spread of a certain amount 0-360
		private var scale:Number; // holds scale of particles 1=100%, 2=200%,... .5=50%
		private var fadeCoef:Number;// makes fade last as long as life
		private var aTriangle:Array=[]; // holds array of user created shapes to add to particle
		private var aLibrarySymbol:Array=[];
		private var aBitmapLibrarySymbol:Array=[];
		
		//containerval,xval,yval,numparticles,scaleval,velocityminval,velocitymaxvallifespanval,gravityval,angleval,dispursementval,fadeval,fadestartval
		//testParticle.fla shows the basics of using the ParticleExplosion calss
		//ParticleExplosion takes these paramaters
		//1. container: the partent sprite or MC that the explosion will be in
		//2. x - the center x positon for the explosion
		//3. y - the center y position for the explosion
		//4. numParticles - the number of particles for this explosion
		//5. scale - the over all scale for the entire explosion 1=100%, 2=200%
		//6. velocityMin - the minmum velocity for the particles if it is the same as the velocityMax
		//   then all particles will move at same speed 
		//7. velocityMax - the max velocity for particles. If this is different than min, it will randomly
		//   choose a velocity between max and min for each particle
		//8. lifespan - the number of frames that this particle will live
		//9. gravity - currently unused
		//10. angle - the initial angle that all particles will travel
		//11. dispusement - the spread of particles taking then initial angle into account. An angle of 0
		// 	  and dipursement of 360 will make a circle explosion
		//12. fade - boolean to turn alpha out on the particle. The alpha out aill be uniform ovre the lifepan
		//	  starting with this value. use 1 for a normal fade out
		//***Public Methods:
		//currently, the only way to add content is with the addTriangle method
		//addTriangle(outlineColor:Number,fillColor:Number,scale:Number,xpos:Number,ypos:Number, rotation:Number):void{
		//1. outlineColor - the color for the line around the triangle in format 0xffffff
		//2. fillColor - the for the fill of the triangle - 0xff00ff
		//3. scale 1=100% for this triangle
		//4. x - the x position in the particle for this triangle
		//5. y - the y position in this particle fpr this triangle
		//6. rotation - the angle rotation for this triangle
		//createParticles() - this will create particles and start the explosion
		//run() need to call this on frame or interval to update the particles
		
		//***Public valiables
		//started - this will be true after createParticles() is created
		//completed - this will be flase until all particles have completed their lives

		
		public function ParticleExplosion(containerval:Sprite,xval:Number, yval:Number,numParticlesval:Number, scaleval:Number,velocityminval:Number,velocitymaxval:Number,lifespanval:Number,gravityval:Number,angleval:Number, dispursementval:Number,fadeval:Boolean,fadestartval:Number):void {
		    //create simple state machine to handle states
			//runs throug
			numParticles=numParticlesval;
			container=containerval;
			started=true;
			velocityMin=velocityminval;
			velocityMax=velocitymaxval;
			lifespan=lifespanval;
			gravity=gravityval;
			angle=angleval;
			dispursement=dispursementval;
			fade=fadeval;
			fadeStart=fadestartval;
			x=xval;
			y=yval;
			scale=scaleval;
			fadeCoef=fadestartval/lifespan;
			trace("fadeCoef=" + fadeCoef);
			scaleX=scale;
			scaleY=scale;
		}
		
		public function addTriangle(outlineColor:Number,fillColor:Number,scale:Number,xpos:Number,ypos:Number, rotation:Number):void{
			var tempObj:Object={};
			tempObj.outlineColor=outlineColor;
			tempObj.fillColor=fillColor;
			tempObj.scale=scale;
			tempObj.xpos=xpos;
			tempObj.ypos=ypos;
			tempObj.rotation=rotation;
			aTriangle.push(tempObj);
			
				
		}
		
		public function addLibrarySymbol(classInstance:MovieClip,scale:Number,xpos:Number,ypos:Number, rotation:Number):void{
			//must pass a reference to a class symbol from the library: ex: new Particle_square()
			var librarySymbol:MovieClip = classInstance;
			librarySymbol.x=xpos;
			librarySymbol.y=ypos;
			librarySymbol.scale=scale;
			librarySymbol.rotation=rotation;
			
			trace("librarySymbol.x="+ librarySymbol.x);
			trace("librarySymbol.y="+ librarySymbol.y);
			trace("librarySymbol.width="+ librarySymbol.width);
			trace("librarySymbol.height="+ librarySymbol.height);
			
			var tempBitmap:BitmapData=new BitmapData(librarySymbol.width, librarySymbol.height,true,0x000000);
			tempBitmap.draw(librarySymbol,new Matrix());
			aBitmapLibrarySymbol.push(tempBitmap);
			aLibrarySymbol.push(librarySymbol);
			
			
			
		}
		
		public function createParticles():void {
			for (var i:int = 0;i<numParticles;i++) {
				//x,y,scale,alpha,rotation,dx,dy,lifespan,acceleration
				var part:Particle = new Particle();
				for (var ctr:Number=0;ctr<aTriangle.length;ctr++) {
					var tempObj:Object=aTriangle[ctr];
					var triangle:Shape=new Shape();
					triangle.graphics.beginFill(tempObj.fillColor,1);
					triangle.graphics.lineStyle(2,tempObj.outlineColor);
					triangle.graphics.lineTo(5,5);
					triangle.graphics.lineTo(10,0);
					triangle.graphics.lineTo(0,0);
					triangle.graphics.endFill();
					triangle.x=(tempObj.xpos)-(.5*triangle.width);
					triangle.y=(tempObj.ypos)-(.5*triangle.height);
					triangle.scaleX=tempObj.scale;
					triangle.scaleY=tempObj.scale;
					//tempContainer.addChild(triangle)
					part.shapeContainer.addChild(triangle);
				}
				
				for (ctr=0;ctr<aBitmapLibrarySymbol.length;ctr++) {
					var bmp:Bitmap=new Bitmap(aBitmapLibrarySymbol[ctr]);
					var tempSprite:Sprite=new Sprite();
					tempSprite.addChild(bmp);
					
					
					tempSprite.scaleX=aLibrarySymbol[ctr].scale;
					tempSprite.scaleY=aLibrarySymbol[ctr].scale;
					trace("bmp.width=" + bmp.width);
					trace("bmp.height=" + bmp.height);
					trace("bmp.x=" + bmp.x);
					trace("bmp.y=" + bmp.y);
					
					
					part.shapeContainer.addChild(tempSprite);
					
					
					}
				//create bitmapData to hold entire particle
				//var tempBitmapData:BitmapData=new BitmapData(tempContainer.width,tempContainer.height,true,0x000000);
				//tempBitmapData.draw(tempContainer,new Matrix());
				//var tempbmp:Bitmap=new Bitmap(tempBitmapData);
				//part.shapeContainer.addChild(tempbmp);
					
				//center entire shape continer for origin is in middle
				trace("part.shapeContainer.x=" + part.shapeContainer.x);
				trace("part.shapeContainer.y=" + part.shapeContainer.y);
				part.shapeContainer.x=-(.5*part.shapeContainer.width);
				part.shapeContainer.y=-(.5*part.shapeContainer.height);
				trace("part.shapeContainer.width=" +part.shapeContainer.width);
				trace("part.shapeContainer.height=" + part.shapeContainer.height);
				trace("part.shapeContainer.x=" + part.shapeContainer.x);
				trace("part.shapeContainer.y=" + part.shapeContainer.y);
				
				//choose velocity bewteen min and max
				part.velocity=velocityMin+(Math.floor(Math.random()*(velocityMax+1 - velocityMin)));
				trace("velocityMin=" + velocityMin);
				trace("velocityMax=" + velocityMax);
				trace("part" + i + " velocity=" + part.velocity);
				part.x_next=0;
				part.y_next=0;
				
				
				part.lifespan=(Math.random()*lifespan)+lifespan/2;
				part.rotation_next=(Math.floor(Math.random()*359));
				var randDispurasement=(Math.floor(Math.random()*dispursement))
				var tempAngle:Number=angle+randDispurasement;
				
				part.dx=part.velocity*(Math.cos(2.0*Math.PI*(tempAngle-90)/360));
				part.dy=part.velocity*(Math.sin(2.0*Math.PI*(tempAngle-90)/360));
				//part.dx=(Math.cos(part.velocity*Math.PI*(tempAngle-90)/180));
				//part.dy=(Math.sin(part.velocity*Math.PI*(tempAngle-90)/180));
				part.fade=fade;
				part.alpha_next=fadeStart;
				
				part.render();
				aParticles.push(part);
				addChild(part);
				
			}
			started=true;
			trace("explode started");
		}
		
		
		
		public function run() {
			//this is called  externally on an interval to control entire explsion.
			//this will boradcast run event to particles so they will run on time too
			if (aParticles.length >0) {
				moveParticles();
			}else{
				completed=true;
			}
			
			
		}
		
		public function moveParticles() {
			//loop though particles and update info.
			//if lifecount  > lifespan remove
			
			// if started, but not complete and aParticles.length ==0 then set completed to true
			//also broadcast an event that it is true to the caller.
			
			for (var i:int = aParticles.length-1;i>=0;i--) {
				var part:Particle=aParticles[i];
				part.x_next+=part.dx;
				part.y_next+=part.dy;
				
				part.lifecount++;
				if (part.lifecount > part.lifespan) {
					removeChild(part);
					aParticles.splice(i,1);
				}
				
				
				part.rotation_next+=10;
				if (part.rotation_next <-180) {
					part.rotation_next=0;
				}
				
				
				if (part.fade) {
					part.alpha_next-=fadeCoef;
				}	
				part.render();
				
			}
			
			
		}
		
		
		
		
	}
	
}
