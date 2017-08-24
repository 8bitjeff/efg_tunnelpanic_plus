package com.efg.framework.particles {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class SimpleBitmapParticleExplosion extends Sprite {
	
	public var MAXPARTICLES: Number;
	public  var TParticle:Array;
	
	public  var velocity:Number, gravity:Number, angle:Number, life:Number;
	public  var particleDepth:Number, time_increment:Number, disbursement:Number, scale:Number;
	public  var color1:Number, t_rotation:Number;
	public  var active:Boolean, fade:Boolean;	
	public  var finished:Boolean = false, started:Boolean = false;
	public  var glow:Boolean = false;
	public  var glow_percent:Number = 0;
	public  var moveInt:Number;
	public  var particleBitmapData:BitmapData;
	public  var tempParticle:SimpleBitmapParticle;
	
	//[Embed(source = "explodepart.gif")]
	//private var ExplodeParticle:Class;
	
	public function SimpleBitmapParticleExplosion(i:int) {
		
		MAXPARTICLES = 0;
		velocity=0;
		gravity =0;
		angle = 0;
		life = 0;
		fade = false;
		glow = false;
		particleDepth = 1;
		time_increment = 10;
		disbursement = 0;
		
		scale = 0;
		t_rotation = 0;
		color1 = 0;
		finished = false;
		TParticle = new Array();	
		//particleBitmapData = new ExplodeParticle().bitmapData;
		particleBitmapData = new BitmapData(1,1, false, 0xFF0000);
	}
	
	//Set parent timeline
	
	
	//X,Y pos of explosion
	public function setLocation(px:Number, py:Number):void  {
		this.x = px;
		this.y = py;
	}
	
	public function setParticleBitmapData(pbmd:BitmapData) :void {
		particleBitmapData = pbmd;
	}
	
	//Number of particles
	public function setMaxParticles(max:Number):void  {
		MAXPARTICLES = max;
	}
	//Velocity of particles
	public function setVelocity(v:Number):void  {
		velocity=v;
	}
	//Gravitational pull on particles
	public function setGravity(g:Number):void  {
		gravity=g;
	}
	//Direction of particles (works with dispursement)
	public function setAngle(a:Number):void  {
		angle=a;
	}
	//degress to launch particles. 180 = 1/2, 360 = full circle. works with angle
	public function setDisbursment(d:Number):void  {
		disbursement = d;
	}
	//Max life of particles
	public function setLife(l:Number) :void  {
		life=l;
	}	
	//Don't mess with this unless you know what you are doing
	public function setTimeIncrement(t:Number) :void  {
		time_increment = t;
	}
	//fade particles...or not
	public function setFade(f:Boolean):void  {		
		fade=f;
	}
	
	//fade particles...or not
	public function setGlow(g:Boolean):void  {		
		glow=g;
	}
	
	public function setGlowPercent(gp:Number) : void{
		glow_percent = gp;
	}
	

	
	//Max scale-up
	public function setScale(s:Number):void  {		
		scale = s;
	}
	//Maximum t_rotation rate
	public function setRotation(r:Number):void  {
		t_rotation = r;
	}
	//Start Color
	public function setStartColor(c:Number):void  {
		color1=c;
	}
	
	
	
	//function onEnterFrame () {
		//if (started) {
			//move();		
		//}
	//}
	
	
	public function start() : void {
		
		var m:Number;
		var f:Number;
		var n_angle:Number;
		var n_life:Number;
		var n_time:Number;
		var n_active:Boolean;
		var n_velocity:Number;
		
		
		
		
		for (var i:int =0;i<MAXPARTICLES;i++) {
			 n_velocity = Math.random()*(velocity/2) + velocity;
			
			
			//Calculate Angle
			if (angle<999) {
				if ((Math.random()*1) == 0) {
					m = -1;
				} else {
					m = 1;
				}
				n_angle = -angle + m * Math.random()*disbursement;
			} else {
				n_angle = Math.random()*360;
			}
			//
			
			//Calculate Life
			f = (Math.random()*100+80)/100;
			n_life = Math.round(life * f);
			//
			n_time = 0;
			n_active = true;
			
			
			
			var part:SimpleBitmapParticle = new SimpleBitmapParticle(particleBitmapData, n_velocity, n_angle, n_life, gravity, n_time, n_active, fade,  scale, t_rotation, color1, glow, glow_percent);
			TParticle.push(part);
			this.addChild(part);
			
		}
		
		finished = false;
		//moveInt = setInterval(move,50);
		
	};
	
	public function update() :void {
	}
	
	public function render() :void {				
		var i:Number, partactive:Boolean;
		
		if (MAXPARTICLES  > 0 ) {
			
			for (i=TParticle.length-1;i >= 0;i--) {
				partactive = TParticle[i].move(time_increment);
				tempParticle = TParticle[i];
				if (!partactive) {
					tempParticle.dispose();
					removeChild(tempParticle);	
					TParticle.splice(i,1);
					MAXPARTICLES--;
					
					
				}
			}
			
		} else {
			
			
			
			finished = true;
		}
		
	}
	
	public function dispose() : void {
	
		}
		
		
	}
}



