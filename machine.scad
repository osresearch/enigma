/*
 * An assembled machine for display, not printing
 */
include <rotor.scad>
include <rack.scad>
include <keyboard.scad>
include <lamp.scad>

if (1) {
baseplate();

translate(compensator_pos)
rotate([5,0,0])
compensator_assembly();

translate(bearingblock_pos)
translate([4,(55.5-48.5)/2 - 4/2,22 - 9.5])
rotate([90,0,90])
bearing_assembly();

keyboard_assembly();
lamp_assembly();

} else scale(0.5) {
/*
	translate([0,0,6]) compensator();
	translate([180,-40,0]) access_roll_housing();
	translate([20,20,0]) bearing_block_left();
	translate([150,20,0]) bearing_block_right();
	translate([40, -50,0]) shaft_holder();
*/
//%rotate([0,0,-60]) reflector_cabinet();
reflector_wedge_holder();
}
