// rack pdf designs
include <util.scad>

baseplate_w = 257;
baseplate_h = 287;
baseplate_thick = 10;
baseplate_center = baseplate_w/2;

compensator_w = 219;
compensator_pos = [-compensator_w/2,baseplate_h-125.5, 29];
bearingblock_pos = [-baseplate_w/2+3,baseplate_h-107, 0];

bearingblock_w = 97;
bearingblock_c = bearingblock_w/2;
bearingblock_t = 5.0; // was 2.5 in the original design


// ??? page ?
// this has been heavily modified for printability, including making things thicker
// and adding an larger spring hole plus the axle for the spring to wrap around
module _driver(thick=0)
{
	h = 6;
	//h2 = thick ? 6.4 : h; // official is 6.4, but we need bigger
	h2 = thick ? 9 : h;
	bushing_h = thick ?  h : h;

	render() difference()
	{
		union() {
			hull()
			{
				cylinder(r=6, h=h, $fn=30);
				translate([7-1,-5,0]) cube([1,1,h]);
				translate([0,35.5,0]) cylinder(r=1, h=h);
				translate([7,43.0,0]) cylinder(r=0.2, h=h);
			}
			cylinder(r=6, h=bushing_h, $fn=30);
		}

		drill(M3, bushing_h);

		// spring hole, larger so it actually works
		translate([0,12,0]) drill(2.5, bushing_h);
		//translate([0,4,-1]) cylinder(d=0.8, h=h+2, $fn=60);
	}

	// this is the thick part of the driver, for some of the units
	// temp hack: flip it the other way
	translate([0,0,0])
	hull()
	{
		translate([7-5.5,38-1,0]) cube([1,1,h2]);
		translate([13,38,0]) cylinder(r=0.2, h=h2);
		translate([7-1,32.5,0]) cube([1,1,h2]);
		translate([7-8,32.5,0]) cube([1,1,h2]);
		translate([0,35.4,0]) cylinder(r=1, h=h2);
	}

	// angled part of the foot
	hull()
	{
		translate([7-1,3-1,0]) cube([1,1,h]);
		translate([7-1,-5,0]) cube([1,1,h]);
		translate([17.8,-2,0]) cube([1,1,h]);
	}

	// foot 
	translate([7,-5,0]) cube([20.8, 4, h]);
}

module driver(thick=0)
{
	mirror([1,0,0]) _driver(thick);
}


// 100039 page 39 of rack
// this one is really bad for figuring out what is going on where.
// all of the things are just eyeballed
// should replace it with an SVG
centering_device_coords = [-8.6, 47.4, 3];

module _centering_device(h)
{
	render() intersection() {
		translate([-37.0,16.5,0])
		render() difference()
		{
			cylinder(r=45, h=h, $fn=60);
			translate([4,3,-1]) cylinder(r=34.5, h=h+2, $fn=60);

		}
		translate([-8.6,0,-1]) cube([20,50,h+2]);
	}

	cylinder(d=9, h=2*h, $fn=30);
	translate(centering_device_coords)
	translate([0,0,-h]) cylinder(d=6, h=h, $fn=30);

	render() intersection()
	{
		union() {
			// vertical post
			translate([-4.5,-27.5,0])
			cube([4.5+2.5, 27.5, h]);

			// foot at the bottom
			translate([-14,-27.5,0])
			cube([10,3,h]);
		}

		translate([-35.0,-7.5,-1])
		cylinder(r=37, h=h+2, $fn=60);
	}

	render() difference() {
		translate([-9.5,-27.5+3,0])
		cube([5,15,h]);

		translate([-34.25,-6.5,-1])
		cylinder(r=30, h=h+5, $fn=60);
	}

}

module centering_device()
{
	h = centering_device_coords[2];
	render() difference() {
		_centering_device(h);

		// main shaft
		translate([0, 0, -1]) cylinder(d=5, h=2*h+2, $fn=30);

		// top hole
		translate([-8.6, 47.4, -1]) cylinder(d=3, h=h+2, $fn=30);
	}
}


// 100046 page 46
// roll centering device 
module roll_centering_device()
{
	render() difference() {
		cylinder(d=13, h=6, $fn=60);
		translate([0,0,-1]) cylinder(d=4, h=6+2, $fn=60);
	}
}

module centering_device_assembly()
{
	centering_device();
	translate(centering_device_coords)
	roll_centering_device();
}

