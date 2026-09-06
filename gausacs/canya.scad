preparePrint = true;  // set to false to hide the print bed

if (preparePrint) {
    $fn = 50;
    // smoother resolution
} else {
    $fn = 20;
    // lower resolution for faster rendering
}

showCanyes = true;  // set to false to hide the canya instances
showBottom = true;  // set to false to hide the bottom piece
showTop = true;  // set to false to hide the top piece
showHolder = true;

wallThickness = 30;  // 3 mm thickness of the walls of the canya

// this is the tolerance for the rim of the box
// keep this 1/10 of the wallThickness or at least 6
// 6 is 3x the nozzle size of my printer. the thing is want
// the rims to wiggle and will let the protrusions do the work
tolerance = 6;

// this is the tolerance for the hole where the canya sits
// keep this least 4 (?)
// This is radius tolerance (not diameter!)
toleranceRadiusOnCanyaHole = 2;

// dimensions (top-level so both module and base can use them)
height1 = 156;  // 15.6 mm
height2 = 16;  // 1.6 mm
height3 = 200;  // 20 mm
height4 = 95;  // 9.5 mm
height5 = 50;  // 5 mm
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
spacing = 60;

totalCanyaHeight = height1 + height2 + height3 + height4 + height5 + plateZ;

internalTotalBoxHeight = totalCanyaHeight + 1 * spacing;

// base under the three instances: 2 mm high, centered, extended to hold all three
baseMargin = spacing;  // extra space around the pieces

baseHeight = wallThickness;
baseWidth = 3 * pieceMaxDiameter + spacing + 2 * baseMargin + 2 * wallThickness;
baseDepth = pieceMaxDiameter + 2 * baseMargin + 2 * wallThickness + 0 * spacing;

bottomHalfHeight = internalTotalBoxHeight * 12 / 19 + wallThickness;  // for positioning the canya instances
topHalfHeight = internalTotalBoxHeight * 7 / 19 + wallThickness;  // for positioning the canya instances

rimHeight = wallThickness * 4;

// Reusable module: canya()
module canya() {
    union() {
        // section 1
        cylinder(h = height1, r1 = bottomDiameter1 / 2, r2 = topDiameter1 / 2, center = false);

        // section 2
        translate([0, 0, height1])
            cylinder(h = height2, r = topDiameter1 / 2, center = false);

        // section 3
        translate([0, 0, height1 + height2])
            cylinder(h = height3, r1 = bottomDiameter3 / 2, r2 = topDiameter3 / 2, center = false);

        // section 4
        translate([0, 0, height1 + height2 + height3])
            cylinder(h = height4, r = diameter4 / 2, center = false);

        // section 5: hull connector using thin 3D solids
        zbase = height1 + height2 + height3 + height4;
        translate([0, 0, zbase]) {
            hull() {
                // thin cylinder at base
                translate([0, 0, 0]) cylinder(h = 0.5, r = diameter4 / 2, center = false, $fn = 64);
                // thin centered rectangle at top of connector
                translate([-plateX / 2, -plateY / 2, height5]) cube([plateX, plateY, 0.5], center = false);
            }
        }

        // section 6: top plate
        translate([-plateX / 2, -plateY / 2, zbase + height5]) cube([plateX, plateY, plateZ], center = false);
    }
}

module holes() {
    cWidth = baseWidth;
    cHeight = baseDepth;
    translate([-(cWidth) * 2 / 7, 0, -100]) {
        cylinder(h = 10000, r = wallThickness, center = false);
    }
    translate([0, 0, -100]) {
        cylinder(h = 10000, r = wallThickness, center = false);
    }
    translate([(cWidth) * 2 / 7, 0, -100]) {
        cylinder(h = 10000, r = wallThickness, center = false);
    }
}

