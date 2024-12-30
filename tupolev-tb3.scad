// Tupolev TB-3 from behind;
// 1 unit = 16 mm (actual wingspan = 41.8 metres)
// Source: https://commons.wikimedia.org/wiki/File:Tupoljev_TB-3.svg
// Y=0 at middle of wings; Z=0 at centerline of thickest fuselage;
// Polyhedra conventions:
// - sort vertices first by Z, then by Y, then by X
// - within a face, start from the smallest vertex index
// - sort faces first by first vertex etc.
// - X=0 between X_min and X_max; same for Y, Z
// - center of mass close to origin

// Sections of fuselage from front to rear:
//   1: "front":     front of frustum (e.g. gunner's seat)
//   2: "front-mid": frustum
//   3: "mid-front": from frustum to leading edge of wings (e.g. pilots' seats)
//   4: "mid":       rectangular cuboid, from leading to trailing edge of wings
//   5: "mid-rear":  from trailing edge of wings to frustum (e.g. gunners' seats)
//   6: "rear-mid":  frustum
//   7: "rear":      rectangular cuboid
FUL1 =  80;  // length - front
FUL2 = 140;  // length - front-mid
FUW2 = 100;  // width  - front-mid
FUH2 = 120;  // height - front-mid
FUL3 = 100;  // length - mid-front
FUW4 = 140;  // width  - mid
FUH4 = 160;  // height - mid
FUL5 = 100;  // length - mid-rear
FUL6 = 480;  // length - rear-mid
FUL7 = 200;  // length - rear
FUW7 =  80;  // width  - rear
FUH7 = 120;  // height - rear

// For wings and stabilisers:
//   - "length" = from fuselage to tip
//   - "width"  = from leading to trailing edge

// Sections of wing: inner, outer. Separated by centerline of inner engine.
WIW1 =  520;  // width - inner
WIW2 =  150;  // width - outer
WIL1 =  150;  // length - inner
WIL2 = 1060;  // length - outer
WIH1 =  110;  // height - inner
WIH2 =   20;  // height - outer
WTE  =   75;  // tip elevation

// stabilisers
HSTL  = 400;  // horizontal - length
VSTL  = 230;  // vertical   - length
HSTW2 = 120;  // horizontal - width outer
VSTW2 =  90;  // vertical   - width outer

// engines
ENW =  60;  // width
ENL = 180;  // length
ENH = 130;  // height
PRR = 115;  // propeller radius

// landing gear
GEH = 110;  // height (vertical beam)
GEL = 130;  // length (horizontal beam)
WHR =  45;  // wheel radius

GUL = 100;  // gun length

THIN = 20;  // minimum thickness of anything

// colors
FUC = [.8,.5,.5];  // fuselage
PLC = [.8,.8,.5];  // wings and stabilisers
OTC = [.5,.8,.8];  // other parts

// front fuselage
translate([0, FUL3 + WIW1 + FUL2 + (FUL1 - WIW1) / 2, (FUH2 - FUH4) / 2]) front_fuselage();
// front-mid fuselage
color(FUC) translate([0, FUL3 + WIW1 - WIW1 / 2, 0]) frustum(FUW4, FUW2, 0, FUL2, FUH4, FUH2, (FUH2 - FUH4) / 2);
// mid-front fuselage
translate([0, (WIW1 + FUL3) / 2, 0]) mid_front_fuselage();
// mid fuselage
color(FUC) cube([FUW4, WIW1, FUH4], center=true);
// mid-rear fuselage
translate([0, -(WIW1 + FUL5) / 2, 0]) mid_rear_fuselage();
// rear-mid fuselage
color(FUC) translate([0, -WIW1 / 2 - FUL5, 0]) rotate(180) frustum(FUW4, FUW7, 0, FUL6, FUH4, FUH7, (FUH4 - FUH7) / 2);
// rear fuselage
color(FUC) translate([0, -(WIW1 + FUL7) / 2 - FUL5 - FUL6, (FUH4 - FUH7) / 2]) cube([FUW7, FUL7, FUH7], center=true);

// wings and stabilisers
color(PLC) {
    // inner wings (from fuselage to middle of inner engines)
    translate([-FUW4 / 2 - WIL1, -WIW1 / 2, -FUH4 / 2]) cube([WIL1, WIW1, WIH1]);  // left
    translate([        FUW4 / 2, -WIW1 / 2, -FUH4 / 2]) cube([WIL1, WIW1, WIH1]);  // right
    // outer wings (from middle of inner engines to wingtips)
    translate([-FUW4 / 2 - WIL1,  0, (WIH1 - FUH4) / 2]) rotate( 90) frustum(WIW1, WIW2, 0, WIL2, WIH1, WIH2, WTE);  // left
    translate([ FUW4 / 2 + WIL1,  0, (WIH1 - FUH4) / 2]) rotate(-90) frustum(WIW1, WIW2, 0, WIL2, WIH1, WIH2, WTE);  // right
    // horizontal stabilisers
    translate([0, -(WIW1 + FUL7) / 2 - FUL5 - FUL6, (FUH4 - THIN) / 2]) {
        for(zr = [-90, 90]) rotate(zr) {
            translate([0, FUW7 / 2, 0]) frustum(FUL7, HSTW2, 0, HSTL, THIN, THIN, 0);
        }
    }
    // vertical stabiliser
    translate([0, -WIW1 / 2 - FUL5 - FUL6 - FUL7 / 2, FUH4 / 2]) rotate([90, 0, 90]) frustum(FUL7, VSTW2, 0, VSTL, THIN, THIN, 0);
}

