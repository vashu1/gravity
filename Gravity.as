package
{
	import flash.display.*;
	import flash.events.*;
	
	import flash.external.*;
	import flash.system.System;
	
	import mx.controls.SWFLoader;
	import mx.core.*;
	import mx.utils.*;
	import mx.controls.Alert;
	import flash.utils.getTimer; 

	public class Gravity
	{
	
public static function sleep(ms:int):void {
    var init:int = getTimer();
    while(true) {
        if(getTimer() - init >= ms) {
            break;
        }
    }
}
	
		public static var view:SWFLoader = FlexGlobals.topLevelApplication.view;
		public static var app:Object = FlexGlobals.topLevelApplication;
		public static var path_data:BitmapData = new BitmapData(3000, 3000, true, 0x00000000);
		public static var path_canvas:Bitmap = new Bitmap(path_data);
		public static var particles:Vector.<Particle> = new Vector.<Particle>;
		private static var h:Number;
		public static var num_particles:Number;
		
		public static var temp:Number = 0;
		
		public static var particle_history:Vector.<Particle> = new Vector.<Particle>;
		
		public static function init():void
		{	
			FlexGlobals.topLevelApplication.parent.parent.frameRate = 60;
			h=1/200;
			view.addChild(path_canvas);
			view.scaleX = 1;
		}
		
		public static function main():void
		{
			integrate();
			Particle.draw();
			num_particles = particles.length;
			app.particle_quantity.text = "Particles: "+num_particles;
		}
		
		private static function integrate():void
		{
			var new_particles:Vector.<Particle> = new Vector.<Particle>;
			for each (var particle:Particle in particles)
			{
				var acceleration_x_sum:Number = 0;
				var acceleration_y_sum:Number = 0;
				
				for each (var other_particle:Particle in particles)
				{
					if (!(particle == other_particle) && !particle.collided && !other_particle.collided)  // prevents computing force with itself. 
																										  // !particle.collided prevents further calculations for any previously collided particles. This is necessary to not create multiple particles for a single collision event which causes a collision chain reaction of new particles.
																										  // !other_particle.collided is the other side of the coin, making sure the particle being compared against has not already collided.
					{								   
						var x_diff:Number = (other_particle.pos_x - particle.pos_x);
						var y_diff:Number = (other_particle.pos_y - particle.pos_y);
						var displacement_magnitude:Number = Math.sqrt(x_diff*x_diff + y_diff*y_diff)
						
						if( !((particle.mass < 0.01) && (other_particle.mass < 0.01)) )
						if (displacement_magnitude < particle.radius/1.5 + other_particle.radius/1.5)
						{
							particle.collided = true;
							other_particle.collided = true;
							
							var sum_mass:Number = particle.mass + other_particle.mass;
							var new_particle:Particle = new Particle (particle.mass + other_particle.mass,
																	 (particle.vel_x*particle.mass + other_particle.vel_x*other_particle.mass) / sum_mass,
																	 (particle.vel_y*particle.mass + other_particle.vel_y*other_particle.mass) / sum_mass,
																	 (particle.pos_x*particle.mass + other_particle.pos_x*other_particle.mass) / sum_mass,
																	 (particle.pos_y*particle.mass + other_particle.pos_y*other_particle.mass) / sum_mass)
							new_particles.push(new_particle);
						}

						var acceleration:Number = other_particle.mass/(displacement_magnitude*displacement_magnitude);
						if(other_particle.mass > 0.01) {
							acceleration_x_sum += acceleration*(x_diff/displacement_magnitude);
							acceleration_y_sum += acceleration*(y_diff/displacement_magnitude);
						}
						if(particle_history.length>(30000/10))//30000 - 300 //7000 - 100
						if(particles.length==3) {
							var x1:Number = particles[1].pos_x - particles[0].pos_x;
							var y1:Number = particles[1].pos_y - particles[0].pos_y;
							var l1:Number = Math.sqrt(x1*x1 + y1*y1);
							var x2:Number = particles[2].pos_x - particles[0].pos_x;
							var y2:Number = particles[2].pos_y - particles[0].pos_y;
							var l2:Number = Math.sqrt(x2*x2 + y2*y2);							
							var cosf:Number = (x1*x2+y1*y2)/l1/l2;
							if(cosf < -0.9999) {
								//var dialog_obj1:Object = Alert.show("l " + particle_history.length);
								var msg:String =  "";
								var steps:Number = 150;
								var step:Number = (particle_history.length)/(steps+1);
								for (var i:Number = 0; i < steps; i++) {
									var j:Number = Math.round(i*step);
									msg = msg + ", " + particle_history[j].vel_x  + ", " + particle_history[j].vel_y + ", " + particle_history[j].pos_x  + ", " + particle_history[j].pos_y;
								}
							var myClickHandler:Function = function (evt_obj:Object) {
							 if (evt_obj.detail == Alert.OK) {
							  System.setClipboard(msg);
							 } else if (evt_obj.detail == Alert.CANCEL) {
							 }
							};
							var dialog_obj:Object = Alert.show("Test Alert", "Test", Alert.OK | Alert.CANCEL, null, myClickHandler);  
							}
						}
					}
				}
				particle.acc_x = acceleration_x_sum;
				particle.acc_y = acceleration_y_sum;
				if(particles.length==3)
				if(particle.mass == 0.001) {
					if(temp<10) {
						temp++;
					} else {
					temp = 0;
					//var xn:Number = (particles[1].pos_x-particles[0].pos_x)*(particles[1].mass/particles[0].mass) + particles[0].pos_x;
					//var yn:Number = (particles[1].pos_y-particles[0].pos_y)*(particles[1].mass/particles[0].mass) + particles[0].pos_y;
					var x1:Number = particles[1].pos_x - particles[0].pos_x;
					//x1 = ;
					var y1:Number = particles[1].pos_y - particles[0].pos_y;
					//y1 = ;
					var l1:Number = Math.sqrt(x1*x1 + y1*y1);
					var cos1:Number = x1/l1;
					var sin1:Number = y1/l1;
					var x2:Number = particles[2].pos_x - particles[0].pos_x;
					var y2:Number = particles[2].pos_y - particles[0].pos_y;
					var vx2:Number = particles[2].vel_x - particles[0].vel_x;
					var vy2:Number = particles[2].vel_y - particles[0].vel_y;
					var l2:Number = Math.sqrt(x2*x2 + y2*y2);
					
					var xs:Number =  x2*cos1+y2*sin1;
					var ys:Number = -x2*sin1+y2*cos1;
					var vxs:Number =  vx2*cos1+vy2*sin1;
					var vys:Number = -vx2*sin1+vy2*cos1;
					//var cosf:Number = (x1*x2+y1*y2)/l1/l2;
				
					particle_history.push(new Particle(particle.mass, vxs, vys, xs, ys));
					}
				}
			}
			
			for (var i:Number = 0; i < Gravity.particles.length; i++)
			{
				Gravity.particles[i].vel_x += Gravity.particles[i].acc_x*h;
				Gravity.particles[i].vel_y += Gravity.particles[i].acc_y*h;
				Gravity.particles[i].pos_x += Gravity.particles[i].vel_x*h;
				Gravity.particles[i].pos_y += Gravity.particles[i].vel_y*h;
				if (Gravity.particles[i].collided)
				{
					Gravity.view.removeChild(Gravity.particles[i]);
					Gravity.particles.splice(i,1);
					i-- // Backtracks the index, otherwise the effect of splicing (causing index values of all items beyond splice range to shift down) would cause the next item to be skipped over.
				}
			}

			for each (var new_particle:Particle in new_particles)
			{
				particles.push(new_particle);
				view.addChild(new_particle);
			}
			//sleep(1000);
		}
	}
}