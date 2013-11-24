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
		
		public static function generate_horseshoe():void
		{
			Particle.clear();
			
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;
			
			var sun:Particle = new Particle(1000*1000*10*9, 0, -Math.sqrt(30)/10, center_x-0.3, center_y);
			Gravity.view.addChild(sun);
			Gravity.particles.push(sun);
			
			var planet:Particle = new Particle(1000*10*9, 0, 100*Math.sqrt(30), center_x+300-0.3, center_y);
			Gravity.view.addChild(planet);
			Gravity.particles.push(planet);
			
			//var asteroid1:Particle = new Particle(0.001, 0, -99*Math.sqrt(30), center_x-306, center_y);//98.6 103
			//Gravity.view.addChild(asteroid1);
			//Gravity.particles.push(asteroid1);
			
			var asteroidData = new Array(-1.3987810172187238, -541.9141344836414, -305.5756929169988, 0.8499152919981903, -34.538657858126754, -544.7301254774608, -302.89350577414916, 17.71453556422216, -57.220863831117555, -538.2572810935949, -304.56103144483365, 29.705136734150727, -84.64568903021298, -534.9874434185616, -302.11244175671715, 47.77499824479986, -119.88366527971544, -532.1131222501326, -296.74752147141885, 65.27392986017094, -142.98197874996305, -521.5460562664416, -296.41796326056374, 78.38905854547484, -174.07890873519554, -512.0843698597538, -290.43644658159593, 98.59982279797197, -214.30831136930158, -500.6225056441963, -280.9271793893985, 118.37904327206525, -238.08495112172332, -484.52818400611886, -277.4779224739893, 133.09193689987677, -273.5497940037577, -465.01595415228013, -265.7767996558497, 156.04600082135414, -317.45086561693626, -440.77933547814234, -249.6555271253389, 177.69639422172963, -343.2241879705049, -414.97808876203766, -240.42269970716075, 194.8153548806294, -380.68268045697073, -379.4863600961322, -219.44736877414235, 219.50404207494825, -424.4632673829906, -335.86027847850073, -192.78540670137818, 241.07299330026245, -448.41250169683997, -295.2084731099274, -174.13759494807965, 258.4809759812061, -479.3312219904195, -237.5447889868915, -139.727999519557, 280.34046857809204, -511.7780654958089, -168.56357971665886, -98.70814439743489, 295.455970886277, -523.7294615476465, -109.92410373041969, -67.88810530801457, 306.73764783007766, -531.3581941153642, -30.116120577859675, -18.945373615400285, 315.79978921613224, -532.705145862849, 60.91980234040193, 34.927183482927866, 312.5498661731444, -517.7420011770507, 130.73807890320683, 74.27502380834076, 307.3203802213013, -482.48086907450175, 220.14449344758506, 131.2288380031544, 290.34723212961035, -439.0364085411254, 304.69204171157145, 180.38467342199348, 259.7566671154004, -393.21090458874585, 362.67004437922833, 212.41481690247724, 233.58029341630535, -323.6089527763718, 421.96905714426913, 251.08465123444293, 193.37231040212126, -259.9028936809922, 470.10792951883093, 274.28964542952326, 149.07340365133427, -229.49562272284288, 493.1935356107076, 277.5559200909443, 127.90487570252823, -212.08286355471728, 503.9159393467295, 277.5871530057134, 114.98930838635462, -236.6600685353849, 504.0937340892833, 265.08235151139945, 120.81134504298372, -314.1823657362175, 468.535666943241, 236.2203628539575, 160.1249201225244, -377.16958048642965, 411.09384352074653, 210.93946994473205, 195.37947408682268, -443.05925098371085, 350.2554648605359, 176.44367023754316, 221.924506905228, -505.9388034731568, 250.6146959741964, 122.66406905820752, 255.61209197236732, -533.8323924293369, 163.5704426946392, 83.32930425726333, 274.4697976572195, -560.9725477374984, 73.13798740709922, 35.939685589997254, 281.05771858133033, -558.173617797402, -37.2188254317207, -22.973942162757062, 286.0117066930494, -547.5672717636899, -105.81122887341681, -54.54337313865017, 282.9918093002532, -531.221093017198, -187.9006989534821, -97.22742020735411, 268.6116714931151, -488.09798606352706, -263.5967646077602, -140.8884997736829, 254.1832795488273, -463.5433920499893, -309.26237118334933, -160.36795236128518, 241.27187391426105, -423.33454947733895, -366.6083753432435, -191.3092831655509, 216.17777934439476, -372.20294383356327, -406.95476209447037, -218.0038471424215, 196.50171578387278, -346.4451393475486, -436.0582576847609, -227.5745525967061, 181.28844935645085, -298.99665919738953, -469.43457460419006, -247.77558351566205, 153.48501480870155, -254.33558953261698, -487.37095355814034, -262.33179858297234, 135.6484940019337, -230.43500613461958, -506.77445541497804, -265.7033409855805, 120.77579660954359, -183.83790829187734, -522.2668035202192, -278.26500429178446, 93.88969160192474, -147.97259554582223, -528.8565824752002, -285.3402850702144, 79.56798866085352, -124.87034550534054, -542.375782583588, -285.1026489969213, 65.02454214445004, -79.50951117657044, -545.2861724157681, -292.88288334753565, 39.006188766436104, -51.82725261451378, -547.0654575634569, -294.9747828079565, 28.334869639050737, -27.268762563148897, -555.8566802008763, -292.34840777621866, 13.12061325768272, 14.993958545712005, -549.4443624665352, -296.102369051828, -11.34155511181007, 40.775610045339846, -549.1342499315643, -294.9841406273182, -21.06592509703937, 69.11041352238851, -552.2881436376754, -290.02809895999656, -38.16216793633248, 109.77532669225066, -537.9317791525392, -289.94272917666666, -61.889607012132174, 137.8520303343234, -535.0455552876281, -285.41715469697874, -72.42987211991263, 171.64209112650872, -529.6503128496221, -277.0832195410922, -92.38451245776001, 212.2550681473038, -506.58849980497234, -272.15156821916287, -116.06966763063076, 246.32798504945248, -497.48846682285324, -262.6053808925754, -128.85430665996643, 285.37639655986817, -478.3627698121897, -248.61380408339846, -151.7911729114902, 326.46866982797883, -443.3460309478463, -236.4945571464462, -175.29501549322435, 367.7721386476898, -420.2177708070957, -218.61982994918168, -190.4202532405805, 409.14855027937256, -377.80365140243805, -194.52072414553754, -215.57863546191152, 446.214331502733, -327.1379883488063, -172.66233548003584, -235.30645220829635, 488.39778670143494, -278.1842963179406, -141.8887570466814, -249.35623613166345, 516.8728602386537, -208.3543834636488, -105.11564854215189, -269.13744189459203, 541.3389915750802, -133.48923452697636, -69.98176353748839, -279.73916912159166, 562.8338981203616, -50.87305390631141, -24.17502982046021, -283.0649947513055, 556.4907792443227, 40.06424783589503, 22.997417416193585, -286.461115706938, 545.8940625145297, 136.4143259664733, 67.95552976124172, -276.4274008949256, 515.2949341178494, 233.83952369647463, 119.58242590703954, -256.3921952359324, 460.9651317658186, 315.1807176984576, 162.9662228121481, -235.89824135276828, 399.69946277993387, 400.0742292546055, 200.65768223541238, -200.1983423698137, 325.70607235294653, 457.46836901238134, 236.07139508977176, -162.22756971762976, 264.96083304141905, 486.5642114739286, 257.61786427691266, -137.91965423275985, 217.92851968889713, 512.3609281952861, 271.8190959048589, -111.43355753915384, 214.88081807776172, 498.15141875300907, 284.6069996944007, -113.12212687842336, 262.59988084278507, 460.6361304843471, 276.0086679599959, -154.50138472409748, 323.56088159342755, 430.1568388587435, 249.6395405820241, -188.88077269899432, 384.61440017141456, 373.8268597375156, 223.3967386801603, -222.115439800466, 435.1541563099539, 295.30716882244644, 182.192317768489, -264.93284977069436, 486.0115305661899, 221.4783992216852, 128.69610091149198, -289.1856337793475, 520.3347391566424, 138.31256528390475, 84.07946189068537, -302.2705719205011, 525.0092914975629, 52.77030575789587, 34.88956451912094, -317.84954445249, 532.3030242086829, -31.850176412230564, -22.020399233120333, -315.1794144555178, 529.6323728411587, -113.24995270664047, -62.73609674327837, -304.1620571371173, 501.2717451227108, -175.66738631797304, -100.96801943332154, -299.63099351528047, 474.80628270821205, -243.84305717449337, -146.01618372285216, -278.13830152969183, 448.63203707444876, -308.35922857989476, -173.11002940135847, -254.15576614683107, 410.5647661077477, -342.4762140183301, -196.8996503465606, -242.91212436204972, 367.12531464642115, -389.61242886176814, -228.67205173603412, -212.01897295704592, 332.92905559408075, -433.3335258413507, -241.51301922844848, -186.46403114390105, 298.660057266498, -446.786210014437, -255.01020961290544, -176.18945795075675, 251.66085385172178, -473.53243155539246, -274.9736434813175, -143.75689048726176, 215.28073582230775, -503.8054254292981, -278.88789886141757, -119.6162672424388, 188.67806518087554, -505.21993781975084, -286.85102968626256, -112.45061657655353, 142.69972370391514, -517.6005742468179, -298.5950430609131, -80.47003973768456, 106.23442903479325, -538.3196127414047, -296.6999872744158, -58.818094652760124, 86.29301522753934, -533.4593465144154, -302.2553960364402, -54.11083417228469, 41.54331017754507, -535.5703716706905, -307.97049592188324, -22.336015725752702, 4.463054848039491, -548.9656019859596, -302.10663876448376, -2.6496299058405413, -11.537861822880544, -540.7103290846965, -306.7105974740178, 1.2541222433313237, -56.51417018607401, -533.9848852868877, -307.0498971005152, 33.84582830365699, -95.89615649985558, -540.2635433045165, -297.75262664946007, 52.71222452950243, -112.16825363270694, -528.2996962134815, -301.73166918562845, 58.58722130322613, -157.5871480327132, -512.5038415976182, -295.6888824071176, 92.07356815649928, -201.05519377343865, -509.5863492727158, -282.1513138409782, 111.29618025392382, -218.93899191520416, -493.17840380117974, -283.89024950524976, 119.9749745803378, -265.8366280635797, -463.98086171424745, -269.6469359967781, 155.36696729366662, -313.8103329778396, -447.04894673932233, -249.50227002365062, 175.39786833341097, -334.30343636083046, -422.59739989106373, -246.272622139384, 187.52974019024407, -378.71400365577364, -374.4829179758588, -220.27103781676152, 223.07347438699495, -427.40630127405586, -336.0706460980927, -189.58314277726328, 242.1220490458412, -447.8291589917489, -298.14449966169343, -177.32438414125176, 255.8466180833312, -479.03200230635605, -226.59757399143876, -135.86094542443135, 285.8179662124232, -516.0934668100258, -159.81480065520466, -90.76601213715836, 297.3572385175543, -527.1918278328706, -104.05103594532463, -66.1436278480292, 306.0764944082058, -527.1603316193128, -13.276377189414655, -9.752162699720833, 319.40767920688614, -530.5003971829342, 81.36624537329774, 49.531253286622544, 310.5021427238054, -517.0024571732483, 146.7862768510071, 81.29272263104485, 303.68062713240425, -471.28692929826616, 234.0514742927456, 140.36549728281514, 289.0394832764126, -422.57496339281494, 325.36605791545895, 195.7128865900774, 249.39235884604616, -380.96205937017976, 382.0051454185748, 219.77950626818222, 222.91033605085357, -307.4443746048223, 431.01027923921475, 257.34556708725773, 187.21211797490332, -238.79184009751845, 479.09786985073947, 282.1654828865693, 134.93356037668767, -220.86171547231652, 504.70861534164607, 276.20087140190867, 118.52068801577423, -217.60945433243472, 503.20009916551135, 273.57059396670826, 119.4923659660803, -251.0125247346917, 495.5998687737281, 261.80433668146657, 127.58936742232271, -337.29343837187974, 458.07817239762096, 226.56524170824434, 168.77952401135965, -394.06473997886786, 392.2365290418015, 201.0344588492839, 206.62436030198597, -460.8856691753401, 325.87931220410826, 165.87873321518688, 229.99047483321573, -523.0354086717184, 220.8655981480548, 105.29200261278827, 261.5158789896476, -537.8720656584046, 134.4676609444255, 69.05749607653414, 280.49476545915087, -566.0007793851499, 42.814380623247956, 22.24875870319913, 281.5598583706171, -556.9546270747236, -65.79428375009229, -39.39873281852489, 283.55596514111915, -538.9330413108169, -128.52603094578836, -66.28520112486116, 282.49804287135976, -524.095359195427, -215.96070936528616, -109.38925585516485, 262.120129977468, -474.92591885428743, -285.0315021992413, -154.3380978943439, 246.852895120832, -450.72591286345636, -323.6943614652605, -167.94239544253074, 237.63146785854585, -407.87630410735244, -389.1658991863738, -200.31997321637024, 205.25804134280673, -354.34126862358465, -419.33951776871265, -227.705313107777, 187.32907050575253, -333.0499159828179, -445.5407317924895, -231.90162902045176, 176.34726900176773, -278.03060363240843, -485.9763642257801, -253.75482097335427, 139.87519702354166, -235.5958143297692, -492.85553601801564, -269.0758255835523, 126.1551414197597, -215.9707816314368, -514.0956387962613, -267.8660252357872, 114.63529510071294, -158.60604104224174, -533.0706464921676, -281.67917793724797, 78.2238867765643, -128.57799988258427, -530.1105123048981, -289.80744034510735, 70.04690608451888, -107.12088085696772, -548.4608848058681, -285.54612589459805, 56.878961852416666, -51.97908179836014, -550.5103786626072, -293.53357062505853, 22.102296901826122);
			for (var i:Number = 0; (i*4+3) < asteroidData.length; i++) {
			//msg + ", " + particle_history[j].pos_x  + ", " + particle_history[j].pos_y  + ", " + particle_history[j].vel_x  + ", " + particle_history[j].vel_y;
				var asteroid:Particle = new Particle(0.001, Gravity.particles[0].vel_x+asteroidData[i*4+0], Gravity.particles[0].vel_y+asteroidData[i*4+1], Gravity.particles[0].pos_x+asteroidData[i*4+2], Gravity.particles[0].pos_y+asteroidData[i*4+3]);
				Gravity.view.addChild(asteroid);
				Gravity.particles.push(asteroid);
			}
		}		
		
	}
}