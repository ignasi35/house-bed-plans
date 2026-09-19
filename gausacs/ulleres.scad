preparePrint = true;  // set to false to hide the print bed

if (preparePrint) {
    $fn = 50;
    // smoother resolution
} else {
    $fn = 20;
    // lower resolution for faster rendering
}

showBottom = true;  // set to false to hide the bottom piece
showTop = true;  // set to false to hide the top piece

wallThickness = 80;

// this is the tolerance for the rim of the box
// keep this 1/10 of the wallThickness or at least 6
// 6 is 3x the nozzle size of my printer. the thing is want
// the rims to wiggle and will let the protrusions do the work
toleranceRim = 8;

internalTotalBoxHeight = 1600;
externalWidth = 400;
externalDepth = externalWidth + 300;
largeCircleDiameter = externalWidth;
distanceBetweenCenters = externalDepth - largeCircleDiameter;

bottomHalfHeight = internalTotalBoxHeight * 12 / 19 + wallThickness;
topHalfHeight = internalTotalBoxHeight * 7 / 19 + wallThickness;

rimHeight = 170;

module shape(circleDiameter, distanceBetweenCenters, height = bottomHalfHeight) {
    linear_extrude(height = height)
        hull() {
            translate([-distanceBetweenCenters / 2, 0])
                circle(d = circleDiameter);
            translate([distanceBetweenCenters / 2, 0])
                circle(d = circleDiameter);
        };
}

module bottom() {
    difference() {
        //largeShape
        shape(largeCircleDiameter, distanceBetweenCenters, bottomHalfHeight);
        translate([0, 0, wallThickness])// smallShape
            shape(largeCircleDiameter - wallThickness, distanceBetweenCenters, bottomHalfHeight);
    }
}
module top() {
    difference() {
        //largeShape
        shape(largeCircleDiameter, distanceBetweenCenters, topHalfHeight);
        translate([0, 0, -wallThickness])// smallShape
            shape(largeCircleDiameter - wallThickness, distanceBetweenCenters, topHalfHeight);
    }
}

module protrusion(protrusionDepthX, protrusionDepthY) {
    resize(newsize = [protrusionDepthX, protrusionDepthY, 30])
        sphere(r = 100);
}
module protrusions(tolerance, protrusionDepth) {
    x1 = 1 / 6 * externalDepth;
    y1 = (largeCircleDiameter - wallThickness / 2 + tolerance) / 2;
    z1 = rimHeight / 2;

    translate([x1, y1, z1]) protrusion(30, protrusionDepth);
    translate([x1, -y1, z1]) protrusion(30, protrusionDepth);
    translate([-x1, y1, z1]) protrusion(30, protrusionDepth);
    translate([-x1, -y1, z1]) protrusion(30, protrusionDepth);

    x2 = (externalDepth - wallThickness / 2 + tolerance) / 2;
    y2 = 0;
    z2 = z1;

    translate([x2, y2, z2]) protrusion(protrusionDepth, 30);
    translate([-x2, y2, z2]) protrusion(protrusionDepth, 30);
}

module rim(tolerance, protrusionDepth) {
    protrusions(tolerance, protrusionDepth);
    module largeShape() {
        shape(
            largeCircleDiameter - wallThickness / 2 + tolerance,
            distanceBetweenCenters,
            rimHeight
        );
    }

    module smallShape() {
        shape(
            largeCircleDiameter - wallThickness,
            distanceBetweenCenters,
            rimHeight
        );
    }
    difference() {
        largeShape();
        smallShape();
    }
}

module bottomRim() {
    rim(-toleranceRim / 2, 15);
}

module topRim() {
    rim(toleranceRim / 2, 13);
}

module completeBottom() {
    translate([0, -500, 0]) {
        bottom();
        translate([0, 0, bottomHalfHeight - 1]) {
            bottomRim();
        }
    }
}
// bottom base
if (showBottom) {
    completeBottom();
}

module completeTop() {
    difference() {
        top();
        topRim();
    }
}
if (showTop) {
    difference() {
        if (preparePrint) {
            // top base
            translate([0, 500, 0]) {
                completeTop();
            }
        } else {
            completeTop();
        }
    }
}