// the outline is complex, so it is done as an SVG.
// but the screw holes must be exact. there are some common ones 
module _bearingblock_base(file)
{
	render() difference()
	{
		linear_extrude(height=bearingblock_t) import(file);

		// baseplate mounting screws; cheat the position slightly since baseplate is messed up
		dupe([
			[bearingblock_c, 9.5 - 0],
			[bearingblock_c - 33.25, 9.5 - 0],
			[bearingblock_c + 33.25, 9.5 - 0],
		])
		drill(M25, bearingblock_t, tap=true);

		// centering device axle and capture plate
		translate([bearingblock_w - 4, 29, 0])
		{
			drill(M3, bearingblock_t);

			dupe([[0,-7.5], [0,+7.5]])
			drill(M25, bearingblock_t, tap=true);
		}

		// not sure
		translate([bearingblock_w - 12, 88.5, 0])
		drill(4.2, bearingblock_t);

		translate([bearingblock_w - 21, 82, 0])
		drill(2, bearingblock_t);
	}
}

// 100001 - bearing block left
module bearing_block_left()
{
	render() difference()
	{
		_bearingblock_base("bearingblock-left.svg");

		// shaft holder
		translate([bearingblock_w - 65, 63.5])
		{
			// slight clearance for the holder
			//drill(7+0.75, bearingblock_t);

			spin(3, r=20/2, phase=90)
				drill(M25, bearingblock_t, tap=true);

			// add a M3 through hole, just in case
			drill(M3, bearingblock_t);
		}

		// hole for the reversing cup locating pin
		translate([bearingblock_w - 65, 63.5+34.5,0])
		drill(3.2, bearingblock_t);
	}

	// spring thingy
	render() difference() {
		translate([bearingblock_w - 33, 42,bearingblock_t])
		box(33-25, 45-42, 8-2.5, ref="+++");

		translate([bearingblock_w - 27.5, 42, bearingblock_t + 3]) 
		rotate([-90,0,0]) drill(2, 5);
	}
}

// 100012 - bearing block right
// center shaft is 65,63.5 from bottom *RIGHT* corner
// which is is 97-65,63.5 from the bottom *LEFT* corner, which is the origin
bearing_block_len = 97;
bearing_block_center_x = 65;
bearing_block_center_y = 63.5;

module bearing_block_right()
{
	render() difference()
	{
		_bearingblock_base("bearingblock-right.svg");

		// access roll holder, countersunk
		translate([bearingblock_w - 65, 63.5,0])
		{
			spin(3, r=30/2, phase=90)
				countersink(M25, bearingblock_t, reverse=true);

			// add a M3 through hole, just in case
			drill(M3, bearingblock_t);
		}
	}
}


// 100006 in rack.pdf
// the outline is complex, so it is stored as an SVG at 2:1 scale
module lever()
{
	render() difference() {
		// shift it so that 0,0 is the main pivot hole
		scale(0.5)
		translate([-19,-51,0])
		linear_extrude(height=4) import("lever.svg");

		// make the pivot slightly oversized
		drill(7+0.5,2);
	}

	// pivot with set screw
	render() difference() {
		hollow_cylinder(15, 7, 12);
		translate([-15/2, 0, 7]) rotate([0,90,0]) drill(4, 10, tap=true);
	}

	// things to engage the "wedge"?
	mirror_dupe([0,1,0])
	translate([0,21.5,0])
	{
		cylinder(d=7, h=3.5, $fn=30);
		cylinder(d=6, h=12, $fn=60);
		translate([0,0,12]) sphere(d=6, $fn=30);
	}

	// lever; not positive of the offset, just guessing
	translate([3.5,51,0])
	render() difference()
	{
		box(10, 2, 15, ref="-c+");
		translate([-5,1,15-5.5]) rotate([90,0,0]) drill(3.2, h=2);
	}
}

