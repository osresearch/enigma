// keyboard from the rack pdf
include <util.scad>

// 100018
// there are fancy curves that we are ignoring for now
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

		translate([-226/2, 24.0, -1]) cylinder(d=4.2, h=100);
		translate([+226/2, 24.0, -1]) cylinder(d=4.2, h=100);
		translate([-226/2, 68.5, -1]) cylinder(d=4.2, h=100);
		translate([+226/2, 68.5, -1]) cylinder(d=4.2, h=100);
		translate([     0, 46.5, -1]) cylinder(d=4.2, h=100);

		// front mounting holes
	}
}

//input_board();