module bottom() {
    // create two cubes (height 100): large same as base footprint, small 3mm smaller in width and depth
    // subtract small from large to produce a hollow shell, positioned on top of the base (z=0)
    color([0.8, 0.8, 0.8])
        translate([-baseWidth / 2, -baseDepth / 2]) {
            difference() {
                // large cube
                linear_extrude(height = bottomHalfHeight)
                    offset(r = wallThickness / 2)
                        square([baseWidth, baseDepth], center = false);
                // smaller cube centered inside (offset by 1.5 mm to center the 3 mm reduction)
                translate(
                    [
                        wallThickness / 2,
                        wallThickness / 2,
                        baseHeight
                    ]
                )
                    cube(
                        [
                            baseWidth - wallThickness,
                            baseDepth - wallThickness,
                            bottomHalfHeight
                        ],
                        center = false
                    );
            }
        };
}

module bottomRim() {
    cWidth = baseWidth;
    cHeight = baseDepth;
    protrusionDepth = 15;
    // 1.2 mm depth of the protrusions
    color([0.8, 0.8, 0])// The bottom rim has 6 rounded protrusions (spheres) to make it easier to click into place.
        translate([-(cWidth) / 5, -(cHeight) / 2, bottomHalfHeight + rimHeight / 2]) {
            resize(newsize = [30, protrusionDepth, 30]) sphere(r = 1000);
        };
    translate([-(cWidth) / 5, (cHeight) / 2, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [30, protrusionDepth, 30]) sphere(r = 1000);
    }
    translate([(cWidth) / 5, -(cHeight) / 2, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [30, protrusionDepth, 30]) sphere(r = 1000);
    }
    translate([(cWidth) / 5, (cHeight) / 2, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [30, protrusionDepth, 30]) sphere(r = 1000);
    }
    translate([(cWidth) / 2, 0, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [protrusionDepth, 30, 30]) sphere(r = 1000);
    }
    translate([-(cWidth) / 2, 0, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [protrusionDepth, 30, 30]) sphere(r = 1000);
    }
    // the bottom piece of the box has a bit of an internal rim to
    // holfd the top piece in place.  This is a simple 3D rectangle that is subtracted from the top piece.
    translate(
        [
            -(cWidth) / 2,
            -(cHeight) / 2,
            bottomHalfHeight - 1
        ]
    ) {
        difference() {
            linear_extrude(height = rimHeight)
                offset(delta = wallThickness * 5 / 7, chamfer = true)
                    offset(delta = -wallThickness * 5 / 7, chamfer = true)
                        square([cWidth, cHeight], center = false);
            // smaller cube centered inside (offset by 1.5 mm to center the 3 mm reduction)
            translate(
                [
                    wallThickness / 2,
                    wallThickness / 2,
                    -1
                ]
            )
                cube(
                    [
                        baseWidth - wallThickness,
                        baseDepth - wallThickness,
                        rimHeight + 2
                    ],
                    center = false
                );
        }
    }
}

module topRim() {
    cWidth = baseWidth + tolerance;
    cHeight = baseDepth + tolerance;
    protrusionDepth = 13;
    color([0.8, 0.2, 0.5, 0.8])// The top rim has 6 rounded holes (spheres) to make it easier to click into place.
        translate([-(cWidth) / 5, -(cHeight) / 2, bottomHalfHeight + rimHeight / 2]) {
            resize(newsize = [30, protrusionDepth, 30]) sphere(r = 1000);
        };
    translate([-(cWidth) / 5, (cHeight) / 2, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [30, protrusionDepth, 30]) sphere(r = 1000);
    }
    translate([(cWidth) / 5, -(cHeight) / 2, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [30, protrusionDepth, 30]) sphere(r = 1000);
    }
    translate([(cWidth) / 5, (cHeight) / 2, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [30, protrusionDepth, 30]) sphere(r = 1000);
    }
    translate([(cWidth) / 2, 0, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [protrusionDepth, 30, 30]) sphere(r = 1000);
    }
    translate([-(cWidth) / 2, 0, bottomHalfHeight + rimHeight / 2]) {
        resize(newsize = [protrusionDepth, 30, 30]) sphere(r = 1000);
    }

    // the bottom piece of the box has a bit of an internal rim to
    // hold the top piece in place.  This is a simple 3D rectangle that is subtracted from the top piece.
    translate(
        [
            -(cWidth) / 2,
            -(cHeight) / 2,
            bottomHalfHeight - 1
        ]
    ) {
        cube(
            [
                cWidth,
                cHeight,
                rimHeight + 3
            ],
            center = false
        );
    }
}