// 100003 compensator
// this is one of the more important parts: it is pressed by *every key*
// and advances the ratchet pawls.  there is webbing that is hard to print,
// so it is moved to be on the bottom layer.
//
module compensator()
{
	h = 241;
	thick = 12;
	axle_pos = h - 102.5;

translate([0,-axle_pos,-thick/2])
{
#translate([0,h,0]) cube([142,10,10]);
	render() difference()
	{
		// massive piece of plate...
		cube([compensator_w, h, thick]);

		// upper right corner, leaving a bit of extra webbing
		translate([142, h-93-5, thick/2]) round_box(100,120,thick+2);
		translate([142, h-95, -1]) round_box(100,120,thick+2);

		// arms for the lifter, leaving some extra webbing that hopefully
		// doesn't impact the rotor toothed wheels
		hull() {
			translate([5+10,h-93,-1]) round_box(142-10*2-5*2,95,thick+2,5);
			translate([5,h-25,-1]) round_box(142-5*2,95,thick+2,5);
		};
		translate([5,h-93-5,thick/2]) round_box(142-5*2, 95+5, thick, 5);

		// the six little wells at the bottom
		for(y=[6,6+17+5]) {
			translate([5,y,-1]) round_box(60,17,thick+2);
			translate([5+60+5,y,-1]) round_box(67,17,thick+2);
			translate([5+60+5+67+5,y,-1]) round_box(72,17,thick+2);
		}

		// the three big wells across the top, with partial webbing
		translate([5,h-191,-1]) round_box(65,191-110, thick+2);
		translate([5,h-191,thick/2]) round_box(65,191-110+3, thick+2);

		translate([5+65+5,h-191,-1]) round_box(66,191-110, thick+2);
		translate([5+65+5,h-191,thick/2]) round_box(66,191-110+5, thick+2);

		translate([5+65+5+66+5,h-191,-1]) round_box(68,191-110, thick+2);
		translate([5+65+5+66+5,h-191,thick/2]) round_box(68,191-110+3, thick+2);

		// clearance cutout on left side
		translate([19.3,h-129.5,-1]) cylinder(r=18, h=thick+2);

		// set screws for the ratchet axle
		dupe([
			[2.5,h-5,thick],
			[142-2.5,h-5,thick],
		]) drill(M14, thick, tap=true, countersink=true, dir=-1);

		// ratchet axle
		translate([-1,h-5,thick/2]) rotate([0,90,0]) cylinder(d=M3,h=h, $fn=60);

		// pivots are M25 bolts, but not tapped so that they can freely spin
		translate([-1,axle_pos,thick/2]) rotate([0,90,0]) cylinder(d=M3, h=20+1, $fn=30);
		translate([compensator_w+1,axle_pos,thick/2]) rotate([0,-90,0]) cylinder(d=M3, h=20+1, $fn=30);
	}


	// add back in the curvy clearance arm
	translate([19.3,h-129.5,0])
	render() difference() {
		cylinder(r=23,h=thick);
		translate([0,0,-1]) cylinder(r=18,h=thick+2);
		translate([-19.3+5,-50,-1]) cube([100,100,thick+2]);
	}

	// spring thingies
	spring_h = h - 102.5 - 78.5;

	mirror_dupe(center=[compensator_w/2, 0, 0])
	translate([0,spring_h,0])
	render() difference()
	{
		box(8,5,6, ref="-c+");
		translate([-4,0,3]) rotate([-90,0,0]) cylinder(d=3, h=10, $fn=16, center=true);
	}

	// angled pawl stops
	pawl_h = h - 102.5 - 107 - 12;
/*
	translate([-12,pawl_h,0])
	render() difference() {
		translate([0,0,0]) cube([12,12,10]);
		translate([20,0,5.5])
		rotate([180+5,0,180]) cube([30,20,20]);
	}

	translate([compensator_w,pawl_h,0])
	render() difference() {
		translate([0,0,0]) cube([12,12,10]);
		translate([20,0,5.5])
		rotate([180+5,0,180]) cube([30,20,20]);
	}
*/
	// straight pawl stops (angle is now on the bumper on the base plate)
	dupe([
		[-12,pawl_h,0],
		[compensator_w,pawl_h,0],
	]) box(12,12,10);
}
	
}




module bearing_assembly()
{
	// the official baseplate is 159 apart on the inside of the bearing block mounts
	color("green") translate([0,0,0]) bearing_block_left();
	%translate([0,0,159-5]) bearing_block_right();

	translate([bearing_block_len - bearing_block_center_x,bearing_block_center_y,0]) {
		translate([0,0,-2.5]) rotate([0,0,0]) shaft_holder();
		translate([0,0,+3.5]) lever();
		color("silver") translate([0,0,+45]) roll_shaft();
		%translate([0,0,10]) rotate([0,0,0]) reflector_assembly();

		translate([0,0,136-27*2]) rotate([0,180,360/26/2]) animated_assembly(0,0);
		translate([0,0,136-27]) rotate([0,180,360/26/2]) animated_assembly(0,0);
		translate([0,0,136]) rotate([0,180,360/26/2]) animated_assembly(0,0);

		translate([0,0,159-2.5]) rotate([0,180,-90]) access_roll();
	}


	// centering assembly is 4,29 on the bearing plate
	translate([bearing_block_len-4,29,00])
	{
		cylinder(d=5,h=159);
		for(i=[0:2])
		{
			translate([0,0,70+i*27])
			centering_device_assembly();
		}
	}
}


