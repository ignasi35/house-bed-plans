preparePrint = true;  // set to false to hide the print bed

$fn = 40;

showBottom = true;  // set to false to hide the bottom piece
showTop = true;  // set to false to hide the top piece

// this is the tolerance for the rim of the box
// keep this 1/10 of the wallThickness or at least 6
// 6 is 3x the nozzle size of my printer. the thing is want
// the rims to wiggle and will let the protrusions do the work
toleranceRim = 6;

wallThickness = 38;
protrusionDepth = wallThickness / 2 - toleranceRim;

internalWidth = 280;
internalDepth = 600;
internalHeight = 780;

internalTotalBoxHeight = internalHeight;
externalWidth = internalWidth + 2 * wallThickness;
externalDepth = internalDepth + 2 * wallThickness;
externalHeight = internalHeight + 2 * wallThickness;
circleDiameter = wallThickness * 2.1;
distanceBetweenCentersY = internalDepth - circleDiameter;
distanceBetweenCentersX = internalWidth - circleDiameter;

bottomHalfHeight = internalTotalBoxHeight * 7 / 19 + wallThickness;
topHalfHeight = internalTotalBoxHeight * 12 / 19 + wallThickness;

rimHeight = 110;

totalBottomHeight = bottomHalfHeight + rimHeight;

module shape(
    circleDiameter,
    dbcX,
    dbcY,
    height = bottomHalfHeight
) {
    linear_extrude(height = height)
        hull() {
            translate([-dbcX / 2, -dbcY / 2])
                circle(d = circleDiameter);
            translate([dbcX / 2, -dbcY / 2])
                circle(d = circleDiameter);
            translate([-dbcX / 2, dbcY / 2])
                circle(d = circleDiameter);
            translate([dbcX / 2, dbcY / 2])
                circle(d = circleDiameter);
        };
}

module bottom() {
    difference() {
        //largeShape
        shape(circleDiameter, distanceBetweenCentersX, distanceBetweenCentersY, bottomHalfHeight);
        translate([0, 0, wallThickness])// smallShape
            shape(circleDiameter - wallThickness * 2, distanceBetweenCentersX, distanceBetweenCentersY, bottomHalfHeight);
    }
}
module top() {
    difference() {
        //largeShape
        shape(circleDiameter, distanceBetweenCentersX, distanceBetweenCentersY, topHalfHeight);
        translate([0, 0, wallThickness])// smallShape
            shape(circleDiameter - wallThickness * 2, distanceBetweenCentersX, distanceBetweenCentersY, topHalfHeight);
    }
}

module protrusion(protrusionDepthX, protrusionDepthY) {
    resize(newsize = [protrusionDepthX, protrusionDepthY, 30])
        sphere(r = 100);
}
module protrusions(tolerance, protrusionDepth) {
    x1 = (circleDiameter + distanceBetweenCentersX - wallThickness + tolerance) / 2;
    y1 = 1 / 6 * internalDepth;
    z1 = rimHeight / 2;

    translate([x1, y1, z1]) protrusion(protrusionDepth, 30);
    translate([x1, -y1, z1]) protrusion(protrusionDepth, 30);
    translate([-x1, y1, z1]) protrusion(protrusionDepth, 30);
    translate([-x1, -y1, z1]) protrusion(protrusionDepth, 30);

    x2 = 1 / 6 * internalWidth;
    y2 = (circleDiameter + distanceBetweenCentersY - wallThickness + tolerance) / 2;
    z2 = z1;

    translate([x2, y2, z2]) protrusion(30, protrusionDepth);
    translate([x2, -y2, z2]) protrusion(30, protrusionDepth);
    translate([-x2, y2, z2]) protrusion(30, protrusionDepth);
    translate([-x2, -y2, z2]) protrusion(30, protrusionDepth);
}

module rim(tolerance, protrusionDepth) {
    protrusions(tolerance, protrusionDepth);
    module largeShape() {
        shape(
            circleDiameter - wallThickness + tolerance,
            distanceBetweenCentersX,
            distanceBetweenCentersY,
            rimHeight
        );
    }

    module smallShape() {
        shape(
            circleDiameter - wallThickness * 2,
            distanceBetweenCentersX,
            distanceBetweenCentersY,
            rimHeight
        );
    }
    difference() {
        largeShape();
        smallShape();
    }
}
module bottomRim() {
    rim(-toleranceRim / 2, protrusionDepth + 1);
}
module topRim() {
    rim(toleranceRim / 2, protrusionDepth - 1);
}

