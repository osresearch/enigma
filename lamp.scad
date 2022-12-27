// lamp stuff from the rack pdf
include <util.scad>


// 10022
module segment_plate()
{
	segment_plate_w = 218;
	segment_plate_h = 46;
	segment_plate_thick = 2;

	bottom_drill = -segment_plate_h/2 + 3.5;
	top_drill = -segment_plate_h/2 + 42;

	render() difference()
	{
		box(segment_plate_w, segment_plate_h, segment_plate_thick, ref="c++");

		// random drills
		drill(4.2, segment_plate_thick, coords=[
			[  0.0, 23],
			[-95.0, 4.0],
			[-65.5, 4.0],
			[  5.5, 4.0],
			[ 78.5, 4.0],
			[ 96.5, 4.0],
			[-81.5, 42],
			[+66.5, 42],
		]);

		// notched edges
		mirror_dupe()
		translate([segment_plate_w/2-5,29,-1])
		cube([50,50,segment_plate_thick+2]);

		// triple hole pattern at the bottom
		for(i=[0:8])
			translate([-segment_plate_w/2 + 6 + i*24.2, +3.5, 0])
			drill(2, segment_plate_thick, tap=true, coords=[
				[0,0],
				[0,5],
				[0,10],
			]);

		// triple hole pattern at the top
		for(i=[0:8])
			translate([-segment_plate_w/2 + 16.4 + i*24.2, +31.5, 0])
			drill(2, segment_plate_thick, tap=true, coords=[
				[0,0],
				[0,5],
				[0,10],
			]);
		for(i=[0:7])
			translate([-segment_plate_w/2 + 23.3 + i*24.2, +28.0, 0])
			drill(2, segment_plate_thick, tap=true, coords=[
				[0,0],
				[0,5],
				[0,10],
			]);
	}

	// side plates
	mirror_dupe()
	translate([-segment_plate_w/2,0,0])
	render()  difference()
	{
		box(2,29,14, ref="+++");
		mirror([1,0,0]) rotate([0,-90,0])
		{
			drill(6, 2, [5,18]);
			drill(3, 2, tap=true, coords=[
				[10,5],
				[10,24],
			]);
		}
	}
}


// 100050
// this is supposed to be made from bent sheet metal, so it isn't exactly right
module lamp_holder()
{
	lamp_holder_w = 226;

	render() difference() {
		box(lamp_holder_w, 60, 2, ref="cc+");
		countersink(5, 2, reverse=true);

		for(i=[0:7])
			drill(9.3, 2, pos=[lamp_holder_w/2-29-i*24, 0]);
		for(i=[0:8])
			drill(9.3, 2, pos=[lamp_holder_w/2-19-i*24, +40/2]);
		for(i=[0:8])
			drill(9.3, 2, pos=[lamp_holder_w/2-22-i*24, -40/2]);
	}

	mirror_dupe()
	translate([lamp_holder_w/2,0,2])
	rotate([0,90,0])
	render() difference()
	{
		hull() {
			box(1,1,2, pos=[0,+60/2,0], ref="+-+");
			box(1,1,2, pos=[0,-60/2,0], ref="+++");
			box(1,1,2, pos=[30,+60/2,0], ref="+-+");
			box(1,1,2, pos=[30,-60/2,0], ref="+++");
			box(1,1,2, pos=[51,+29/2,0], ref="--+");
			box(1,1,2, pos=[51,-29/2,0], ref="-++");
		}

		dupe([
			[51-33, +40/2],
			[51-33,  0],
			[51-33, -40/2],
			[51- 6, -19/2],
			[51- 6, +19/2],
		])
		drill(3.2, 2);
	}
}


// merged socket bar 100061 and L section 100060
module socket_bar()
{
	socket_bar_w = 223;
	socket_bar_h = 55;
	socket_bar_t = 4;

	render() difference()
	{
		box(socket_bar_w, socket_bar_h, socket_bar_t, ref="cc+");

		dupe([
			[-214/2, -40/2],
			[-214/2, +40/2],
			[+214/2, -40/2],
			[+214/2, +40/2],
			[-214/2, 0],
			[-144/2, 0],
  			[     0, 0],
			[+144/2, 0],
			[+214/2, 0],
		]);
			drill(3.2, socket_bar_t);

		for(i=[0:8])
			drill(3, socket_bar_t, pos=[socket_bar_w/2 - 10.5 - 24*i, 40/2]);
		for(i=[0:7])
			drill(3, socket_bar_t, pos=[socket_bar_w/2 - 27.5 - 24*i, 0]);
		for(i=[0:8])
			drill(3, socket_bar_t, pos=[socket_bar_w/2 - 20.5 - 24*i, -40/2]);
	}

	// L-section
	mirror_dupe()
	translate([socket_bar_w/2,0,0])
	render() difference()
	{
		box(3, socket_bar_h, 8, ref="+c+");
		rotate([90,0,90])
		dupe([
			[-20,4.5],
			[  0,4.5],
			[+20,4.5],
		])
		drill(3, 18, tap=true);
	}
}

// stack up of:
// isolator plate 100062
// lamp holder
// socket bar 100061 + L section 100060
// flanges
// segment plate
module lamp_assembly()
{
dupe([
	[  -3.5, 114.5],
	[-100.0, 133.5],
	[ +91.5, 133.5],
	[ -70.0, 95.5 ],
	[ +78.0, 95.5 ],
], z=baseplate_thick)
	pillar_small();
	
translate([-3.5,114.5, baseplate_thick + pillar_small_len])
{
	rotate([0,0,180]) // spin it around
	translate([0,-23,0]) // center on the center screw
	segment_plate();

	translate([0,8.5,33]) socket_bar();

	translate([0,8.5,53.5]) lamp_holder();
}

}