// 10002
// this is an enormous waste of material; don't print it!
// everything is relative to the center line, so center the plate
baseplate_screws = [
	[baseplate_center+117, 178, 5], // not sure on dimension
	[baseplate_center-226/2, 271.5, 5], // not sure on x position

	[baseplate_center-70, 95.5, 3.2],
	[baseplate_center+78, 95.5, 3.2],

	[baseplate_center-100, 133.5, 3.2],
	[baseplate_center+91.5, 133.5, 3.2],

	[baseplate_center-3.5, 114.5, 3.2],
	[baseplate_center+4.0, 40.0, 4.2],

	[baseplate_center-241/2, 100.5, 4],
	[baseplate_center+241/2, 100.5, 4],

	[baseplate_center-230/2, 48.5, 4.2],
	[baseplate_center+230/2, 48.5, 4.2],

	[baseplate_center-227/2, 14, 5],
	[baseplate_center+227/2, 14, 5],

	[baseplate_center-226/2, 26.0, 4.2],
	[baseplate_center+226/2, 26.0, 4.2],
	[baseplate_center-226/2, 70.5, 4.2],
	[baseplate_center+226/2, 70.5, 4.2],
];


module baseplate()
{

	color("gray")
	translate([-baseplate_w/2,0,0])
	render() difference()
	{
		box(baseplate_w, baseplate_h, baseplate_thick, r=4);

		for(screw=baseplate_screws)
		{
			translate([screw[0],screw[1],0])
			countersink(screw[2], baseplate_thick+2, $fn=16);
		}
	}

	// compensator brackets are 219 on the inside
	mirror_dupe()
	translate(compensator_pos)
	render() difference()
	{
		box(6,18,40, pos=[0,0,-29], ref="-c+");
		translate([-6,0,0]) rotate([0,90,0]) drill(M3, 6, tap=true); // countersink(6,6);
	}

	// bearing block brackets, 159mm apart (inside)
	translate(bearingblock_pos)
	mirror_dupe(center=[(159+2*4)/2,0,0])
	render() difference() {
		union() {
			cube([4,101,26]);
			box(6,101,baseplate_thick+2, ref="+++");
		}
		dupe([
			[0, 50, 22],
			[0, 50+66.5/2, 22],
			[0, 50-66.5/2, 22],
		])
		rotate([0,90,0]) drill(M25, 4, countersink=true);
	}

	// springs for the centering devices
	// for printability this uses a standard bic pen spring, 4.3mm
	translate([-baseplate_center,baseplate_h,0])
	for(i=[0:3])
	{
		translate([48+11/2+27*i,-38.5-13/2,0])
		render() difference() 
		{
			union() {
				//translate([0,0,15.5]) rotate([-90,0,0]) cylinder(r=5.5, h=13);
				//box(11,13,15.5, ref="c++");
				translate([0,0,15.5]) rotate([-90,0,0]) cylinder(r=6.5, h=13);
				box(13,13,15.5, ref="c++");
			}
			//translate([0,13-9,15.5]) rotate([-90,0,0]) cylinder(d=6.2, h=19.1);
			translate([0,13-9,15.5]) rotate([-90,0,0]) cylinder(d=4.4*2, h=19.1);
		}
	}

	// stops for the ratchet pawls, 1000112
	// this merges the 10x3mm 100045 and 10x11mm high 100037 into a single unit
	// also adds a fourth stop for u-boat enigma
	translate([-baseplate_center,baseplate_h,baseplate_thick])
	for(i=[0:3])
	{
		translate([89+i*27-27,-(baseplate_h-236),0])
		cylinder(d=10, h=3 + 11);
	}
	
	// add the compensator stops (100111), with a 5 degree slant
	// 5.1m post + 10x3mm cap
	// this will allow the compensator angled stop to be redone with a bottom flat
	mirror_dupe()
	translate([230/2,48.5,0])
	render() difference()
	{
		cylinder(d=10, h=12 + baseplate_thick);
		translate([0,0,3.5 + 10+baseplate_thick]) rotate([5,0,0]) cube([20,20,20], center=true);
	}
}

module compensator_assembly()
{
	color("pink") compensator();
	color("pink")
	translate([5,102.5-5,0]) {
		rotate([0,90,0]) cylinder(d=5, h=140);

		translate([64,0,0]) rotate([-15,0,0]) rotate([90,0,90]) driver(1);
		translate([64+27,0,0]) rotate([-15,0,0]) rotate([90,0,90]) driver(1);
		translate([64+54,0,0]) rotate([-5,0,0]) rotate([90,0,90]) driver(0);
	}
}


