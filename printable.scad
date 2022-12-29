include <rotor.scad>
include <rack.scad>

// if we're making a small one, then we adjust some sizes
pocket_sized = 1;

// shaft is a M3 with a little bit of extra space
rotor_axle_d = pocket_sized ? M3 : 9;
rollplate_peg_s = 12;
rollplate_h = 4;
rollplate_d = 55.8;

// mill-max 0985-0-15-20-71-14-11-0 pogo pin
pin_size = 0.037 * 25.4 * 2;

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
	drill(rotor_axle_d, 20);

	// through-holes for the pogo pins copied from the coping
		// contacts
		spin(26, r=45.2/2, offset=0.5)
			drill(pocket_sized ? pin_size + drill_offset : 2.1, 10);

		// m2.5 screws to connect to the center toothed wheel
		spin(3, r=26/2, phase=-90)
			countersink(pocket_sized ? M25 : 3.1, toothed_wheel_height, 3, reverse=true);
}
}

//%bushing();

// this merges the center wheel, the bushing, the steelbushing and the coping
// the base will likely be replaced with a PCB
module center_wheel_printable()
{
	render() difference()
	{
		cylinder(d=57, h=4, $fn=120);

		// three m25 to connect to the toothed wheel
		spin(3, r=26/2, phase=90)
			drill(pocket_sized ? M25 : 3, 10, tap=true);

		drill(rotor_axle_d, 20);

		// through holes for the contacts
		// mill-max 0985-0-15-20-71-14-11-0
		spin(26, r=45.2/2, offset=0.5)
		{
			cylinder(d=0.037*25.4*2, h=6.8, $fn=24);
			translate([0,0,25.4*(0.186-0.028)*2]) cylinder(d=0.042*25.4*2, h=3, $fn=24);
		}
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
			drill(rotor_axle_d, 29);
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

	translate([0,0,-5.5]) hollow_cylinder(75, 58, 5.5, $fn=26);
}


// this will likely be a PCB in the final version
module rollplate_printable()
{
	peg_s = rollplate_peg_s + 0.75;

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

module centering_device_printable()
{
	h = centering_device_coords[2];
	render() difference() {
		union() {
			_centering_device(h);
			cylinder(d=9, h=27, $fn=60);
			translate([-8.6, 47.4, 0]) cylinder(d=8, h=h+1, $fn=60);
		}

		// main shaft
		drill(M3, 27);

		// top hole
		translate([-8.6, 47.4, 0]) drill(M25, h+1, tap=true);
	}
}

module roll_centering_device_printable()
{
	render() difference() {
		cylinder(d=13, h=6, $fn=60);
		drill(M25 + 0.1, 6, countersink=true);
	}
}

scale(0.5)
{
rollplate_printable();

// fuse the center wheel and digit ring, until we have a way to make them rotate
translate([0,90,0]) {
	center_wheel_printable();
	translate([0,0,5.5]) digitring_printable();
}

translate([-50,28,0]) rotate([0,0,-90]) driver(1);
translate([80,50,0]) toothed_wheel_printable();

//translate([50,120,0]) bearing_block_right();
//translate([-50,120,0]) bearing_block_left();

/*
linear_dupe(3, [30,0,0]) {
centering_device_printable();
translate([-10,20,0]) roll_centering_device_printable();
}
*/
}
