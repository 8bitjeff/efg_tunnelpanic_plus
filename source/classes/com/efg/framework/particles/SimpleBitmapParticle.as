package com.efg.framework.particles {
	

import flash.display.BitmapData;
import flash.display.Bitmap;

import flash.filters.*;

public class SimpleBitmapParticle extends Bitmap {
	public var px:Number, py:Number, vi:Number, angle:Number, life:Number, r:Number, g:Number, b:Number, time:Number, gravity:Number, depth:Number;
	public var MAXLIFE:Number, scale:Number, t_rotation:Number, color1:Number, color2:Number, colorToUse:Number;
	public var active:Boolean, fade:Boolean, colorO1:Number;
	public var glow:Boolean;
	public var glow_percent:Number;
	public var glow_up:Boolean;
	public var glowx:Number;
	public var glowy:Number;
	public var glow_strength:Number;
	public var bitmapsize:Number = 1;
	public var partBitmapData:BitmapData;
	
	
	
	
	public function SimpleBitmapParticle  (partBitmapData:BitmapData, t_vi:Number, t_angle:Number, t_life:Number, t_gravity:Number, t_time:Number, t_active:Boolean, t_fade:Boolean, t_scale:Number, t_rotation:Number, t_color1:Number,t_glow:Boolean, t_glowpercent:Number) {
		
		//this.bitmapsize = bitmapSize;
		//this.bitmapsize = 1;
		x=0
		y = 0
		//partBitmapData = new BitmapData(bitmapsize, bitmapsize, false, t_color1);
		
		//partBitmapData = new ExplodeParticle().bitmapData;
		this.bitmapData = partBitmapData;
		
		
		vi=t_vi;
		angle = t_angle;
		life = t_life;
		fade = t_fade;
		glow = t_glow;
		glow_percent = t_glowpercent;
		if (glow) {
			var rand:Number = Math.floor(Math.random() * 100);
			if (rand < glow_percent) {
				glow=true;
			} else {
				glow=false;
			}
		}
		MAXLIFE=life;
		gravity = t_gravity;
		
		time = t_time;
		
		active=t_active;
		
		scale = t_scale;
		color1 = t_color1;
		
		this.t_rotation = Math.random()* t_rotation;
		
		this.scaleX = scale;
		this.scaleY = scale ;
		
		glow_up=true;
		glowx = 0
		glowy = 0
		glow_strength = 15;
		
		}
	public function move(dtime:Number) : Boolean {			
		if (active) {
			
			var t:Number;
			var retval:Boolean;		
			time+=dtime;
			t = time/1000;
			px = vi *Math.cos(angle*Math.PI/180) * t;
			py = vi *Math.sin(angle*Math.PI/180) * t + (gravity*t*t/2);
			if (fade) {
				//this.alpha -= (100/(MAXLIFE/dtime))*.1;
				
				}
				
			if (glow) {
				if (glow_up) {
					glowx+=1;
					glowy+=1;
					glow_strength-=1;
				} else {
					glowx-=1;
					glowy-=1;	
					glow_strength+=1;
				}
				if (glow_up && glowx > 8) {
					glow_up=false;		
				}
	
				if (!glow_up && glowx < 0) {
					glow_up=true
				}
				this.filters=[new GlowFilter(color1 ,80,glowx,glowy,glow_strength,2,false,false)];
			}
			if (time >= life) {				
				//this.removeMovieClip();
				active=false;			
			} else {
				active=true;					
			}
			x=px;
			y=py;
			if (rotation > 0) {
				//this.rotation+=t_rotation;
			}
			} else {
			active=true;	
		}
		return active;
	}		
		
	public function dispose() :void {
		//bitmapData.dispose();
		}
	
	
	}
}



