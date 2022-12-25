include <rotor.scad>;
include <rack.scad>;


translate([0,0,0*27]) rotate([0,0,15*360/26]) animated_assembly(0, 23);
translate([0,0,2*27]) rotate([0,0,360/26/2]) animated_assembly(0, 11);
translate([0,0,1*27]) rotate([0,0,360/26/2]) animated_assembly(0,  1);

translate([65-48.5-33.25,-63.5+9.5,0])
{
	translate([0,0,0*27]) rotate([0,0,+47]) driver(0);
	translate([0,0,1*27]) rotate([0,0,+40]) driver(1);
	translate([0,0,2*27]) rotate([0,0,+42]) driver(1);
}


translate([70,70,0])
{
	translate([0,0,0*27]) centering_device();
	translate([0,0,1*27]) centering_device();
	translate([0,0,2*27]) centering_device();
}
