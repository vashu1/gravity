package
{
	import flash.display.*;
	import flash.display.Sprite;
	import flash.geom.*;
	
	import mx.controls.SWFLoader;
	import mx.core.*;
	import flash.utils.*;

	public class Particle extends Sprite
	{
		public var pos_x:Number;
		public var pos_y:Number;
		public var prior_pos_x:Number;
		public var prior_pos_y:Number;
		public var vel_x:Number;
		public var vel_y:Number;
		public var acc_x:Number;
		public var acc_y:Number;
		public var mass:Number;
		public var color:Number;
		public var path:Sprite = new Sprite();
		public var collided:Boolean = false;
		public var radius:Number = 0;
		
		public function Particle(mass:Number, vel_x:Number, vel_y:Number, pos_x:Number, pos_y:Number)
		{
			Gravity.view.addChild(path);
			this.mass = mass;
			this.vel_x = vel_x;
			this.vel_y = vel_y;
			this.pos_x = pos_x;
			this.pos_y = pos_y;
			this.prior_pos_x = pos_x;
			this.prior_pos_y = pos_y;
			this.acc_x = 0;
			this.acc_y = 0;
			var scale_green:uint = ((0x00FF00>>8)/(1+Math.pow(mass/100000, 1)))<<8;
			var scale_blue:uint = 0x0000FF/(1+Math.pow(mass/10000, 1));
			color = 0xFF0000+scale_green+scale_blue;
			var mass_scale:Number = Math.log(Math.E+mass/1000);
			radius = mass_scale;
			if (mass_scale < 3)
			{
				graphics.beginFill(color, 1);
			}else
			{
				graphics.beginGradientFill(GradientType.RADIAL, [color, color], [1,0], [mass_scale*1.7, mass_scale*2.5], null, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			}
			
			if (mass > 0)
			{
				graphics.drawCircle(0, 0, mass_scale);
			} else if (mass < 0)
			{
				Gravity.app.reality.text = "You shouldn't have done that"
				graphics.clear();
				graphics.beginGradientFill(GradientType.RADIAL, [0x0000FF, 0x0000FF, 0x0000FF], [0,1,0], [3,10,20], null, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
				graphics.drawCircle(0, 0, 50);
			}
		}
		
		public static function draw():void
		{
			
			if (Gravity.app.paths.selected)
			{
				for each (var particle:Particle in Gravity.particles)
				if(particle.mass>Gravity.zero_mass)
				{	
					particle.path.graphics.lineStyle(1, particle.color);
					particle.path.graphics.moveTo(particle.prior_pos_x, particle.prior_pos_y);
					particle.path.graphics.lineTo(particle.pos_x, particle.pos_y);
					
					Gravity.path_data.draw(particle.path);
					particle.path.graphics.clear();
				}
			}
			
			for each (var particle:Particle in Gravity.particles)
			{		
				particle.x = particle.pos_x;
				particle.y = particle.pos_y;
				particle.prior_pos_x = particle.pos_x;
				particle.prior_pos_y = particle.pos_y;
			}
		}
		
		public static function delete_particle(particle:Particle):void
		{
			for (var index:String in Gravity.particles)
			{
				if (Gravity.particles[index] == particle)
				{
					Gravity.view.removeChild(DisplayObject(particle));
					Gravity.particles.splice(Number(index),1);
				}
			}
		}
		
		public static function clear():void
		{
			for each (var particle:Particle in Gravity.particles)
			{		
				Gravity.view.removeChild(particle);
			}
			Gravity.particles = new Vector.<Particle>;
			Gravity.path_data.dispose();
			Gravity.path_data = new BitmapData(3000, 3000, true, 0x00000000);
			Gravity.path_canvas = new Bitmap(Gravity.path_data);
			Gravity.view.addChildAt(Gravity.path_canvas, 0);
		}
	}
}