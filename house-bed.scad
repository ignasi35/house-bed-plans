// factory parts

// mattress board
// main structure holding mattress board
// all-round fence
// house structure

// REMINDERS
// subtract 0.001 units to guarantee items form a single object
// rotate first, translate later
// buld pieces centered so rotation is more intuitive

$fa = 1;
$fs = 0.4;



cube([60,20,10],center=true);
translate([5,0,10 - 0.001])
    cube([30,20,10],center=true);
translate([-20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([-20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([20,-15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([20,15,0])
    rotate([90,0,0])
    cylinder(h=3,r=8,center=true);
translate([-20,0,0])
    rotate([90,0,0])
    cylinder(h=30,r=2,center=true);
translate([20,0,0])
    rotate([90,0,0])
    cylinder(h=30,r=2,center=true);
