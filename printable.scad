include <rotor.scad>
include <rack.scad>

// if we're making a small one, then we adjust some sizes
pocket_sized = 1;

// shaft is a M3 with a little bit of extra space
rotor_axle_d = pocket_sized ? 6.3 : 9;
rollplate_peg_s = 12;
rollplate_h = 4;
rollplate_d = 55.8;

module toothed_wheel_printable()
{
render() difference()
{
	// the locating teeth and the advance teeth
	union() {
		toothed_wheel1();
		color("red") translate([0,0,2.6]) toothed_wheel2();
	}

	// simple shaft in the middle
	translate([0,0,-1]) cylinder(d=rotor_axle_d, h=20, $fn=120);

	// through-holes for the pogo pins copied from the coping
		// contacts
		spin(26, r=45.2/2, offset=0.5)
			drill(pocket_sized ? 3.2 : 2.1, 10);

		// m3 screws to connect to the center toothed wheel
		// that part has them at 33.2/2 radius, this has 17.4?
		spin(3, r=30/2, phase=-90)
			countersink(pocket_sized ? 6.2 : 3.1, toothed_wheel_height, 3, reverse=true);
}
}

//%bushing();

// this merges the center wheel, the bushing, the steelbushing and the coping
// the base will likely be replaced with a PCB
module center_wheel_printable()
{
	render() difference()
	{
		cylinder(d=57, h=6.8, $fn=120);

		// three pins to connect to the toothed wheel
		spin(3, r=30/2, phase=90)
			drill(pocket_sized ? 6 : 3, 10);

		translate([0,0,-1]) cylinder(d=rotor_axle_d, h=20, $fn=120);

		// through holes for the contacts
		spin(26, r=45.2/2, offset=0.5)
			countersink(3.2, 6.8, reverse=true);
	}

	// replace the steel bushing with a square peg
	bushing_height = 19.6;
	if (pocket_sized)
	{
		// the bushing doesn't go all the way through
		render() difference() {
			union() {
				cylinder(d=18, h=bushing_height - rollplate_h);

				translate([-rollplate_peg_s/2,-rollplate_peg_s/2,0])
				cube([rollplate_peg_s,rollplate_peg_s,bushing_height]);
			}
			translate([0,0,-1]) cylinder(d=rotor_axle_d, h=29, $fn=120);
		}
	} else {
	}

	// replace the outer bearing
	render() difference() {
		union() {
			cylinder(d=60.0, h=bushing_height, $fn=360);

			// bushing to hold the digitring in place, allowing kerf ring to pass
			translate([0,0,bushing_height - 2])
			cylinder(d=61.5, h=2, $fn=360);
		}

		// remove most of the cylinder
		translate([0,0,-1])
		cylinder(d=rollplate_d-2, h=bushing_height+2, $fn=180);

		// remove a shelf for the rollplate
		translate([0,0,bushing_height - rollplate_h])
		cylinder(d=rollplate_d + 1, h=rollplate_h+1, $fn=180);

		// detail C - the sideways screws for the spring thingy
		for(a=[0,-13,180,180-13])
			rotate([0,0,a])
			translate([60/2-3,0,4.2])
			rotate([0,90,0]) cylinder(d=1.6, h=5, $fn=16);
	}

}


// merge the kerf ring and the digit ring, making the kerfring extra thick
// to replace the cutout that had been in the digitring
module digitring_printable(which=1)
{
	digitring(which, pocket_sized);
	rotate([0,0,42]) translate([0,0,8.5]) scale([1,1,3]) kerfring(pocket_sized);
}


// this will likely be a PCB in the final version
module rollplate_printable()
{
	peg_s = rollplate_peg_s + 1;

	render() difference()
	{
		cylinder(d=rollplate_d, h=rollplate_h, $fn=180);

		translate([-peg_s/2,-peg_s/2,-1]) cube([peg_s,peg_s,rollplate_h+2]);

		// contacts
		spin(26, r=45.2/2, offset=0.5)
		{
			drill(pocket_sized ? 3.2 : 2.1, 5);
			drill(pocket_sized ? 4.5 : 4, 5, pos=[0,0,2]);
		}
	}
}

digitring_printable();
rollplate_printable();

translate([0,80,0]) center_wheel_printable();

translate([-50,38,0]) rotate([0,0,-90]) driver(1);
translate([80,50,0]) toothed_wheel_printable();