// small parts
color(OTC) {
    // engines (x = left/right, o = inner/outer)
    for(x = [-1, 1], o = [0, 1]) {
        translate([x * (FUW4 / 2 + WIL1 + o * 280), WIW1 / 2 - o * 30, (WIH1 - FUH4) / 2 + o * 20]) engine();
    }
    // landing gear
    for(zr = [0, 180]) rotate(zr) translate([FUW4 / 2 + WIL1, 0, -FUH4 / 2]) {
        translate([0, 0,        -GEH / 2]) cube([THIN, THIN,  GEH], center=true);  // vertical beam
        translate([0, 0, -GEH - THIN / 2]) cube([THIN,  GEL, THIN], center=true);  // horizontal beam
        // wheels
        for(y = [-1, 1]) {
            translate([THIN, y * GEL / 2, -GEH - THIN / 2]) rotate([0, 90, 0]) cylinder(r=WHR, h=THIN, $fn=8, center=true);
        }
    }
}

module front_fuselage() {
    // 6 polyhedra
    color(FUC) scale([FUW2 / 3, FUL1 / 2, FUH2]) {
        // center
        translate([0, -.5, -.125])                     cube([1, 1, .75], center=true);  // rear
        translate([0,  .5,     0]) rotate([0, 180, 0]) halfcube();                      // front
        // left/right (Y rotation is 180, 90)
        for(x = [-1, 1]) translate([x, 0, 0]) {
            translate([0, -.5, 0]) rotate([0, 135 - x * 45, 0]) fivesixthscube();  // rear
            translate([0,  .5, 0]) rotate([0, 135 - x * 45, 0]) sixthcube();       // front
        }
    }
    // gun
    color(OTC) translate([0, GUL / 2, (FUH2 + THIN) / 2]) cube([THIN, GUL, THIN], center=true);
}

module mid_front_fuselage() {
    // rear half is seat; seat width is 2/3 of total width
    color(FUC) scale([FUW4, FUL3, FUH4]) {
        translate([  0,  1 / 4,      0]) cube([    1, 1 / 2,     1], center=true);  // front
        translate([  0, -1 / 4, -1 / 8]) cube([2 / 3, 1 / 2, 3 / 4], center=true);  // rear center
        // rear left/right
        for(x = [-1, 1]) {
            translate([x * 5 / 12, -1 / 4, 0]) cube([1 / 6, 1 / 2, 1], center=true);
        }
    }
    // windshield
    color(OTC) translate([0, THIN / 2, (FUH4 + THIN) / 2]) scale([FUW4 * 2 / 3, THIN, THIN]) halfcube();
}

module mid_rear_fuselage() {
    // gunners' seats; 6 cuboids; all have the same Z_min;
    // from above ("S" = seat, "." = full-height):
    //   . . . S S .
    //   . . . S S .
    //   . . . . . .
    //   . S S . . .
    //   . S S . . .
    for(x = [-1, 1]) {
        color(FUC) scale([FUW4, FUL5, FUH4]) {
            // seats (front right / rear left)
            translate([x / 6, x * 3 / 10, -1 / 8]) cube([1 / 3, 2 / 5, 3 / 4], center=true);
            // large full-height cuboids (front left / rear right)
            translate([x / 4,  -x / 5, 0]) cube([1 / 2, 3 / 5, 1], center=true);
            // small full-height cuboids (front right / rear left)
            translate([x * 5 / 12, x * 3 / 10, 0]) cube([1 / 6, 2 / 5, 1], center=true);
        }
        // guns
        color(OTC) for(x = [-1, 1]) {
            translate([x * (FUW4 / 3 + GUL / 2), x * FUL5 * 3 / 10, (FUH4 + THIN) / 2]) cube([GUL, THIN, THIN], center=true);
        }
    }
}

module engine() {
    translate([0, -ENL / 4, 0]) cube([ENW, ENL / 2, ENH], center=true);  // rear
    frustum(ENW, ENW, 0, ENL / 2, ENH, ENH / 2, ENH / 4);                // front
    translate([0, (ENL + THIN) / 2, 0]) rotate([0, 30, 0]) cube([PRR * 2, THIN, THIN], center=true);  // propeller
}

module frustum(rw, fw, fx, le, rh, fh, fz) {
    // a rectangular pyramid cut by a plane parallel to the base; base towards viewer;
    // four of the edges are vertical; four of the faces are vertical;
    // rw/rh = rear width/height; fw/fh = front width/height; le = length
    // fx, fz = front X/Z offset from centerline
    translate([-rw / 2, 0, -rh / 2]) polyhedron(
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
        [[0,1,3,2], [0,2,6,4], [0,4,5,1], [1,5,7,3], [2,3,7,6], [4,6,7,5]]
    );
}

module sixthcube() {
    // a unit cube but 5/6 sliced away from top front right along 3 vertices
    translate([-.5, -.5, -.5]) polyhedron(
        [[0,0,0], [1,0,0], [0,1,0], [0,0,1]],
        [[0,1,2], [0,2,3], [0,3,1], [1,3,2]]
    );
}

module halfcube() {
    // a unit cube but 1/2 sliced away from top front along 4 vertices
    translate([-.5, -.5, -.5]) polyhedron(
        [[0,0,0], [1,0,0], [0,1,0], [1,1,0], [0,0,1], [1,0,1]],
        [[0,1,3,2], [0,2,4], [0,4,5,1], [1,5,3], [2,3,5,4]]
    );
}

module fivesixthscube() {
    // a unit cube but 1/6 sliced away from top front right along 3 vertices
    translate([-.5, -.5, -.5]) polyhedron(
        [[0,0,0], [1,0,0], [0,1,0], [1,1,0], [0,0,1], [1,0,1], [0,1,1]],
        [[0,1,3,2], [0,2,6,4], [0,4,5,1], [1,5,3], [2,3,6], [3,5,6], [4,6,5]]
    );
}