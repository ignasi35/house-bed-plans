// canya.scad
$fn = 200; // smoother resolution


preparePrint = true; // set to false to hide the print bed
showCanyes = false; // set to false to hide the canya instances


wallThickness = 30; // 3 mm thickness of the walls of the canya

// dimensions (top-level so both module and base can use them)
height1 = 156; // 15.6 mm
height2 = 16; // 1.6 mm
height3 = 200; // 20 mm
height4 = 95; // 9.5 mm
height5 = 50; // 5 mm
bottomDiameter1 = 130;
topDiameter1 = 132;
topDiameter3 = 63;
bottomDiameter3 = 93;
diameter4 = 107;
plateX = 160;
plateY = 1;
plateZ = 200;

// Example: three copies side-by-side, rotated 45° clockwise, different colors
// define instance parameters (reuse defaults above)
pieceMaxDiameter = 132;
spacing = 30;

totalCanyaHeight = height1 + height2 + height3 + height4 + height5 + plateZ;

internalTotalBoxHeight = totalCanyaHeight + 3*spacing;

// Reusable module: canya()
module canya() {
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


// base under the three instances: 2 mm high, centered, extended to hold all three
baseMargin = spacing; // extra space around the pieces

baseHeight = wallThickness;
baseWidth = 3*pieceMaxDiameter + 2*spacing + 2*baseMargin + 2*wallThickness;
baseDepth = pieceMaxDiameter + 2*baseMargin + 2*wallThickness;

bottomHalfHeight = internalTotalBoxHeight*5/9 + wallThickness ; // for positioning the canya instances
topHalfHeight = internalTotalBoxHeight*4/9 + wallThickness ; // for positioning the canya instances

module bottom() {
    // create two cubes (height 100): large same as base footprint, small 3mm smaller in width and depth
    // subtract small from large to produce a hollow shell, positioned on top of the base (z=0)
    color([0.8,0.8,0.8])
    translate([-baseWidth/2, -baseDepth/2]) {
        difference() {
            // large cube
            linear_extrude(height = bottomHalfHeight) 
                offset(r = wallThickness/2)
                    square([baseWidth, baseDepth], center = false);
            // smaller cube centered inside (offset by 1.5 mm to center the 3 mm reduction)
            translate(
                    [wallThickness/2, 
                    wallThickness/2, 
                    baseHeight]
                    )
                cube([
                    baseWidth - wallThickness, 
                    baseDepth - wallThickness, 
                    bottomHalfHeight], center = false);
        }
    }

}


module bottomRim() {
    cWidth = baseWidth;
    cHeight = baseDepth;
    color([0.8,0.8,0])
    // the bottom piece of the box has a bit of an internal rim to 
    // holfd the top piece in place.  This is a simple 3D rectangle that is subtracted from the top piece.
    translate([
        -(cWidth)/2, 
        -(cHeight)/2, 
        bottomHalfHeight-1
        ]) {
        difference() {
            linear_extrude(height = wallThickness*2) 
                offset(delta = wallThickness*5/7, chamfer = true)
                offset(delta = -wallThickness*5/7, chamfer = true)
                    square([cWidth, cHeight], center = false);
            // smaller cube centered inside (offset by 1.5 mm to center the 3 mm reduction)
            translate(
                    [wallThickness/2, 
                    wallThickness/2, 
                    -1]
                    )
                cube([
                    baseWidth - wallThickness, 
                    baseDepth - wallThickness, 
                    wallThickness*2+2], center = false);

        }
    }
}

module topRim() {
    cWidth = baseWidth + wallThickness*1/4;
    cHeight = baseDepth + wallThickness*1/4;
    color([0.8,0.2,0.5, 0.2])
    // the bottom piece of the box has a bit of an internal rim to 
    // hold the top piece in place.  This is a simple 3D rectangle that is subtracted from the top piece.
    translate([
        -(cWidth)/2, 
        -(cHeight)/2, 
        bottomHalfHeight-2]) {
            cube([
                cWidth, 
                cHeight, 
                wallThickness*2+3], 
                center = false);
        }
    
}


module top() {
    // create two cubes (height 100): large same as base footprint, small 3mm smaller in width and depth
    // subtract small from large to produce a hollow shell, positioned on top of the base (z=0)
    color([0.8,0.2,0.5, 0.4])
    translate([-baseWidth/2, -baseDepth/2, bottomHalfHeight]) {
        difference() {
            // large cube
            linear_extrude(height = topHalfHeight) 
                offset(r = wallThickness/2)
                    square([baseWidth, baseDepth], center = false);
            // smaller cube centered inside (offset by 1.5 mm to center the 3 mm reduction)
            translate(
                    [wallThickness/2, 
                    wallThickness/2, 
                    -wallThickness]
                    )
                cube([
                    baseWidth - wallThickness, 
                    baseDepth - wallThickness, 
                    topHalfHeight], center = false);
        }
    }

}

// bottom base
bottom();
bottomRim();

if(preparePrint) {
    // top base
    translate([0, 0, 100]) {
        difference() {
            top();
            topRim();
        }
    }
}else {
    difference() {
        top();
        topRim();
    }
}


if(showCanyes && !preparePrint) {
    // left
    translate([-spacing - pieceMaxDiameter, 0, baseHeight]) rotate([0,0,-45]) color("#cc3333")
        canya();

    // center
    translate([0, 0, baseHeight]) rotate([0,0,-45]) color("#33cc33")
        canya();

    // right
    translate([spacing + pieceMaxDiameter, 0, baseHeight]) rotate([0,0,-45]) color("#3333cc")
        canya();

}