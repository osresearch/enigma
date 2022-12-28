// this makes sure that the tap and drill offsets are good for the bolt sizes

include <util.scad>

t = 10;

scale(0.5)
render() difference()
{
	box(50,40,t, r=2, ref="cc+");

	translate([-20,-18,t-1])
	linear_extrude(height=2)
	text(str("Drill ", drill_offset, "   Tap ", tap_offset), size=4);
	
	for(p=[
		[M2, -10, "M2"],
		[M25, 0, "M2.5"],
		[M3, 10, "M3"],
	]) {
		translate([+25,p[1],t/2]) rotate([0,-90,0]) drill(p[0], 10);

		translate([p[1]-5,-40/2,t/2]) rotate([-90,0,0]) drill(p[0], 5, tap=true);
		translate([p[1]-5,+40/2,t/2]) rotate([90,0,0]) drill(p[0], 5, countersink=true);

		translate([+15,p[1],t-1]) linear_extrude(height=2) text(p[2], size=3);
		translate([-20,p[1],0]) translate([0,0,t]) drill(p[0], t, countersink=true, dir=-1);
		translate([-10,p[1],0]) drill(p[0], t, countersink=true);
		translate([  0,p[1],0]) drill(p[0], t);
		translate([+10,p[1],0]) drill(p[0], t, tap=true);
	}
}