module top() {
    // create two cubes (height 100): large same as base footprint, small 3mm smaller in width and depth
    // subtract small from large to produce a hollow shell, positioned on top of the base (z=0)
    color([0.8, 0.2, 0.5, 0.8])
        translate([-baseWidth / 2, -baseDepth / 2, bottomHalfHeight]) {
            difference() {
                // large cube
                linear_extrude(height = topHalfHeight)
                    offset(r = wallThickness / 2)
                        square([baseWidth, baseDepth], center = false);
                // smaller cube centered inside (offset by 1.5 mm to center the 3 mm reduction)
                translate(
                    [
                        wallThickness / 2,
                        wallThickness / 2,
                        -wallThickness
                    ]
                )
                    cube(
                        [
                            baseWidth - wallThickness,
                            baseDepth - wallThickness,
                            topHalfHeight
                        ],
                        center = false
                    );
            }
        };
}

// create a holder for the canya instances. It is a thin floating wall with 3 holes.
// The holder is 4*wallThickness from the bottom so the canya instances can be placed into it.
// the holder also has pillars to keep it separate from the bottom}
holderWidth = baseWidth - 2 * wallThickness - 5;
holderHeight = baseDepth - 2 * wallThickness - 5;
module holder() {
    cWidth = holderWidth;
    cHeight = holderHeight;
    color([0.8, 0.6, 0.2])
        translate([-cWidth / 2, -cHeight / 2, wallThickness * 5]) {
            // large cube
            linear_extrude(height = wallThickness)
                offset(r = wallThickness / 2)
                    square([cWidth, cHeight], center = false);
        };
    translate([topDiameter1 / 2 + wallThickness, topDiameter1 / 2 + wallThickness, 3 * wallThickness]) {
        cylinder(h = wallThickness * 4.5, r = wallThickness * 2 / 3, center = true);
    }
    translate([-topDiameter1 / 2 - wallThickness, topDiameter1 / 2 + wallThickness, 3 * wallThickness]) {
        cylinder(h = wallThickness * 4.5, r = wallThickness * 2 / 3, center = true);
    }
    translate([topDiameter1 / 2 + wallThickness, -topDiameter1 / 2 - wallThickness, 3 * wallThickness]) {
        cylinder(h = wallThickness * 4.5, r = wallThickness * 2 / 3, center = true);
    }
    translate([-topDiameter1 / 2 - wallThickness, -topDiameter1 / 2 - wallThickness, 3 * wallThickness]) {
        cylinder(h = wallThickness * 4.5, r = wallThickness * 2 / 3, center = true);
    }
}
module holderSingleHole() {
    cube([wallThickness, wallThickness, 10000], center = true);
}

// this is the main hole where the canya sites. It must
// have some wiggle room
holderHoleRadius = toleranceRadiusOnCanyaHole + topDiameter1 / 2;

module holderHoles3() {
    cWidth = holderWidth + 1;
    cHeight = holderHeight + 1;
    squareHoles(cWidth, cHeight, 2, 2);
    roundHoles(3, 1);
}

module holderHoles2() {
    cWidth = holderWidth + 1;
    cHeight = holderHeight + 1;

    squareHoles(cWidth, cHeight, 3, 2);

    roundHoles(2, 1);
}

// The Drying Rack is not inside the box so it can be an arbitrary size
dryingRackWidth = baseWidth * 5 / 4;
dryingRackHeight = baseDepth * 3 / 2;

module dryingRack() {
    cWidth = dryingRackWidth;
    cHeight = dryingRackHeight;

    cornerWidth = cWidth / 2 - wallThickness * 2;
    cornerHeight = cHeight / 2 - wallThickness * 2;

    cylinderHeight = wallThickness * 7;

    color([0.8, 0.6, 0.2])
        translate([-cWidth / 2, -cHeight / 2, cylinderHeight - wallThickness * 0.8]) {
            // large cube
            linear_extrude(height = wallThickness)
                offset(r = wallThickness / 2)
                    square([cWidth, cHeight], center = false);
        };

