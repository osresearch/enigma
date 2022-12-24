// based on http://www.enigma.hs-weingarten.de/drawings.php

module hollow_cylinder(d1,d2,h,$fn=60)
{
	render() difference()
	{
		cylinder(h=h, d=d1);
		translate([0,0,-1]) cylinder(h=h+2, d=d2);
	}
}

module countersink(d,h,h2=1, $fn=30)
{
	//translate([0,0,-5]) cylinder(d=d+sqrt(2), h=5);
	translate([0,0,-0.1]) cylinder(d2=d, d1=d+h2*sqrt(2), h=h2+.1);
	cylinder(d=d, h=h);
}

// page 1
module kerfring()
{
	render() difference()
	{
		hollow_cylinder(74.2, 63.8, 2);

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
module digitring(which=23)
{
	render() difference()
	{
		hollow_cylinder(75, 60, 8.5 + 1.5);

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
		%for(i=[1:26])
		{
			rotate([0,0,-90 + (i-which)*360/26])
			translate([75/2-0.75,0,8.5/2])
			rotate([0,90,0])
			linear_extrude(height=1)
			text((i < 10 ? str("0",i) : str(i)), size=4, halign="center", valign="center");
		}

		// carry ring
		translate([63.7/2 + 20,0,8.5]) cylinder(r=20,h=5);

		// screw holes for kerf ring
		for(a=[90-48,90+48,270-48,270+48])
		{
			rotate([0,0,a])
			translate([69/2,0,11.8-6]) cylinder(d=2,h=6.1, $fn=16);
		}
	}

	// spacer
	translate([0,0,8.5]) hollow_cylinder(63.7, 60, 11.8-8.5);

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
			for(i=[1:26])
			{
				rotate([0,0,i*360/26])
				translate([od/2 - 3,0,0])
				cylinder(r=3,h=h,$fn=20);
			}
			cylinder(d=od-3, h=h);
		}

		for(i=[1:26])
		{
			rotate([0,0,(i+0.5)*360/26])
			translate([od/2 + 2,0,-1])
			cylinder(r=5,h=3.6,$fn=20);
		}
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

module toothed_wheel()
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
}


module bushing()
{
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
		for(a=[45,180+45])
			rotate([0,0,a])
			translate([60/2,0,19.6-4.2])
			rotate([0,-90,0])
			countersink(1.8, 5, 0.6);
	}
}

translate([0,0,34]) color("red") rotate([0,0,+42]) kerfring();
translate([0,0,20]) color("blue") digitring1();

translate([0,0,34]) rotate([0,180,0]) bushing();

translate([0,0,-20]) color("green") rotate([0,180,0]) toothed_wheel();
