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
