// based on http://www.enigma.hs-weingarten.de/drawings.php
include <util.scad>

// page 1
module kerfring(pocket_sized=0)
{
	render() difference()
	{
		hollow_cylinder(74.2, 63.8, 2, $fn=360);

		if (!pocket_sized)
		for(angle=[0,90+6,180,270+6])
			rotate([0,0,angle])
			translate([+69/2,0,2])
			mirror([0,0,1])
			countersink(2.2, 5);

		hull() {
			rotate([0,0,270+48]) translate([69/2,0,-1]) cylinder(d=2,h=3);
			rotate([0,0,270+48]) translate([74.2/2,0,-1]) cylinder(d=2,h=3);
			rotate([0,0,270+65]) translate([74.2/2+1,0,-1]) cylinder(d=2,h=3);
		}
	}
}

// inner and outer diameters are not marked?
// this merges the ring and the carry cutout into one piece
// 400002 page 2: through hole at 11, cutout at 17
// 400020 page 20: through hole at 01, cutout at 07
// 400021 page 21: through hole at 23, cutout at 03
module digitring(which=23,pocketsized=0)
{
	inner_d = 60 + 0.25; // add some slop
	render() difference()
	{
		cylinder(d=75, h=8.5 + (pocketsized ? 0 : 1.5), $fn=26);
	
		translate([0,0,-1]) cylinder(d=inner_d, h=8.5 + 1.5 + 2, $fn=360);

		// locating holes for the letter adjustments
		for(i=[1:26])
		{
			rotate([0,0,90 - (i+2)*360/26])
			translate([69.6/2,0,0])
			countersink(3,6,0.5, $fn=16);
		}

		// through-hole at very bottom
		translate([0,-69.6/2,0])
		cylinder(d=3,h=20, $fn=30);

		// digits, rotated so that they line up right and with leading zeros
		for(i=[1:26])
		{
			rotate([0,0,-90 + (i-which)*360/26])
			translate([75/2-0.75,0,8.5/2])
			rotate([0,90,0])
			linear_extrude(height=1)
			text((i < 10 ? str("0",i) : str(i)), size=5.5, halign="center", valign="center");
		}

		// carry ring cutout
		translate([63.7/2 + 20,0,8.5]) cylinder(r=20,h=5);

		// screw holes for kerf ring
		if (!pocketsized)
		for(a=[90-48,90+48,270-48,270+48])
		{
			rotate([0,0,a])
			translate([69/2,0,11.8-6]) cylinder(d=2,h=6.1, $fn=16);
		}
	}

	// spacer
	translate([0,0,8.5]) hollow_cylinder(63.7, inner_d, 11.8-8.5, $fn=360);

}

module digitring1() { digitring(11); }
module digitring2() { digitring(1); }
module digitring3() { digitring(23); }


// toothed wheel page 14
module toothed_wheel1()
{
	od = 99.55;
	h = 2.6;

	render() difference()
	{
		union() {
			spin(26, r=od/2-3)
				cylinder(r=3,h=h,$fn=20);
			cylinder(d=od-3, h=h);
		}

		spin(26, [od/2 + 2, 0, -1], offset=0.5)
			cylinder(r=5,h=3.6,$fn=20);
	}
}

module toothed_wheel2()
{
	h = 6.8 - 2.6;
	od = 72.35;
	id = 66.35;

	render() difference()
	{
		cylinder(d=od, h=h);

		for(i=[1:26])
		{
			hull() {
				rotate([0,0,(i+0.5)*360/26])
				translate([id/2+1,0,-1])
				cylinder(r=1, h=h+1, $fn=16);

				rotate([0,0,(i+0.5)*360/26])
				translate([od/2+2,0,-1])
				cylinder(r=1, h=h+1);

				rotate([0,0,(i-0.8+0.5)*360/26])
				translate([od/2+0.5,0,-1])
				cylinder(r=1, h=h+1);
			}
		}
	}
}

module _toothed_wheel()
{
	render() difference()
	{
		union() {
			toothed_wheel1();
			color("red") translate([0,0,2.6]) toothed_wheel2();
		}

		translate([0,0,-0.1]) cylinder(d=65, h=3.8+0.1, $fn=60);
		translate([0,0,3.8]) cylinder(d=57, h=5, $fn=60);
	}