    translate([cornerWidth, cornerHeight, 3 * wallThickness]) {
        cylinder(h = cylinderHeight, r = wallThickness * 2 / 3, center = true);
    }
    translate([-cornerWidth, cornerHeight, 3 * wallThickness]) {
        cylinder(h = cylinderHeight, r = wallThickness * 2 / 3, center = true);
    }
    translate([cornerWidth, -cornerHeight, 3 * wallThickness]) {
        cylinder(h = cylinderHeight, r = wallThickness * 2 / 3, center = true);
    }
    translate([-cornerWidth, -cornerHeight, 3 * wallThickness]) {
        cylinder(h = cylinderHeight, r = wallThickness * 2 / 3, center = true);
    }
}

module squareHoles(cWidth, cHeight, holesOverLength = undef, holesOverWidth = undef) {
    // Automatic counts keep the holes roughly wallThickness * 4 apart.
    lengthCount = is_undef(holesOverLength)
        ? max(2, floor(cWidth / (wallThickness * 4)))
        : holesOverLength;
    widthCount = is_undef(holesOverWidth)
        ? max(2, floor(cHeight / (wallThickness * 4)))
        : holesOverWidth;

    // Holes along the two sides whose length is cWidth.
    for (index = [1 : lengthCount]) {
        x = cWidth * (index - 0.5) / lengthCount - cWidth / 2;
        translate([x, cHeight / 2, 0])
            holderSingleHole();
        translate([x, -cHeight / 2, 0])
            holderSingleHole();
    }

    // Holes along the two sides whose length is cHeight.
    for (index = [1 : widthCount]) {
        y = cHeight * (index - 0.5) / widthCount - cHeight / 2;
        translate([cWidth / 2, y, 0])
            holderSingleHole();
        translate([-cWidth / 2, y, 0])
            holderSingleHole();
    }
}

module roundHoles(holesOverLength, holesOverWidth) {
    holeSpacing = spacing + pieceMaxDiameter;

    for (lengthIndex = [0 : holesOverLength - 1]) {
        x = (lengthIndex - (holesOverLength - 1) / 2) * holeSpacing;
        for (widthIndex = [0 : holesOverWidth - 1]) {
            y = (widthIndex - (holesOverWidth - 1) / 2) * holeSpacing;
            translate([x, y, 0])
                cylinder(h = 10000, r = holderHoleRadius, center = false);
        }
    }
}

module dryingRackHoles() {
    cWidth = dryingRackWidth;
    cHeight = dryingRackHeight;
    squareHoles(cWidth, cHeight);
    roundHoles(4, 2);
}

// bottom base
if (showBottom) {
    difference() {
        bottom();
        holes();
    }
    bottomRim();
}

if (showHolder) {
    if (preparePrint) {
        // top base
        translate([200 + baseWidth, 200 + baseDepth, 0]) {
            difference() {
                holder();
                holderHoles3();
            }
        }
        translate([200 + baseWidth, -200 + baseDepth, 0]) {
            difference() {
                holder();
                holderHoles2();
            }
        }
        translate([1000 + baseWidth, -200 + baseDepth, 0]) {
            difference() {
                dryingRack();
                dryingRackHoles();
            }
        }
    } else {
        difference() {
            holder();
            holderHoles();
        }
    }
}

if (showTop) {
    difference() {
        if (preparePrint) {
            // top base
            translate([0, 0, rimHeight + 100]) {
                difference() {
                    top();
                    topRim();
                }
            }
        } else {
            difference() {
                top();
                topRim();
            }
        }
        holes();
    }
}

if (showCanyes && !preparePrint) {
    // left
    translate([-spacing - pieceMaxDiameter, 0, baseHeight]) rotate([0, 0, -90]) color("#cc3333")
        canya();

    // center
    translate([0, 0, baseHeight]) rotate([0, 0, -90]) color("#33cc33")
        canya();

    // right
    translate([spacing + pieceMaxDiameter, 0, baseHeight]) rotate([0, 0, -90]) color("#3333cc")
        canya();
}