module completeTop() {
    difference() {
        top();
        translate([0, 0, topHalfHeight + 1 - rimHeight]) {
            topRim();
        }
    }
}

module bottomBeforeHinge() {
    bottom();
    translate([0, 0, bottomHalfHeight - 1]) {
        bottomRim();
    }
}

module bottomHalf() {
    translate([0, 0, -totalBottomHeight / 2]) {
        difference() {
            bottomBeforeHinge();
            translate([internalWidth / 2, 0, 0])
                cube([internalWidth, internalDepth, internalHeight + 100], center = true);
        }
    }
}
module bottomLeft() {
    translate([0, -totalBottomHeight / 2 - 2, 0]) {
        rotate([90, 0, 0])
            rotate([0, 0, 90])
                bottomHalf();
    }
}

module bottomRight() {
    translate([0, totalBottomHeight / 2 + 2, 0]) {
        rotate([-90, 0, 0])
            rotate([0, 0, -90])
                bottomHalf();
    }
}
module unhingedBottom() {
    bottomLeft();
    bottomRight();
}

hingeOuterRadius = wallThickness * 4 / 5;
hingeInnerRadius = wallThickness * 2 / 5;
hingeLength = internalDepth * 3 / 4;
pieceCount = 7;
pieceLength = hingeLength / pieceCount;
pinLength = pieceLength * 1 / 3;

module hingePiece(isCubeLeft = 0, hasPin = true) {
    hingePieceLength = pieceLength - 2;
    difference() {
        cylinder(h = hingePieceLength, r = hingeOuterRadius);
    }
    translate([0, 0, hingePieceLength - 1]) {
        if (hasPin) {
            cylinder(h = pinLength - 1, r = hingeInnerRadius - 3);
        }
    }
    // isCubeLeft si not a boolean. It's an integer with values 0 or 1. So, "isCubeLeft*2"
    // is 0 or 2, and "(1+isCubeLeft*2)" is 1 or -1.
    yTranslate = (-1 + isCubeLeft * 2) * (wallThickness / 2 + 2);
    translate([wallThickness / 2, yTranslate, hingePieceLength / 2]) {
        cube([wallThickness, wallThickness - 2, hingePieceLength], center = true);
    }
}
module hinge() {
    for (pieceIndex = [0 : pieceCount - 1]) {
        hasHole = pieceIndex != 0;
        translate([0, 0, pieceLength * pieceIndex]) {
            difference() {
                hingePiece(1 - pieceIndex % 2, pieceIndex < pieceCount - 1);
                if (hasHole) {
                    translate([0, 0, -1]) {
                        cylinder(h = pinLength + 1, r = hingeInnerRadius + 1);
                    }
                }
            }
        }
    }
}

module hingeGap() {
    cylinder(h = hingeLength + 2, r = hingeOuterRadius + 4);
}

heightOfFirstSection = 190;
tudellLargeR = 100;  // actual value - unused
tudellSmallR = 82;  //actual value - unused
tudellMaxDiameter = 124;  // build value - see actual values and best guess
tudellMinDiameter = 106;  // build value - see actual values and best guess
clampInternalMaxRadius = tudellMaxDiameter / 2;
clampInternalMinRadius = tudellMinDiameter / 2;

clampLength = 100;

module singleClamp(isPositive, h1, h2) {
    minkoskliBallR = 6;
    internalMaxR = clampInternalMaxRadius - minkoskliBallR;
    externalMaxR = internalMaxR + wallThickness * 2 / 7;
    internalMinR = clampInternalMinRadius - minkoskliBallR;
    externalMinR = internalMinR + wallThickness * 2 / 7;

    margin = wallThickness;
    module positiveClamp() {
        translate([0, 0, h2]) {
            cube([wallThickness, clampLength, h1], center = true);
        }
        translate([wallThickness * 10 / 7, 0, h2]) {
            cube([wallThickness / 5, clampLength, h1], center = true);
        }
        translate([-wallThickness * 10 / 7, 0, h2]) {
            cube([wallThickness / 5, clampLength, h1], center = true);
        }
        translate([0, 0, h1]) {
            rotate([90, 0, 0]) {
                cylinder(h = clampLength, r2 = externalMaxR, r1 = externalMinR, center = true);
            }
        }
    }

