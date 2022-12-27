// keyboard from the rack pdf
include <util.scad>

// 100021 pillar small
pillar_small_len = 31;
module pillar_small()
{
	render() difference()
	{
		cylinder(d=6, h=pillar_small_len, $fn=32);

		// tap both sides
		mirror_dupe([0,0,1], center=[0,0,pillar_small_len/2]) 
		drill(3, 8, tap=true);
	}
}

// 100019
column_short_len = 75.7;
column_long_len = 92.7;
module column_short()
{
	render() difference()
	{
		cylinder(d=7, h=column_short_len, $fn=32);

		// tap both sides
		mirror_dupe([0,0,1], center=[0,0,column_short_len/2]) 
		drill(4, 10, tap=true);
	}
}

// column long 100017 7mm x 92.7 with cross drilled m3 at 18mm
module column_long()
{
	render() difference()
	{
		cylinder(d=7, h=column_long_len, $fn=32);

		// tap both sides
		mirror_dupe([0,0,1], center=[0,0,column_long_len/2]) 
		drill(4, 10, tap=true);

		// cross drill
		translate([0,-5,column_long_len - 18])
		rotate([-90,0,0])
		drill(3, 10, tap=true);
	}
}

// input board 100018
// held up by column short 100019 7mm x 75.7
// and column long 100017 7mm x 92.7 with cross drilled m3 at 18mm


// there are fancy curves that we are ignoring for now
// the input board is also supposed to be bent metal, so it is "hollow"
// while this one is solid
input_board_w = 257;
input_board_h = 82;

module input_board_base()
{
	box(input_board_w, input_board_h, 10.7,
		pos=[0,input_board_h,0], ref="c-+");

	box(input_board_w, input_board_h - 39.5, 19.2-10.7,
		pos=[0,input_board_h,10.7], ref="c-+");

	box(input_board_w, input_board_h - 60.5, 27.7 - 19.2,
		pos=[0,input_board_h,19.2], ref="c-+");
}

module input_board()
{
	translate([0,-46.25+8.5,0])
	render() difference()
	{
		input_board_base();

		for(i=[0:8]) {
			translate([input_board_w/2 - 26.5 - i*24.2,68.5,-1])
			cylinder(d=6.2, h=100);
		}

		for(i=[0:7]) {
			translate([input_board_w/2 - 43.8 - i*24.2,46.5,-1])
			cylinder(d=6.2, h=100);
		}

		for(i=[0:8]) {
			translate([input_board_w/2 - 36.9 - i*24.2,24.0,-1])
			cylinder(d=6.2, h=100);
		}

		// top row mounting screws
		mirror_dupe()
		drill(4.2, 100, pos=[226/2, 68.5, 27.7], countersink=true, dir=-1);

		// bottom row mounting screws
		mirror_dupe()
		drill(4.2, 100, pos=[226/2, 24.0, 10.7], countersink=true, dir=-1);

		// center row mounting screw
		drill(4.2, 100, pos=[ 0, 46.25, 19.2], countersink=true, dir=-1);

		// fake the hollow body with large holes for the shafts
		mirror_dupe()
		drill(10, 27.7-2, pos=[226/2, 68.5]);
		mirror_dupe()
		drill(10, 10.7-2, pos=[226/2, 24.5]);
		drill(10, 19.2-2, pos=[ 0, 46.25]);

		// front mounting holes
	}
}


// 100020
module contactor_plate()
{
	contactor_plate_w = 243;
	contactor_plate_h = 56;
	contactor_plate_thick = 2;

	translate([0,8.2,0])
	render() difference()
	{
		box(contactor_plate_w, contactor_plate_h, contactor_plate_thick, ref="cc+");

		// rounded cutouts on the edge
		mirror_dupe()
		translate([contactor_plate_w/2, 0,-1])
		box(30,13,3, r=5, ref="cc+");

		// pass through for upper input board columns,slightly oversized
		quad_dupe()
		translate([226/2, 44.5/2, -1])
		cylinder(d=7+0.5, h=contactor_plate_thick+2, $fn=32);

		// top row drills
		for(i=[0:8])
			translate([-91.6+24.2*i,44.5/2,-1])
			{
				cylinder(d=6.2, $fn=24, h=contactor_plate_thick+2);
				mirror_dupe()
				translate([6.6,-4.6,0]) cylinder(d=2, h=contactor_plate_thick+2, $fn=16);
			}

		// middle row drills
		for(i=[0:7])
			translate([-85+24.2*i,0/2,-1])
			{
				cylinder(d=6.2, $fn=24, h=contactor_plate_thick+2);
				mirror_dupe()
				translate([6.6,-4.6,0]) cylinder(d=2, h=contactor_plate_thick+2, $fn=16);
			}

		// bottom row drills
		for(i=[0:8])
			translate([-102+24.2*i,-44.5/2,-1])
			{
				cylinder(d=6.2, $fn=24, h=contactor_plate_thick+2);
				mirror_dupe()
				translate([5.5,+4.6,0]) cylinder(d=2, h=contactor_plate_thick+2, $fn=16);
			}

		// some random drills
		translate([4,-8.2,-1]) cylinder(d=4.2, h=contactor_plate_thick+2, $fn=16);
		translate([0,0,-1]) cylinder(d=4.2, h=contactor_plate_thick+2, $fn=16);

		// label to make the top side obvious
		translate([0,5,contactor_plate_thick-1])
		linear_extrude(height=2) text("TOP", size=5);
	}
}


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


module keyboard_assembly()
{
translate([0,40,baseplate_thick + column_short_len - (10.7-2)]) input_board();
translate([0,40,baseplate_thick + pillar_small_len]) contactor_plate();

// this might not be right
translate([   4.0,  40.0, baseplate_thick]) pillar_small();

mirror_dupe()
{
// not shown -- column center high
translate([-226/2,70.5,baseplate_thick]) column_long();
translate([-226/2,26.0,baseplate_thick]) column_short();
}
}

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
rotate([0,0,180])
translate([0,-23,0]) // center on the center screw
segment_plate();


}
