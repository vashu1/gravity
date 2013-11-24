package
{
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.*;
	
	import mx.utils.*;
	
	public class Interface
	{
		private static var prior_mouse_x:Number = 0;
		private static var prior_mouse_y:Number = 0;
		public static var down_position_x:Number;
		public static var down_position_y:Number;
		private static var down_position_circle:Sprite = new Sprite();
		private static var velocity_line:Sprite = new Sprite();
		Gravity.view.addChild(velocity_line);
		Gravity.view.addChild(down_position_circle);
		
		public static function click_handler(e:MouseEvent):void
		{
			if (e.buttonDown && e.ctrlKey)
			{
				Gravity.app.paths.selected = false;
				path_toggle()
			}
			
			if (e.buttonDown && e.shiftKey && (flash.utils.getQualifiedClassName(e.target) == "Particle"))
			{
				Particle.delete_particle(Particle(e.target));
			}
			
			if (e.buttonDown && !e.ctrlKey && !e.shiftKey)
			{	
				down_position_x = e.stageX;
				down_position_y = e.stageY;
				
				down_position_circle.graphics.beginFill(0x0000FF, 1);
				down_position_circle.graphics.drawCircle(down_position_x, down_position_y, 2);
				
			} else if (!e.ctrlKey && !e.shiftKey)
			{
					velocity_line.graphics.clear();
					down_position_circle.graphics.clear();
					
					var mass:Number = Gravity.app.mass.text;
					if (String(mass) == "NaN" || mass == 0) {mass = 1000; Gravity.app.mass.text = 1000;}
					
					var vel_x:Number = (e.stageX - down_position_x)/1;
					var vel_y:Number = (e.stageY - down_position_y)/1;
					
					var particle:Particle = new Particle(mass, vel_x, vel_y, down_position_x, down_position_y);
					
					Gravity.view.addChild(particle);
					Gravity.particles.push(particle);
			}
		}
		
		public static function mouse_move(e:MouseEvent):void
		{	
			if (e.buttonDown && e.ctrlKey)
			{
				for each (var particle:Particle in Gravity.particles) // Must be stageX delta not localX, otherwise glitches when a particle sprite is clicked.
				{
					particle.pos_x += e.stageX - prior_mouse_x
					particle.pos_y += e.stageY - prior_mouse_y;
				}
			}
			prior_mouse_x = e.stageX;
			prior_mouse_y = e.stageY;
			
			if (e.buttonDown && !e.ctrlKey && !e.shiftKey)
			{
				velocity_line.graphics.clear();
				velocity_line.graphics.lineStyle(1, 0x0000FF, 1);
				velocity_line.graphics.moveTo(down_position_x, down_position_y);
				velocity_line.graphics.lineTo(e.stageX, e.stageY);
			}
		}
		
		public static function path_toggle():void
		{
			if (!Gravity.app.paths.selected)
			{
				Gravity.path_data.dispose();
				Gravity.path_data = new BitmapData(3000, 3000, true, 0x00000000);
				Gravity.path_canvas = new Bitmap(Gravity.path_data);
				Gravity.view.addChildAt(Gravity.path_canvas, 0);
			}
		}
		
		public static function generate_proto():void
		{
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;
			
			for (var i:Number = 0; i < 1000; i++)
			{
				var rand:Number = Math.random()*2*Math.PI;
				var rand2:Number = Math.random();
				var x:Number = (100*rand2)*Math.cos(rand);
				var y:Number = (100*rand2)*Math.sin(rand);
				var mag:Number = Math.sqrt(x*x+y*y);
				var particle:Particle = new Particle(1000, y*(mag/70), -x*(mag/70), center_x+x, center_y+y);
				Gravity.view.addChild(particle);
				Gravity.particles.push(particle);
			}
		}
	}
}