	// tooth to engage bushing notch; should be rounded?
	%translate([-4/2,-57/2-5,0])
	cube([4,5,3.8]);
}

toothed_wheel_height = 6.8;
toothed_wheel_inner_height = 3.8;

module toothed_wheel()
{
	translate([0,0,toothed_wheel_height])
	rotate([0,180,0])
	_toothed_wheel();
}


// 400003 page 3
module bushing()
{
	translate([0,0,14.7])
	rotate([0,180,0])
	render() difference() {
		union() {
			translate([0,0,0.0]) hollow_cylinder(61.5, 55.8, 2.0);
			translate([0,0,2.0]) hollow_cylinder(60.0, 55.8, 19.6- 8 - 2);
			translate([0,0,19.6 - 8 - 2]) hollow_cylinder(60.0, 57.0, 8);
		}

		// detail C
		for(a=[0,-13,180,180-13])
			rotate([0,0,a])
			translate([60/2-3,0,19.6-4.2])
			rotate([0,90,0]) cylinder(d=1.6, h=5, $fn=16);

		// detail A
		for(i=[1:4])
			rotate([0,0,45+90*i])
			translate([60/2,0,19.6-4.2])
			rotate([0,-90,0])
			countersink(1.8, 5, 0.6);

		// sect B (notch? this is not right; engages with toothed wheel)
		translate([0,-60/2,19.6-4/2])
		cube([4,4,4.1], center=true);
	}
}


// 400009 page 9
module _center_toothed_wheel()
{
	outer_h = 14.7 - 3 - 6;

	render() difference()
	{
		union()
		{
			cylinder(d=57, h=14.7, $fn=120);
			translate([0,0,6.8]) cylinder(d=65, h=14.7-3-6.8, $fn=120);
		}

		// center axle
		translate([0,0,-1]) cylinder(d=9, h=20, $fn=60);

		// three pins to connect to the coping
		for(a=[90,-30,-150])
			rotate([0,0,a])
			translate([33.2/2,0,outer_h])
			cylinder(d=6, h=10, $fn=30);

		// three screws to connect to the rollplate
		// opposite the angles of the bottom ones
		for(a=[90,-30,-150])
			rotate([0,180,a])
			translate([12,0,-3.5])
			cylinder(d=3, h=5, $fn=20);

		// clear out the top
		translate([0,0,14.7-3])
		cylinder(d=52.9, h=5, $fn=60);

		// notch on outer ring
		translate([57/2,-4/2,-1]) cube([10,4,20]);

		// notch on bottom surface
		translate([-2/2,-57/2-1,-1]) cube([2,3,6.8+1]);

		// through holes for the contacts
		for(i=[1:26])
			rotate([0,0,(i+0.5)*360/26])
			translate([45.2/2,0,0])
			countersink(3.2, 15, 1);

		// four sideways mounting screws, 3.6mm deep
		for(a=[0,90,180,270])
			rotate([0,0,45+a])
			translate([57/2 - 3.6, 0, 3.7])
			rotate([0,90,0])
			cylinder(d=4.5, h=5, $fn=16);
	}

	translate([0,0,14.7-3])
	render() difference()
	{
		// center boss with locating notch
		cylinder(d=24.4, h=3);

		// center axle
		translate([0,0,-1]) cylinder(d=9, h=20, $fn=60);
		
		// notch
		translate([-3/2,24.4/2 - 3,0])
		cube([3,10,10]);
	}
}

center_toothed_wheel_height = 14.7;
module center_toothed_wheel()
{
	translate([0,0,center_toothed_wheel_height])
	rotate([0,180,0])
	_center_toothed_wheel();
}

// 40015 page 15
module coping()
{
	render() difference()
	{
		hollow_cylinder(52.9, 24.4, 3.6, $fn=120);
		
		// contacts
		spin(26, r=45.2/2, offset=0.5)
			cylinder(d=2.1, h=5, $fn=16);

		// pins to connect to the center toothed wheel
		// that part has them at 33.2/2 radius, this has 17.4?
		spin(3, r=17.4, offset=0.5)
			countersink(3.1, 10);
	}

	// add the locating notch back in
	translate([-3/2, 10, 0])
	cube([3,5,3.6]);
}

