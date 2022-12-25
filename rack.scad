// rack pdf designs

// ??? page ?
module _driver(thick=0)
{
	h = 3;
	h2 = thick ? 6.4 : h;

	render() difference()
	{
		hull()
		{
			cylinder(r=5, h=h, $fn=30);
			translate([7-1,-5,0]) cube([1,1,h]);
			translate([0,35.5,0]) cylinder(r=1, h=h);
			translate([7,43.0,0]) cylinder(r=0.2, h=h);
		}

		translate([0,0,-1]) cylinder(d=6, h=h+2, $fn=60);
		translate([0,4,-1]) cylinder(d=0.8, h=h+2, $fn=60);
	}

	// this is the thick part of the driver, for some of the units
	hull()
	{
		translate([7-5.5,38-1,0]) cube([1,1,h2]);
		translate([13,38,0]) cylinder(r=0.2, h=h2);
		translate([7-1,32.5,0]) cube([1,1,h2]);
		translate([7-8,32.5,0]) cube([1,1,h2]);
		translate([0,35.5,0]) cylinder(r=1, h=h2);
	}

	hull()
	{
		translate([7-1,3-1,0]) cube([1,1,h]);
		translate([7-1,-5,0]) cube([1,1,h]);
		translate([17.8,-2,0]) cube([1,1,h]);
	}

	translate([7,-5,0]) cube([20.8, 4, h]);
}

module driver(thick=0)
{
	mirror([1,0,0]) _driver(thick);
}


// 100039 page 39 of rack
// this one is really bad for figuring out what is going on where.
// all of the things are just eyeballed
centering_device_coords = [-8.6, 47.4, 0];

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
	translate(centering_device_coords) cylinder(d=6, h=h, $fn=30);

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
	h = 2;
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

// 100001 - bearing block left
module bearing_block_left()
{
	linear_extrude(height=2.5) import("bearingblock-left.svg");
}
// 100012 - bearing block right
module bearing_block_right()
{
	linear_extrude(height=2.5) import("bearingblock-right.svg");
}

module round_box(w,l,h,r=5,$fn=16)
{
	hull() {
		translate([r,r,0]) cylinder(r=r, h=h);
		translate([w-r,r,0]) cylinder(r=r, h=h);
		translate([w-r,l-r,0]) cylinder(r=r, h=h);
		translate([r,l-r,0]) cylinder(r=r, h=h);
	}
}

// 100003 compensator
// this is one of the more important parts: it is pressed by *every key*
// and advances the ratchet pawls.  there is webbing that is hard to print,
// so it is moved to be on the bottom layer.
module compensator()
{
	h = 241;
	thick = 12;

	render() difference()
	{
		// massive piece of plate...
		cube([219, h, thick]);

		// upper right corner, leaving a bit of extra webbing
		translate([142, h-95-5, thick/2+2]) round_box(100,120,thick+2);
		translate([142, h-95, -1]) round_box(100,120,thick+2);

		// arms for the lifter, leaving some webbing
		hull() {
			translate([19.3,h-95,-1]) round_box(142-19.3*2-5*2,95,thick+2,5);
			translate([5,h-25,-1]) round_box(142-5*2,95,thick+2,5);
		};
		translate([5,h-95-5,thick/2]) round_box(142-5*2, 95+5, thick, 5);

		// the six little wells at the bottom
		for(y=[6,6+17+5]) {
			translate([5,y,-1]) round_box(60,17,thick+2);
			translate([5+60+5,y,-1]) round_box(67,17,thick+2);
			translate([5+60+5+67+5,y,-1]) round_box(72,17,thick+2);
		}

		// the three big wells across the top, with partial webbing
		translate([5,h-191,-1]) round_box(65,191-110, thick+2);
		translate([5,h-191,thick/2]) round_box(65,191-110+5, thick+2);

		translate([5+65+5,h-191,-1]) round_box(66,191-110, thick+2);
		translate([5+65+5,h-191,thick/2]) round_box(66,191-110+5, thick+2);

		translate([5+65+5+66+5,h-191,-1]) round_box(68,191-110, thick+2);
		translate([5+65+5+66+5,h-191,thick/2]) round_box(68,191-110+5, thick+2);

		// clearance cutout on left side
		translate([19.3,h-129.5,-1]) cylinder(r=18, h=thick+2);

		// set screws for the ratchet axle
		translate([2.5,h-5,-1]) cylinder(d=1.5,h=thick+2);
		translate([142-2.5,h-5,-1]) cylinder(d=1.5,h=thick+2);

		// ratchet axle
		translate([-1,h-5,thick/2]) rotate([0,90,0]) cylinder(d=6,h=h);

		// pivots
		translate([-1,h-102.5,thick/2]) rotate([0,90,0]) cylinder(d=5, h=2+1, $fn=30);
		translate([219+1,h-102.5,thick/2]) rotate([0,-90,0]) cylinder(d=5, h=2+1, $fn=30);
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
	translate([-8,spring_h,0])
	render() difference()
	{
		cube([8,5,6]);
		translate([2,-1,3]) rotate([-90,0,0]) cylinder(d=2, h=10);
	}
	translate([219,spring_h,0])
	render() difference()
	{
		cube([8,5,6]);
		translate([6,-1,3]) rotate([-90,0,0]) cylinder(d=2, h=10);
	}

	// angled pawl stops
	pawl_h = h - 102.5 - 107 - 12;
	translate([-12,pawl_h,0])
	render() difference() {
		translate([0,0,0]) cube([12,12,10]);
		translate([20,0,5.5])
		rotate([180+5,0,180]) cube([30,20,20]);
	}

	translate([219,pawl_h,0])
	render() difference() {
		translate([0,0,0]) cube([12,12,10]);
		translate([20,0,5.5])
		rotate([180+5,0,180]) cube([30,20,20]);
	}
	
}


/*
centering_device();
translate([0,0,2]) translate(centering_device_coords) roll_centering_device();
*/

translate([-10,219,0]) rotate([90,0,+90]) bearing_block_left();
translate([130,219,0]) rotate([90,0,+90]) bearing_block_right();

compensator();
