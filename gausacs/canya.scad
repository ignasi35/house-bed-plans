// canya.scad
$fn = 200; // smoother resolution

// Reusable module: canya()
module canya(
   
) {
    height1 = 156;
    height2 = 16;
    height3 = 200;
    height4 = 95;
    height5 = 50;
    bottomDiameter1 = 130;
    topDiameter1 = 132;
    topDiameter3 = 63;
    bottomDiameter3 = 93;
    diameter4 = 107;
    plateX = 160;
    plateY = 1;
    plateZ = 200;
    union() {
        // section 1
        cylinder(h = height1, r1 = bottomDiameter1/2, r2 = topDiameter1/2, center = false);

        // section 2
        translate([0, 0, height1])
            cylinder(h = height2, r = topDiameter1/2, center = false);

        // section 3
        translate([0, 0, height1 + height2])
            cylinder(h = height3, r1 = bottomDiameter3/2, r2 = topDiameter3/2, center = false);

        // section 4
        translate([0, 0, height1 + height2 + height3])
            cylinder(h = height4, r = diameter4/2, center = false);

        // section 5: hull connector using thin 3D solids
        zbase = height1 + height2 + height3 + height4;
        translate([0,0,zbase]) {
            hull() {
                // thin cylinder at base
                translate([0,0,0]) cylinder(h = 0.5, r = diameter4/2, center = false, $fn = 64);
                // thin centered rectangle at top of connector
                translate([-plateX/2, -plateY/2, height5]) cube([plateX, plateY, 0.5], center = false);
            }
        }

        // section 6: top plate
        translate([-plateX/2, -plateY/2, zbase + height5]) cube([plateX, plateY, plateZ], center = false);
    }
}

// Example: three copies side-by-side, rotated 45° clockwise, different colors
// define instance parameters (reuse defaults above)
spacing = 170;

// left
translate([-spacing, 0, 0]) rotate([0,0,-45]) color("#cc3333")
    canya();

// center
translate([0, 0, 0]) rotate([0,0,-45]) color("#33cc33")
    canya();

// right
translate([spacing, 0, 0]) rotate([0,0,-45]) color("#3333cc")
    canya();
