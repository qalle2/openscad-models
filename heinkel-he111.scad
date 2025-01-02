/*
Heinkel He 111 from behind;
scale: 1 unit = 9.2 mm (actual wingspan = 22.6 metres)
Source:
https://commons.wikimedia.org/wiki/File:Heinkel_He_111_H-1_3-view_line_drawing.svg
Y=0 at middle of wings; Z=0 at centerline of thickest fuselage;
Polyhedra conventions:
    - sort vertices first by Z, then by Y, then by X
    - within a face, start from the smallest vertex index
    - sort faces first by first vertex etc.
    - X=0 between X_min and X_max; same for Y, Z
    - center of mass close to origin
*/

/*
Sections of fuselage from front to rear:
    1, 2: nose cone
    3: from leading to trailing edge of wings
    4: frustum, from trailing edge of wings to leading edge of horiz. stabil.
    5: tail
*/
FUA  = 4/5;  // width/height ratio (must be uniform)
FUL1 = 120;
FUH1 =  80;
FUL2 = 120;
FUH2 = 200;
FUL3 = 520;
FUH3 = 240;
FBW3 = FUA*FUH3/(1+sqrt(2));  // flat bottom width
FUL4 = 660;
FUH4 = 120;
FUL5 = 300;
FUH5 =   0;

// wings
WIA  = 26/5;  // width/height ratio (must be uniform)
WIL1 = 240;   // from root to centerline of engine
WIW1 = FUL3;
WIL2 = 940;   // from centerline of engine to tip
WIW2 = 250;   // from leading to trailing edge at tip

// stabilisers
STA   = 2/15;  // width/thickness ratio
HSTL  =  860;  // horizontal - from tip to tip
HSTW1 = FUL5;  // horizontal - from leading to trailing edge at root
HSTW2 =  150;  // horizontal - from leading to trailing edge at tip
VSTL  =  300;  // vertical - from centerline of fuselage to tip
VSTW1 = FUL5;  // vertical - from leading to trailing edge at root
VSTW2 =  150;  // vertical - from leading to trailing edge at tip

// engines
ENR  =  70;  // radius
ENL  = 400;  // length
PRR  = 180;  // propeller radius
PHL  =  50;  // propeller hub length

THIN = 20;  // minimum thickness of anything

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

// fuselage
color(FUC) {
    // front
    translate([0, (FUL1+FUL3)/2+FUL2, 0]) {
        octafrustum(FUA*FUH2, FUL1, FUH2, FUH1/FUH2, 0, 0);
    }
    // mid-front
    translate([0, (FUL2+FUL3)/2, 0]) {
        octafrustum(FUA*FUH3, FUL2, FUH3, FUH2/FUH3, 0, 0);
    }
    // mid
    octafrustum(FUA*FUH3, FUL3, FUH3, 1, 0, 0);
    // mid-rear
    translate([0, -(FUL3+FUL4)/2, 0]) {
        rotate(180) octafrustum(FUA*FUH3, FUL4, FUH3, FUH4/FUH3, 0, 0);
    }
    // rear
    translate([0, -(FUL3+FUL5)/2-FUL4, 0]) {
        rotate(180) octafrustum(FUA*FUH4, FUL5, FUH4, 0, 0, 0);
    }
}

// wings
color(PLC) translate([0, 0, (WIW1/WIA-FUH3)/2]) for(x = [-1, 1]) {
    // inner
    translate([x*(FBW3+WIL1)/2, 0, 0]) {
        rotate(-x*90) octafrustum(WIW1, WIL1, WIW1/WIA, 1, 0, 0);
    }
    // outer
    translate([x*((FBW3+WIL2)/2+WIL1), 0, 0]) {
        rotate(-x*90) octafrustum(WIW1, WIL2, WIW1/WIA, WIW2/WIW1, x*60, 120);
    }
}

// stabilisers
color(PLC) translate([0, -(FUL3+FUL5)/2-FUL4, 0]) {
    // horizontal
    for(x = [-1, 1])  {
        translate([x*HSTL/4, 0, 0]) rotate(-x*90) {
            octafrustum(FUL5, HSTL/2, STA*FUL5, HSTW2/FUL5, x*40, 0);
        }
    }
    // vertical
    translate([0, 0, VSTL/2]) rotate([90, 0, -90]) {
        octafrustum(FUL5, VSTL, STA*FUL5, VSTW2/FUL5, 20, 0);
    }
}

// engines
color(OTC) for(x = [-1, 1]) {
    translate([x*(FBW3/2+WIL1), FUL3/2, (WIW1/WIA-FUH3)/2]) engine();
}

module engine() {
    // front half
    translate([0, ENL/4, 0]) {
        octafrustum(ENR*2, ENL/2, ENR*2, 1, 0, 0);
    }
    // rear half
    translate([0, -ENL/4, 0]) {
        rotate(180) octafrustum(ENR*2, ENL/2, ENR*2, WIW1/(WIA*ENR*2), 0, 0);
    }
    // propeller hub
    translate([0, ENL/2+PHL/2, 0]) octafrustum(ENR, PHL, ENR, .5, 0, 0);
    // propeller blades
    for(i = [0, 1, 2]) rotate([0, 30+i*120, 0]) {
        translate([PRR/2, ENL/2+THIN, 0]) {
            rotate(-90) octafrustum(THIN, PRR, THIN*2, .5, 0, 0);
        }
    }
}

module octafrustum(rw, l, rh, fs, fxo, fyo) {
    // an octagonal frustum; base towards viewer;
    // front and rear faces are vertical octagons;
    // the other faces are eight trapezoids;
    // args:
    //     rw/rh   = rear width/height
    //     l       = length
    //     fs      = front/rear scale factor
    //     fxo/fyo = front X/Y offset from centerline
    // note: can't have different X/Z ratio for rear/front face
    // because the side faces would no longer be planes
    rx1 = rw/(2+2*sqrt(2));
    fx1 = fs*rw/(2+2*sqrt(2));
    rz1 = rh/(2+2*sqrt(2));
    fz1 = fs*rh/(2+2*sqrt(2));
    rx2 = rw/2;
    fx2 = fs*rw/2;
    rz2 = rh/2;
    fz2 = fs*rh/2;
    y   =  l/2;
    polyhedron(
        [
            // rear
            [-rx2, -y, -rz1],
            [-rx2, -y,  rz1],
            [-rx1, -y,  rz2],
            [ rx1, -y,  rz2],
            [ rx2, -y,  rz1],
            [ rx2, -y, -rz1],
            [ rx1, -y, -rz2],
            [-rx1, -y, -rz2],
            // front
            [fxo-fx2, y, fyo-fz1],
            [fxo-fx2, y, fyo+fz1],
            [fxo-fx1, y, fyo+fz2],
            [fxo+fx1, y, fyo+fz2],
            [fxo+fx2, y, fyo+fz1],
            [fxo+fx2, y, fyo-fz1],
            [fxo+fx1, y, fyo-fz2],
            [fxo-fx1, y, fyo-fz2],
        ],
        [
            [ 0,  1,  2,  3,  4,  5, 6, 7],  // rear
            [15, 14, 13, 12, 11, 10, 9, 8],  // front
            [ 0,  8,  9,  1],
            [ 1,  9, 10,  2],
            [ 2, 10, 11,  3],
            [ 3, 11, 12,  4],
            [ 4, 12, 13,  5],
            [ 5, 13, 14,  6],
            [ 6, 14, 15,  7],
            [ 7, 15,  8,  0],
        ]
    );
}