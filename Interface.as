package
{
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.*;
	
	import mx.utils.*;
	import mx.controls.*;
	
	public class Interface
	{
		public static var virtual_mass:Number = 10;
		public static var virtual_radius:Number = 150;
		public static var virtual_mass_flag:Number = 0;
		public static var virtual_mass_x:Number = 0;
		public static var virtual_mass_y:Number = 0;
		
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
			virtual_mass_flag = 0;
			if(e.altKey)
				if(e.buttonDown)
					virtual_mass_flag = 1;

			if (e.buttonDown && e.ctrlKey)
			{
				Gravity.app.paths.selected = false;
				path_toggle()
			}
			
			if (e.buttonDown && e.shiftKey && (flash.utils.getQualifiedClassName(e.target) == "Particle"))
			{
				Particle.delete_particle(Particle(e.target));
			}
			
			if (e.buttonDown && !e.ctrlKey && !e.shiftKey && !e.altKey)
			{	
				down_position_x = e.stageX;
				down_position_y = e.stageY;
				
				down_position_circle.graphics.beginFill(0x0000FF, 1);
				down_position_circle.graphics.drawCircle(down_position_x, down_position_y, 2);
				
			} else if (!e.ctrlKey && !e.shiftKey && !e.altKey)
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
		
		public static function input_change_handler(e:Event):void
		{
			virtual_mass = Gravity.app.virtual_mass.text;
			if (String(virtual_mass) == "NaN" || virtual_mass <= 0)
			{
				virtual_mass = 1000*1000; 
				Gravity.app.virtual_mass.text = 1000000;
			}
			virtual_radius = Gravity.app.virtual_radius.text;
			if (String(virtual_radius) == "NaN" || virtual_radius <= 0)
			{
				virtual_radius = 150; 
				Gravity.app.virtual_radius.text = 150;
			}
		}
		
		public static function quicker():void
		{
			Gravity.h = Gravity.h * 1.2;
		}
		
		public static function slower():void
		{
			Gravity.h = Gravity.h / 1.2;
		}
		
		public static function mouse_move(e:MouseEvent):void
		{	
			if(!e.altKey)
				virtual_mass_flag = 0;
			virtual_mass_x = e.localX;
			virtual_mass_y = e.localY;
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
			
			if (e.buttonDown && !e.ctrlKey && !e.shiftKey && !e.altKey)
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
		
		public static function autoclear():void
		{
			if(Gravity.app.autoclear.selected) {
				Particle.clear();
			}
		}
		
		public static function generate_proto():void
		{
			autoclear();
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

		public static function generate_horseshoe1():void
		{
			autoclear();
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;
			
			var sun:Particle = new Particle(1000*1000*9, 0, -0.3, center_x-0.3, center_y);
			Gravity.view.addChild(sun);
			Gravity.particles.push(sun);
			
			var planet:Particle = new Particle(1000*9, 0, 100*3, center_x+100-0.3, center_y);
			Gravity.view.addChild(planet);
			Gravity.particles.push(planet);
			
			var asteroid:Particle = new Particle(Gravity.zero_mass, 0, -98.6*3, center_x-103, center_y);
			Gravity.view.addChild(asteroid);
			Gravity.particles.push(asteroid);
		}
		
		public static function generate_horseshoe150():void
		{
			autoclear();
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;

			var sun:Particle = new Particle(1000*1000*10*9, 0, -Math.sqrt(30)/10, center_x-0.3, center_y);
			Gravity.view.addChild(sun);
			Gravity.particles.push(sun);

			var planet:Particle = new Particle(1000*10*9, 0, 100*Math.sqrt(30), center_x+300-0.3, center_y);
			Gravity.view.addChild(planet);
			Gravity.particles.push(planet);

			var asteroidData = new Array(-1.3987810172187238, -541.9141344836414, -305.5756929169988, 0.8499152919981903, -24.1944108367935, -544.7727732664132, -303.4057846311714, 13.003162891096757, -44.12636219429153, -543.0737175942805, -303.1658250909024, 22.058396453316924, -57.220863831117555, -538.2572810935949, -304.56103144483365, 29.705136734150727, -73.54565409811116, -535.3523391173892, -303.80332450090384, 40.975014019458385, -97.00128957119162, -534.718603356937, -299.975879231604, 54.48357128288448, -121.23600294360531, -531.7708083872922, -296.63846270774695, 65.88816455601471, -136.2891786522728, -525.2682750101475, -296.46761746443804, 73.76594860671214, -151.05443276830533, -518.0758990631913, -295.54668986125773, 84.17677104341301, -174.07890873519554, -512.0843698597538, -290.43644658159593, 98.59982279797197, -203.13087924870734, -504.90813205899474, -283.17864803391745, 113.17770140839161, -223.1469687343133, -495.72052672213, -279.6301812953368, 122.92340746043695, -238.08495112172332, -484.52818400611886, -277.4779224739893, 133.09193689987677, -259.27775284145383, -471.9505279469979, -271.0607132021794, 147.71332522489058, -291.0682115236032, -456.5063780874682, -259.11156145548443, 165.08940653413612, -317.45086561693626, -440.77933547814234, -249.6555271253389, 177.69639422172963, -334.97896731675945, -424.2400972866135, -243.86659237953353, 188.41496124615605, -353.2737698499711, -404.53201441041756, -235.33405662978413, 202.39297077890137, -382.90045409565397, -377.5173606766524, -218.11261865176297, 220.7041250415137, -412.69644497286123, -349.3522258352636, -200.03238605036745, 235.3226268961721, -433.5973096325803, -322.88415463968363, -186.77785725705024, 246.41738523538362, -448.41250169683997, -295.2084731099274, -174.13759494807965, 258.4809759812061, -469.0933808422692, -256.1941280503907, -151.5362878001357, 274.2953044682725, -493.05269578518414, -211.52352270796638, -123.40372223581699, 287.1215581178481, -511.7780654958089, -168.56357971665886, -98.70814439743489, 295.455970886277, -521.0829119021172, -130.35208929091567, -79.00412870059309, 302.68483991851167, -526.5598144695781, -82.9511700934341, -51.968186156424764, 311.26569739992664, -531.6818311015679, -25.746676199964895, -16.21201977574745, 315.9186841692961, -533.8725175415834, 34.274477820900415, 19.967708942260316, 314.42931103824617, -529.7155615616418, 84.8664844700495, 47.98940755643493, 310.77510735291713, -516.567937046816, 134.2271237049652, 76.40902473853458, 306.9791158666675, -495.6912884838683, 189.25774101022932, 111.4965533055977, 298.2413438856684, -468.1296577510979, 250.95635131182786, 150.16234556839112, 280.51580912556307, -437.0036528573262, 307.9664624375625, 182.11538999873827, 258.3881222764058, -407.66940841569306, 347.4884767875644, 203.3297372693192, 241.07360604516472, -370.732435013447, 383.428817608013, 225.8796792991671, 221.67602288932645, -323.6089527763718, 421.96905714426913, 251.08465123444293, 193.37231040212126, -274.8267530966823, 458.8363371408805, 270.39480318276776, 159.84596540599992, -245.07181595976263, 481.5933193682031, 276.74845888457423, 138.40319782688766, -228.5085148868996, 493.8336085498212, 277.5803198532272, 127.27679309734827, -215.91391407510136, 501.05920736209646, 278.02507496229765, 118.74814267089879, -213.47835472741798, 506.1853835482652, 275.22942613998674, 113.06321686266571, -239.59430790161088, 503.42712163477256, 263.9637621852952, 122.07664816759117, -291.1663966795637, 483.08548260709006, 244.92439834536714, 147.41366043345494, -340.69616206221156, 446.81586662619156, 225.82084734702892, 175.59914829975668, -379.7078719880617, 408.7035922539662, 209.8499682355897, 196.5256667044355, -421.4978971202508, 371.5186728374757, 189.3201402891116, 213.16242325931938, -471.60763795802836, 315.20018961707814, 156.15624040748563, 235.06525806423474, -507.75831678105067, 245.8358915835667, 120.37235672150635, 256.96318584106353, -526.9068100377374, 184.47061745350643, 92.75580319226457, 271.4117543939823, -544.5934489241959, 133.96882884673926, 68.71316592012393, 277.26062318207244, -561.8003865470627, 67.83065372606146, 33.03825031330922, 281.3478457352824, -562.9218172447106, -6.157903908572791, -6.930815099490985, 284.91667919112564, -552.5534623987679, -65.87805049413882, -36.74392783336734, 286.2418504848515, -547.3080289085258, -109.04527491214225, -56.032437509591986, 282.52725285376994, -539.3669625614224, -162.10004002121946, -82.88565051020598, 273.39329356201006, -516.0030862525167, -220.57606886146837, -116.1843862639548, 262.443927774307, -486.46295457606107, -265.9688716779802, -142.11259311586036, 253.70416031497723, -469.62673958698593, -295.5968540264554, -154.87519340808885, 246.13110534634637, -452.51044368688696, -330.3010650426626, -170.17389955750616, 232.7282456133257, -420.6664718182566, -369.15950881679765, -192.98745434367987, 214.9389900505781, -383.0436088883252, -398.81419346609505, -213.37135864665274, 200.25368012867216, -361.79378831405364, -416.95379350278193, -221.7556890578392, 192.00608901543927, -344.9258819200602, -437.7372253311932, -228.2275602532127, 180.17495549114435, -312.42288902643156, -462.7529231102718, -242.31401449698498, 160.1613928123247, -276.4188880951714, -478.2831840588074, -256.1770914959425, 143.77744871200105, -253.1633876985834, -488.08813113784095, -262.5278398885369, 135.18083259941693, -238.75038990648568, -500.46170525996916, -264.13553321841863, 126.73282012777918, -212.76365644099687, -515.42155816744, -270.1967337389917, 109.35401703895644, -179.22109438695315, -522.8875377303231, -279.515063466845, 91.74616953580215, -154.43244155386344, -526.3924349773575, -284.9687439579173, 81.90918902449263, -140.9364609749535, -533.6385256113026, -284.8256807639711, 76.01986987395895, -121.38847357468813, -543.4179110811272, -285.5034635920217, 62.69810844594032, -91.96400938012579, -546.0508809480175, -290.5157864207764, 45.213557570469874, -65.9452933769031, -544.4244262244331, -295.0358656861928, 33.28893840745573, -50.97072574167902, -547.5009784029362, -294.8202317563399, 27.977331162543848, -35.183561727578564, -554.6662210811329, -292.4443556738329, 18.439605834574877, -10.014741605918545, -554.9496685091709, -293.437874938818, 2.164992519711703, 16.658836464076003, -549.0499959605539, -296.256629784555, -12.100278620572965, 34.840071501973775, -547.4760063834723, -296.25424482666773, -18.90157114776926, 50.56029188133702, -552.262532840329, -292.4568871973171, -26.14225705359198, 72.80690821711957, -551.5247155848369, -289.8468893137224, -40.586853099979905, 99.54039375762196, -542.0379588781392, -289.88142802537175, -56.79584911574578, 121.45886096872655, -534.6957112976006, -289.23909090381744, -66.55779008393343, 140.4658982539331, -535.3238572251395, -284.5956155421268, -73.59755954934415, 162.3440398522693, -533.1931969493638, -278.7546978794677, -86.2700725564068, 188.9531426240146, -520.2729396202635, -274.857119085259, -103.58051265413862, 213.92123443454443, -505.78571004329353, -271.88844275309856, -116.78349526146951, 238.02300571702781, -498.8967206634012, -265.6587269449907, -125.52370027543967, 262.40034284407284, -492.7114942085956, -256.4700991884929, -137.04639485835418, 289.2135124274873, -475.18888872518187, -247.4410764900295, -154.38296761216796, 317.20651472685324, -450.362127029122, -239.39403898045373, -171.19221041218552, 343.660208588009, -433.08125338603384, -230.08479385826814, -181.45088955564046, 371.8254082824577, -417.5980131243989, -216.45164081758458, -192.27202980674014, 398.725214118666, -392.05395644523185, -200.8578150809751, -208.17619293858897, 424.31161819468775, -355.34360758731657, -185.4791228893596, -225.53259013374156, 450.1811598406553, -322.70367609183864, -170.24912913355624, -236.6170230854636, 478.90448328718213, -291.01595478426276, -150.1901956683303, -245.56692009215777, 502.5529798120559, -251.86273209197802, -126.46240058844157, -257.29745998928325, 518.829777016229, -201.3777665796507, -101.96061427715955, -270.716994386478, 534.6040046037907, -151.7355098653952, -79.13575574882864, -278.38099798446416, 553.22632991796, -99.28062782829485, -51.51929042731126, -281.1897025374548, 563.3443417580347, -42.63732935122313, -19.570801562890033, -283.4736717831551, 559.2240418613871, 19.153764812861, 12.942280113453585, -286.3470942792948, 552.0673085831404, 79.41181017374014, 41.19656233682876, -284.36049357350873, 544.3866333387001, 146.25521084467408, 72.77692219168533, -274.6462252106105, 525.6119279096143, 212.7259714106386, 107.64809116151335, -261.0165410959628, 491.37329434289745, 271.60075347114986, 141.02092340462468, -247.82336691176874, 455.79465681618893, 322.84913474145947, 166.44266177672833, -233.3905174617903, 416.1386589892945, 380.01673373373103, 191.37409767441838, -210.27398778929847, 367.6303360578655, 430.9672668960222, 217.10431631232436, -181.9974337031768, 316.22679488784854, 461.93898316616617, 239.9889554028438, -158.39223990128028, 277.501938968226, 479.6860537470258, 253.9118319845471, -143.44734192452972, 243.04084992443254, 499.6437901216743, 263.66667762598996, -126.54720000844591, 214.84428273844293, 513.2640805491253, 273.2242606515041, -109.5103694248227, 209.33953790075367, 505.5816593396593, 282.7614977902698, -107.78525463097913, 231.88883429575537, 481.8811900805004, 284.43567957610384, -128.79496439969768, 268.1793459445536, 457.50994842666375, 273.82880920092805, -158.59550726631787, 308.82422850456055, 437.7954981442586, 255.98502767123372, -182.25227462572724, 352.4014400627559, 409.91044423166767, 237.98321764282937, -202.00096037192768, 389.67248221967617, 366.74010228559223, 220.51491879841672, -226.07181010941616, 423.33360295554155, 313.9621242556546, 194.15124669350487, -255.39910182524795, 459.41137717013476, 259.63618630365744, 156.26525931939187, -279.7390786211969, 492.7026055789495, 210.86293806128222, 121.86062776741947, -290.92707077823235, 515.9683052054037, 158.2915603733646, 93.68154367914617, -298.7007493045901, 523.8466764970227, 101.58614733479963, 65.19584990436647, -309.6539274971525, 525.4879771797866, 40.68154819446504, 26.56055010845023, -318.94573493491083, 530.4994727137497, -15.73662632897478, -12.094387577575887, -317.3056722348025, 534.8366423455033, -71.06032153536793, -43.042123413606475, -309.04815442346563, 527.7225857869946, -119.6354799245147, -65.85235163658481, -303.74966588896154, 507.3181738596587, -163.98373450388596, -92.5141079670112, -301.21825173999673, 487.419463206032, -206.6321167119333, -123.37303057743728, -291.9720869437999, 471.6252600438832, -254.11967449086836, -151.170325191915, -273.97655255348985, 455.590880082406, -296.7625083928124, -168.58541993777948, -257.7554380193668, 432.0115283453675, -326.02239019202636, -182.68033076959333, -249.36855343693114, 404.4702890088331, -347.4658764689526, -201.4427239898489, -240.15858982662525, 376.53844047914447, -377.0283089171473, -222.6001481652745, -220.57572180847535, 351.38985251024326, -411.8364296627794, -236.24590388781453, -197.92590055694734, 328.5250857446176, -436.61821709306884, -242.66844466393724, -184.93335735565338, 306.0877501353109, -444.7866647572258, -251.31624148206407, -179.0564302006983, 278.08955872678933, -455.2813068494934, -265.2698427803191, -164.34610988637212, 247.3879739122648, -477.0958186784928, -275.97633810128923, -140.29013031212787, 220.56786146037743, -500.2898982582468, -278.6895160256759, -121.74895266771456, 203.6812356372495, -506.6777833064994, -280.9061686777114, -117.19813631554939, 183.57633540990741, -505.19900040648565, -288.9332718266718, -109.79181655560203, 154.24587268908178, -512.2753781112744, -297.2729876902782, -89.27918443321785, 121.73836824108643, -529.549722094521, -298.32948681001176, -65.88220458442089, 103.37789628672115, -539.1397916211771, -296.639532570135, -58.32308337763949, 91.16818136087755, -535.3843261335728, -300.3049768587558, -56.40491158433329, 69.12438513076867, -531.0695314392086, -306.8078220280331, -42.68454049419731);
			for (var i:Number = 0; (i*4+3) < asteroidData.length; i++) {
				var asteroid:Particle = new Particle(Gravity.zero_mass, Gravity.particles[0].vel_x+asteroidData[i*4+0], Gravity.particles[0].vel_y+asteroidData[i*4+1], Gravity.particles[0].pos_x+asteroidData[i*4+2], Gravity.particles[0].pos_y+asteroidData[i*4+3]);
				Gravity.view.addChild(asteroid);
				Gravity.particles.push(asteroid);
			}
		}

		public static var saturn_m:Number = 1000*1000*10*9;
		
		public static function generate_moon(r:Number, planet_weight:Number, weight_ratio:Number, speed_ratio:Number):void
		{
			var center_x:Number = Gravity.particles[0].pos_x;
			var center_y:Number = Gravity.particles[0].pos_y;
			
			var x:Number = r-r*weight_ratio;
			var y:Number = 0;
			// f = 9*10^7 / r^2
			//    = v^2 / r
			var v:Number = Math.sqrt(planet_weight/r);
			v = v/speed_ratio;
			var xv:Number =  0
			var yv:Number = -v;
			
			var moon:Particle = new Particle(planet_weight * weight_ratio, xv, yv, center_x+x, center_y+y);
			Gravity.view.addChild(moon);
			Gravity.particles.push(moon);
			
			Gravity.particles[0].pos_x = Gravity.particles[0].pos_x - r*weight_ratio;
			Gravity.particles[0].vel_y = Gravity.particles[0].vel_y + v*weight_ratio;
		}
		
		public static function generate_low_moon():void
		{
			generate_moon(25, saturn_m, 0.01, 1);
		}
		
		public static function generate_high_moon():void
		{
			generate_moon(180, saturn_m, 0.0001, 1);
		}
		
		public static function generate_eater_moon():void
		{
			generate_moon(150, saturn_m, 0.001, 2);
		}
		
		public static function generate_big_eater_moon():void
		{
			generate_moon(120, saturn_m, 0.01, 1.01);
		}
		
		public static function generate_Saturn():void
		{		
			autoclear();
			
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;

			var saturn:Particle = new Particle(saturn_m, 0, 0, center_x, center_y);
			Gravity.view.addChild(saturn);
			Gravity.particles.push(saturn);

			for (var i:Number = 0; i < 3000 ; i++) {
				var alpha:Number = Math.random()*2*Math.PI;
				var r:Number = Math.sqrt(50*50 + Math.random()*150*150);
				var x:Number = r*Math.cos(alpha);
				var y:Number = r*Math.sin(alpha);
				var xr:Number = 0;//Math.random()*6-3;
				var yr:Number = 0;//Math.random()*6-3;
				// f = 9*10^7 / r^2
				//    = v^2 / r
				var v:Number = Math.sqrt(saturn_m/r);
				var xv:Number =  v*Math.sin(alpha);
				var yv:Number = -v*Math.cos(alpha);
				
				var ring_particle:Particle = new Particle(Gravity.zero_mass, xv, yv, center_x+x+xr, center_y+y+yr);
				Gravity.view.addChild(ring_particle);
				Gravity.particles.push(ring_particle);
			}
		}
		
		public static function generate_hillsphere():void
		{
			autoclear();
			
			var distance:Number = Gravity.app.distance.text;
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;
			
			var saturn:Particle = new Particle(saturn_m/10, 0, 0, center_x, center_y);
			Gravity.view.addChild(saturn);
			Gravity.particles.push(saturn);
			
			var r1:Number = distance;
			generate_moon(r1, saturn_m/10, 0.1, 1);
			
			var v1:Number = Math.sqrt(saturn_m/10/r1);

			for (var i:Number = 0; i < 1000 ; i++) {
				var alpha:Number = Math.random()*2*Math.PI;
				var r:Number = Math.sqrt(20*20 + Math.random()*80*80);
				var x:Number = r*Math.cos(alpha);
				var y:Number = r*Math.sin(alpha);

				var v:Number = Math.sqrt(saturn_m/100/r);
				var xv:Number =  v*Math.sin(alpha);
				var yv:Number = -v*Math.cos(alpha);
				
				var ring_particle:Particle = new Particle(Gravity.zero_mass, xv, yv-v1, center_x+x+r1*0.9, center_y+y);
				Gravity.view.addChild(ring_particle);
				Gravity.particles.push(ring_particle);
			}
		
		}
		
		public static function generate_galaxy_particle(center_mass:Number, particle_mass:Number, 
				Rapogee:Number, Rperigee:Number, alpha:Number):void
		{
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;
			if(Rapogee<Rperigee) {
				var swap:Number = Rapogee;
				Rapogee = Rperigee;
				Rperigee = swap;
			}
			//var v:Number = Math.sqrt(planet_weight/r);
			var va:Number = Math.sqrt(2*center_mass*Rperigee/(Rapogee*(Rapogee+Rperigee)));
			//var vp:Number = Math.sqrt(2*center_mass*Rapogee/(Rperigee*(Rapogee+Rperigee)));
			var e:Number = (Rapogee - Rperigee) / (Rapogee + Rperigee);
			
			var p:Number = Rapogee*(1-e);
			for (var i:Number = 0; i < 100 ; i++) {
			var theta:Number = Math.random()*Math.PI*2;
			//theta = Math.PI*i;
			var pi:Number = p/(1-e*Math.cos(theta));
			
				var x:Number = pi*Math.cos(theta);
				var y:Number = pi*Math.sin(theta);
				var theta1:Number = theta + 0.0001;
				var pi1:Number = p/(1-e*Math.cos(theta1));
				var x1:Number = pi1*Math.cos(theta1);
				var y1:Number = pi1*Math.sin(theta1);
				x1 = x1 - x;
				y1 = y1 - y;
				var length:Number = Math.sqrt(x1*x1 + y1*y1);
				x1 = x1/length;
				y1 = y1/length;
				var length2:Number = Math.sqrt(x*x + y*y);
				var x2:Number = y/length2;
				var y2:Number = -x/length2;			
				var factor:Number = Rapogee/pi/(x1*x2+y1*y2);
				var xv:Number = va*factor*x1;
				var yv:Number = va*factor*y1;
			var factorRandom:Number = Math.random()*factor;
			if(factorRandom<0)
				factorRandom *= -1;
			if((factorRandom)<0.01){
			var cosa:Number = Math.cos(alpha);
			var sina:Number = Math.sin(alpha);
			var vxa:Number = (xv*cosa) - (yv*sina);
			var vya:Number = (xv*sina) + (yv*cosa);
			var xa:Number = (x*cosa) - (y*sina);
			var ya:Number = (x*sina) + (y*cosa);
			var ring_particle:Particle = new Particle(particle_mass, vxa, vya, center_x+xa, center_y+ya);
			Gravity.view.addChild(ring_particle);
			Gravity.particles.push(ring_particle);
			}
			}

		}
		
		public static function generate_galaxy():void
		{
		autoclear();
		
		var randomN:Number = Gravity.app.random_count.text; // 100
		var curvatureN:Number = Gravity.app.curvature_count.text; // 100
		var spiralN:Number = Gravity.app.spiral_count.text; // 2
		
		var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
		var center_y:Number = Gravity.app.parent.parent.stageHeight/2;
			
		var saturn:Particle = new Particle(saturn_m, 0, 0, center_x, center_y);
		Gravity.view.addChild(saturn);
		Gravity.particles.push(saturn);
			
		//generate_moon(210, saturn_m, 0.00001, 1);
		//generate_moon(90, saturn_m, 0.00001, 1);
		var Rrange:Number = 270;
		var Rmin:Number = 80;
		for (var i9:Number = Rmin+Rrange; i9 > Rmin ; i9-=1 ){ 
			var Rratio:Number = (i9-Rmin) / Rrange * 2 * curvatureN / 100;
			for (var i8:Number = 0; i8 < 15 ; i8++){
				var e:Number = 2;
				var Erandom:Number = (Math.random()-0.5)/500*randomN;
				var Arandom:Number = (Math.random()-0.5)*Math.PI/1000*randomN;
				for (var i10:Number = 0; i10 < spiralN ; i10+=1 )
					generate_galaxy_particle(saturn_m, 1, i9, i9/(e+Erandom), Math.PI/2*Rratio+Arandom + Math.PI*2/spiralN*i10);
				//generate_galaxy_particle(saturn_m, 1, i9, i9/(e+Erandom), Math.PI+Math.PI/2*Rratio+Arandom);
				
				//generate_galaxy_particle(saturn_m, 1, i9, i9/2, Math.PI/2+Math.PI/2*Rratio);
				//generate_galaxy_particle(saturn_m, 1, i9, i9/2, Math.PI/2+Math.PI+Math.PI/2*Rratio);
			}
		}
		for (var i8:Number = 0; i8 < 3000 ; i8++){
			generate_galaxy_particle(saturn_m, 1, (Rmin-20)*Math.random()+25, (Rmin-20)*Math.random()+25, Math.PI*2*Math.random());
		}
		for (var i8:Number = 0; i8 < 1000 ; i8++){
			generate_galaxy_particle(saturn_m, 1, (Rrange)*Math.random()+Rmin, (Rrange)*Math.random()+Rmin, Math.PI*2*Math.random());
		}
		}
		
		public static function generate_orbital_particle(center_mass:Number, particle_mass:Number, 
				Rapogee:Number, Rperigee:Number, alpha:Number):void
		{
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;
			if(Rapogee<Rperigee) {
				var swap:Number = Rapogee;
				Rapogee = Rperigee;
				Rperigee = swap;
			}
			//var v:Number = Math.sqrt(planet_weight/r);
			var va:Number = Math.sqrt(2*center_mass*Rperigee/(Rapogee*(Rapogee+Rperigee)));
			//var vp:Number = Math.sqrt(2*center_mass*Rapogee/(Rperigee*(Rapogee+Rperigee)));
			var e:Number = (Rapogee - Rperigee) / (Rapogee + Rperigee);
			
			var p:Number = Rapogee*(1-e);
			var theta:Number = 0;
			//theta = Math.PI*i;
			var pi:Number = p/(1-e*Math.cos(theta));
			
				var x:Number = pi*Math.cos(theta);
				var y:Number = pi*Math.sin(theta);
				var theta1:Number = theta + 0.0001;
				var pi1:Number = p/(1-e*Math.cos(theta1));
				var x1:Number = pi1*Math.cos(theta1);
				var y1:Number = pi1*Math.sin(theta1);
				x1 = x1 - x;
				y1 = y1 - y;
				var length:Number = Math.sqrt(x1*x1 + y1*y1);
				x1 = x1/length;
				y1 = y1/length;
				var length2:Number = Math.sqrt(x*x + y*y);
				var x2:Number = y/length2;
				var y2:Number = -x/length2;			
				var factor:Number = Rapogee/pi/(x1*x2+y1*y2);
				var xv:Number = va*factor*x1;
				var yv:Number = va*factor*y1;
			var cosa:Number = Math.cos(alpha);
			var sina:Number = Math.sin(alpha);
			var vxa:Number = (xv*cosa) - (yv*sina);
			var vya:Number = (xv*sina) + (yv*cosa);
			var xa:Number = (x*cosa) - (y*sina);
			var ya:Number = (x*sina) + (y*cosa);
			var ring_particle:Particle = new Particle(particle_mass, vxa, vya, center_x+xa, center_y+ya);
			Gravity.view.addChild(ring_particle);
			Gravity.particles.push(ring_particle);
			

		}

		public static function generate_rosette():void
		{
			autoclear();
			
			var body_count:Number = Gravity.app.body_count.text;
			if (String(body_count) == "NaN" || body_count <= 0)
			{
				body_count = 3; 
				Gravity.app.body_count.text = 3;
			}
				
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;
				
			var saturn:Particle = new Particle(saturn_m, 0, 0, center_x, center_y);
			Gravity.view.addChild(saturn);
			Gravity.particles.push(saturn);
			
			var centerbody_to_sattelites_mass_ratio:Number = 30;
			
			for (var i8:Number = 0; i8 < body_count ; i8++){
				generate_orbital_particle(saturn_m*(centerbody_to_sattelites_mass_ratio+1)/centerbody_to_sattelites_mass_ratio, saturn_m/(centerbody_to_sattelites_mass_ratio*body_count), (1)*Math.random()+150, (1)*Math.random()+150, (Math.PI*2)/body_count*i8);// (2)*Math.random()+
			}
		}
		
		public static function planet(center:Particle, Rperigee:Number, Rapogee:Number, particle_mass:Number):void
		{
			var alpha:Number = Math.PI*2*Math.random();
			var center_x:Number = center.pos_x;
			var center_y:Number = center.pos_y;
			var center_mass:Number = center.mass;
			
			if(Rapogee<Rperigee) {
				var swap:Number = Rapogee;
				Rapogee = Rperigee;
				Rperigee = swap;
			}
			var va:Number = Math.sqrt(2*center_mass*Rperigee/(Rapogee*(Rapogee+Rperigee)));
			var e:Number = (Rapogee - Rperigee) / (Rapogee + Rperigee);
			
			var p:Number = Rapogee*(1-e);
			var theta:Number = 0;
			//theta = Math.PI*i;
			var pi:Number = p/(1-e*Math.cos(theta));
			
				var x:Number = pi*Math.cos(theta);
				var y:Number = pi*Math.sin(theta);
				var theta1:Number = theta + 0.0001;
				var pi1:Number = p/(1-e*Math.cos(theta1));
				var x1:Number = pi1*Math.cos(theta1);
				var y1:Number = pi1*Math.sin(theta1);
				x1 = x1 - x;
				y1 = y1 - y;
				var length:Number = Math.sqrt(x1*x1 + y1*y1);
				x1 = x1/length;
				y1 = y1/length;
				var length2:Number = Math.sqrt(x*x + y*y);
				var x2:Number = y/length2;
				var y2:Number = -x/length2;			
				var factor:Number = Rapogee/pi/(x1*x2+y1*y2);
				var xv:Number = va*factor*x1;
				var yv:Number = va*factor*y1;
			var cosa:Number = Math.cos(alpha);
			var sina:Number = Math.sin(alpha);
			var vxa:Number = (xv*cosa) - (yv*sina);
			var vya:Number = (xv*sina) + (yv*cosa);
			var xa:Number = (x*cosa) - (y*sina);
			var ya:Number = (x*sina) + (y*cosa);
			var ring_particle:Particle = new Particle(particle_mass, vxa, vya, center_x+xa, center_y+ya);
			Gravity.view.addChild(ring_particle);
			Gravity.particles.push(ring_particle);
			
			center.vel_x = center.vel_x - vxa*(particle_mass/center.mass)
			center.vel_y = center.vel_y - vya*(particle_mass/center.mass)
		}
		
		public static function generate_solar():void
		{
			autoclear();
			
			var center_x:Number = Gravity.app.parent.parent.stageWidth/2;
			var center_y:Number = Gravity.app.parent.parent.stageHeight/2;
			
			var sun:Particle = new Particle(saturn_m, 0, 0, center_x, center_y);//sun
			Gravity.view.addChild(sun);
			Gravity.particles.push(sun);
			
			var au:Number = 50;
			var earth_mass:Number = sun.mass/332736;
			
			planet(sun, au*0.466, au*0.307, 0.055*earth_mass);//mercury
			planet(sun, au*0.728213, au*0.718440, 0.815*earth_mass);//venus
			planet(sun, au*1.01671388, au*0.98329134, 1*earth_mass);//earth
			planet(sun, au*1.665861, au*1.381497, 0.107*earth_mass);//mars
			
			//for (var i9:Number = 0; i9 < 100 ; i9+=1 ){
			//	planet(sun, (au*2)*Math.random()+au*2, (au*2)*Math.random()+au*2, 1);
			//}
			
			planet(sun, au*4.950429, au*5.458104, 317.8*earth_mass);//jupiter
			var jupiter:Particle = Gravity.particles[Gravity.particles.length-1]
			//planet(jupiter, 7, 8, 1);
			//planet(jupiter, 11, 13, 1);
			//planet(jupiter, 15, 17, 1);
			//planet(jupiter, 3, 4, 1);
		}		
	}
}