// 400011 page 11
// in the drawings there are no center holes, but there are screws
// in the photos, so these must be added to prevent it from spinning
module rollplate()
{
	render() difference() {
		hollow_cylinder(55.8, 9, 3.5);

		// contacts
		spin(26, [45.2/2,0,-1], offset=0.5)
		{
			cylinder(d=2.1, h=5, $fn=16);

			translate([0,0,2])
			cylinder(d=4, h=5, $fn=16);
		}

		// pins to connect to the center toothed wheel
		// these have been added at 12mm centers
		spin(3, r=12, offset=0.0)
			countersink(3.1, 3.5, reverse=true);
	}
}

// 400012 page 12
module steel_bushing()
{
	hollow_cylinder(9, 7, 27);

	translate([0,0,14.8])
	hollow_cylinder(13, 7, 27 - 5.6 - 14.8);
}

module animated_assembly(t,which=11)
{
translate([0,0,24 + t * 26]) color("red") rotate([0,0,+42]) kerfring();
translate([0,0,13.7 + t * 7]) color("silver") digitring(which);

translate([0,0,0])
color("silver")
steel_bushing();

translate([0,0,14.7-3.6 + t * 40]) bushing();

translate([0,0,27 - 5.6 + t * 10])
color("blue")
rotate([0,0,90]) rollplate();

translate([0,0,0-t*15])
color("yellow")
rotate([0,0,90])
center_toothed_wheel();

translate([0,0,0-t*22]) color("pink") rotate([0,0,90]) coping();

translate([0,0,0-t*40]) color("green") toothed_wheel();
}

/*
rotate([0,90,$t*360])
translate([0,0,-15])
animated_assembly(sin(180*$t)*sin(180*$t)*2);
*/


// 100106 access roll (defined in rack.pdf)
// 100014 ring what is the purpose of the ring?
// 100013 plate (replaced with PCB?)

// 100011 roll
module access_roll_housing()
{
	render() difference()
	{
		cylinder(d=60, h=16.5, $fn=180);
		translate([0,0,1.5]) cylinder(d=57, h=16.4, $fn=180);

		// three M3 holes at 120deg
		spin(3,[30/2,0,-1])
			cylinder(d=3, h=5, $fn=16);


		spin(4, pos=[60/2-5,0,16.5-2], offset=0.5)
			rotate([0,90,0])
			cylinder(d=2.2, h=10, $fn=16);

		// access hole
		box(10,20,10, r=2, rot=[90,0,0], pos=[0,-60/2,3], ref="c+c");
		
	}

	spin(3,r=30/2)
		hollow_cylinder(6,3, 12.5);

	render() difference()
	{
		hollow_cylinder(9-0.1, 5, 18.6);
		box(10,10,10, pos=[0,0,16.5], ref="+c+");
	}
}

module access_plate()
{
	render() difference()
	{
		hollow_cylinder(51, 9, h=4, $fn=360);
		spin(26, pos=[45.2/2,0,-1])
			cylinder(d=2.1, h=4+2);
		spin(3, r=30/2)
			countersink(3, 4);
	}
}

module access_roll()
{
	translate([0,0,12.5]) access_plate();
	access_roll_housing();
}

// the reflector can probably also be replaced with a PCB
// there were three:
// Reflector A 	EJMZALYXVBWFCRQUONTSPIKHGD 		
// Reflector B 	YRUHQSLDPXNGOKMIEBFZCWVJAT 		
// Reflector C 	FVPJIAOYEDRZXWGCTKUQSBNMHL 	
// the housing can be removed from the bearing blocks
// and replaced with an alternate reflector

// 300002 page 2
module reflector_cabinet()
{
	render() difference()
	{
		cylinder(d=75, h=38.9, $fn=360);

		translate([0,0,38.9-37.4])
		cylinder(d=72, h=38.9, $fn=360);

		translate([0,-34.5,-1])
		cylinder(d=3, h=5, $fn=16);

		spin(2, pos=[75/2,0,38.9], offset=0.5)
		{
			translate([0,0,-12])
			rotate([0,-90,0])
			countersink(2.2, 3);

			translate([0,0,-4])
			rotate([0,-90,0])
			countersink(2.2, 3);
		}

		// large cutout
		rotate([0,0,-30])
		translate([0,0,-1])
		render() intersection()
		{
			cylinder(d=51, h=5, $fn=60);
			cube([30,51,5], center=true);
		}
	}
}

module reflector_assembly()
{
	reflector_cabinet();
	translate([0,0,38.9 - 4]) coping();
}
