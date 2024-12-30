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
FUL1 = 120;
FUW1 =  80;
FUH1 =  80;
FUL2 = 120;
FUW2 = 150;
FUH2 = 200;
FUL3 = 520;
FUW3 = 190;
FUH3 = 240;
FUL4 = 660;
FUW4 = 100;
FUH4 = 120;
FUL5 = 300;
FUW5 =   0;
FUH5 =   0;

// wings
WIL1 =  190;  // from root to centerline of engine
WIW1 = FUL3;  // from leading to trailing edge at root
WIL2 =  940;  // from centerline of engine to tip
WIW2 =  250;  // from leading to trailing edge at tip
WIH1 =  100;  // height at root
WIH2 =   20;  // height at tip

// stabilisers
HSTL  =  860;  // horizontal - from tip to tip
HSTW1 = FUL5;  // horizontal - from leading to trailing edge at root
HSTW2 =  100;  // horizontal - from leading to trailing edge at tip
VSTL  =  300;  // vertical - from centerline of fuselage to tip
VSTW1 = FUL5;  // vertical - from leading to trailing edge at root
VSTW2 =  100;  // vertical - from leading to trailing edge at tip

// engines
ENR  =  70;  // radius
ENL  = 430;  // length
PRR  = 180;  // propeller radius

THIN = 20;  // minimum thickness of anything

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

// fuselage (from front to rear)
color(FUC) {
    translate([0, (FUL1+FUL3)/2+FUL2, 0]) frustum(FUW2, FUW1, 0, FUL1, FUH2, FUH1, 0);
    translate([0, (FUL2+FUL3)/2, 0]) frustum(FUW3, FUW2, 0, FUL2, FUH3, FUH2, 0);
    cube([FUW3, FUL3, FUH3], center=true);
    translate([0, -(FUL3+FUL4)/2, 0]) rotate(180) frustum(FUW3, FUW4, 0, FUL4, FUH3, FUH4, 0);
    translate([0, -(FUL3+FUL5)/2-FUL4, 0]) rotate(180) frustum(FUW4, THIN, 0, FUL5, FUH4, THIN, 0);
}

// wings
color(PLC) translate([0, 0, (WIH1-FUH3)/2]) for(x = [-1, 1]) {
    // inner
    translate([x*(FUW3+WIL1)/2, 0, 0]) {
        cube([WIL1, WIW1, WIH1], center=true);
    }
    // outer
    translate([x*((FUW3+WIL2)/2+WIL1), 0, 0]) {
        rotate(-x*90) frustum(WIW1, WIW2, x*(WIW1-WIW2-60)/2, WIL2, WIH1, WIH2, 120);
    }
}

// stabilisers
color(PLC) translate([0, -(FUL3+FUL5)/2-FUL4, 0]) {
    // horizontal
    for(x = [-1, 1])  {
        translate([x*HSTL/4, 0, 0]) {
            rotate(-x*90) frustum(FUL5, HSTW2, x*((FUL5-HSTW2)/2-70), HSTL/2, THIN, THIN, 0);
        }
    }
    // vertical
    translate([0, 0, VSTL/2]) {
        rotate([90, 0, -90]) frustum(FUL5, VSTW2, (FUL5-VSTW2)/2-70, VSTL, THIN, THIN, 0);
    }
}

// engines
color(OTC) for(x = [-1, 1]) {
    translate([x*(FUW3/2+WIL1), FUL3/2, (WIH1-FUH3)/2]) engine();
}

module engine() {
    rotate([90, 0, 0]) cylinder(r=ENR, h=ENL, $fn=6, center=true);
    // propeller blades
    for(i = [0, 1, 2]) rotate([0, -90+i*120, 0]) {
        translate([PRR/2, (ENL+THIN)/2, 0]) cube([PRR, THIN, THIN], center=true);
    }
    // propeller hub
    translate([0, ENL/2+THIN*3/2, 0]) {
        rotate([90, 0, 0]) cylinder(r=ENR/2, h=THIN, $fn=6, center=true);
    }
}

module frustum(rw, fw, fx, le, rh, fh, fz) {
    // a rectangular pyramid cut by a plane parallel to the base; base towards viewer;
    // four of the edges are vertical; four of the faces are vertical;
    // rw/rh = rear width/height; fw/fh = front width/height; le = length;
    // fx, fz = front X/Z offset from centerline;
    // note: X & Z centering is based on rear dimensions only
    translate([-rw/2, -le/2, -rh/2]) polyhedron(
        [
            [           0,  0,            0],
            [          rw,  0,            0],
            [(rw-fw)/2+fx, le, (rh-fh)/2+fz],
            [(rw+fw)/2+fx, le, (rh-fh)/2+fz],
            [           0,  0,           rh],
            [          rw,  0,           rh],
            [(rw-fw)/2+fx, le, (rh+fh)/2+fz],
            [(rw+fw)/2+fx, le, (rh+fh)/2+fz],
        ],
        [
            [0, 1, 3, 2],
            [0, 2, 6, 4],
            [0, 4, 5, 1],
            [1, 5, 7, 3],
            [2, 3, 7, 6],
            [4, 6, 7, 5],
        ]
    );
}