/*
 * An assembled machine for display, not printing
 */
include <rotor.scad>
include <rack.scad>

scale(0.5)
{
baseplate();

if (1) {
translate(compensator_pos)
rotate([5,0,0])
compensator_assembly();

translate(bearingblock_pos)
translate([0,(55.5-48.5)/2 - 4/2,22 - 9.5])
rotate([90,0,90])
bearing_assembly();
}
}