    module negativeClamp() {
        translate([0, 0, h2 + wallThickness]) {
            cube([wallThickness / 2, clampLength, h1 + margin], center = true);
        }
        translate([0, 0, h1]) {
            rotate([90, 0, 90 - 90 * isPositive]) {
                cylinder(h = clampLength, r2 = internalMaxR, r1 = internalMinR, center = true);
            }
        }
        // replace full outer cylinder with an arc (sector) linearly extruded
        // parameters: arc angle (degrees) and resolution
        translate([0, 0, h1]) {
            rotate([90, 0, 0]) {
                translate([-externalMaxR, 26 * isPositive - 8, -clampLength]) {
                    cube([clampLength * 3, clampLength * 3, clampLength * 3]);
                }
            }
        }
    }

    minkowski() {
        difference() {
            positiveClamp();
            negativeClamp();
        }

        sphere(r = 6);
    }
}
module allClampsBottomHinge() {
    xDist = 2 / 6 * (internalDepth - 2 * wallThickness);
    yDist = heightOfFirstSection + clampLength / 2 + wallThickness;
    height = (internalWidth) / 2;
    h2 = height / 2 + wallThickness;

    // one side
    translate([0, yDist, 0])
        singleClamp(isPositive = 1, height, h2);
    translate([xDist, yDist, 0])
        singleClamp(isPositive = 1, height, h2);
    translate([-xDist, yDist, 0])
        singleClamp(isPositive = 1, height, h2);

    // other side
    translate([0, -yDist, 0])
        singleClamp(isPositive = -1, height, h2);
    translate([xDist, -yDist, 0])
        singleClamp(isPositive = -1, height, h2);
    translate([-xDist, -yDist, 0])
        singleClamp(isPositive = -1, height, h2);
}

module completeBottom() {
    translate([0, 0, (externalWidth - 2 * wallThickness) / 2]) {
        difference() {
            unhingedBottom();
            translate([-hingeLength / 2 - 1, 0, 0]) {
                rotate([0, 90, 0]) {
                    hingeGap();
                }
            }
        }
        translate([-hingeLength / 2, 0, 0]) {
            rotate([0, 90, 0]) {
                hinge();
            }
        }
    }
    translate([0, 0, 1]) {
        allClampsBottomHinge();
    }
}

module allClampsHolder() {
    xDist = 2 / 6 * (internalDepth - 2 * wallThickness);
    yDist = -internalHeight / 2 + heightOfFirstSection + clampLength / 2;
    h1 = (internalWidth) / 2;
    h2 = wallThickness * 2;

    // one side
    translate([0, yDist, 0])
        singleClamp(isPositive = 1, h1, h2);
    translate([xDist, yDist, 0])
        singleClamp(isPositive = 1, h1, h2);
    translate([-xDist, yDist, 0])
        singleClamp(isPositive = 1, h1, h2);
}
module canyaHolderExternal() {
    difference() {
        cube([internalWidth * 2 / 3, internalDepth, internalHeight], center = true);
        translate([wallThickness * 1 / 3, 0, 0]) {
            cube([internalWidth * 2 / 3, internalDepth - wallThickness * 2 / 3, internalHeight + 10], center = true);
        }
        translate([internalWidth * 2 / 7, 0, 0]) {
            hull() {
                translate([0, 0, internalHeight * 2 / 9])
                    rotate([90, 0, 0]) {
                        cylinder(r = 100, h = internalDepth + wallThickness, $fn = 100, center = true);
                    };
                translate([0, 0, -internalHeight * 2 / 9])
                    rotate([90, 0, 0]) {
                        cylinder(r = 100, h = internalDepth + wallThickness, $fn = 100, center = true);
                    };
            }
        }
    }
}

module canyaHolder() {
    translate([0, 0, internalWidth / 3])
        rotate([0, -90, 90]) {
            canyaHolderExternal();
        };
    translate([0, 0, 1]) {
        allClampsHolder();
    }
}

color("red") {
    canyaHolder();
}

if (showBottom) {
    translate([800, 1000, 0]) {
        bottomBeforeHinge();
    }
    translate([800, -internalHeight / 2, 0]) {
        completeBottom();
    }
}
if (showTop) {
    translate([0, 1000, 0]) {
        completeTop();
    }
}
