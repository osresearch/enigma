/*
 * An assembled machine for display, not printing
 */
include <rotor.scad>
include <rack.scad>
include <keyboard.scad>
include <lamp.scad>

if (1) {
scale(0.5)
{
baseplate();

translate(compensator_pos)
rotate([5,0,0])
compensator_assembly();

translate(bearingblock_pos)
translate([0,(55.5-48.5)/2 - 4/2,22 - 9.5])
rotate([90,0,90])
bearing_assembly();

keyboard_assembly();
lamp_assembly();

}
}

