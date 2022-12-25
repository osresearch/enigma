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


/*
centering_device();
translate([0,0,2]) translate(centering_device_coords) roll_centering_device();
*/
