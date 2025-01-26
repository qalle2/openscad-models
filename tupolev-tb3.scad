/*
Tupolev TB-3 from behind;
1 unit = 16 mm (actual wingspan = 41.8 metres);
Y=0 at middle of wings; Z=0 at centerline of thickest fuselage
*/

use <common.scad>

/*
Sections of fuselage from front to rear:
    1: "front":     front of frustum
    2: "front-mid": frustum
    3: "mid-front": from frustum to leading  edge of wings
    4: "mid":       from leading to trailing edge of wings
    5: "mid-rear":  from trailing edge of wings to frustum
    6: "rear-mid":  frustum
    7: "rear":      rectangular cuboid
*/
FUL1 =  80;  // length - front
FUL2 = 140;  // length - front-mid
FUW2 = 100;  // width  - front-mid
FUH2 = 120;  // height - front-mid
FUL3 = 100;  // length - mid-front
FUL4 = 520;
FUW4 = 140;  // width  - mid
FUH4 = 160;  // height - mid
FUL5 = 100;  // length - mid-rear
FUL6 = 480;  // length - rear-mid
FUL7 = 200;  // length - rear
FUW7 =  80;  // width  - rear
FUH7 = 120;  // height - rear

/*
For wings and stabilisers:
    L = length = from fuselage to tip
    W = width  = from leading to trailing edge
    T = thickness
*/

// wings (inner to outer sections)
WIL1 =  150; WIW1 = FUL4; WIT1 = 100;
WIL2 = 1030; WIW2 =  150;
WIL3 =   30; WIW3 =   90;

// horizontal & vertical stabilisers
STW1 = FUL7;
STT1 =   20;

// horizontal stabilisers
HSTL  = 400;
HSTW2 = 120;
HSTHS =  20;  // horizontal slant

// vertical stabiliser
VSTL  = 230;
VSTW2 =  90;
VSTVS =  40;  // vertical slant

// engine size
ENW =  60;  // width
ENL = 180;  // length
ENH = 130;  // height

// outer engine location relative to inner
ENOX = 280;
ENOY = (ENOX/WIL2)*(WIW2-WIW1)/2;
ENOZ = (ENOX/(WIL2+WIL3))*WIT1/2;

// propeller
PHR  =  20;  // hub   radius
PHL  =  30;  // hub   length
PBL  = 115;  // blade length
PBW  =  20;  // blade width
PBT  =  10;  // blade thickness

// landing gear
GEL = 220;  // total length
GEH = 165;  // total height
GET =  20;  // thickness (beams & wheels)
WHR =  45;  // wheel radius

// guns
GUL = 100;  // length
GUT =  15;  // thickness

WSS = 20;   // windshield length & height

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

module tb3() {
    color(FUC) fuselage(
        FUL1, FUL2, FUL3, FUL4, FUL5, FUL6, FUL7,
        FUW2, FUW4, FUW7,
        FUH2, FUH4, FUH7
    );
    // wings
    color(PLC) for(x = [-1, 1]) translate([
        x*(FUW4+WIL1+WIL2+WIL3)/2,
        (-FUL1-FUL2-FUL3+FUL5+FUL6+FUL7)/2,
        (WIT1-FUH4)/2
    ]) rotate(-x*90) {
        aircraft_wing(WIL1, WIL2, WIL3, WIW1, WIW2, WIW3, WIT1, 0, WIT1/2);
    }
    // stabilisers (TODO: rudder and elevators)
    color(PLC) translate(
        [0, (-FUL1-FUL2-FUL3-FUL4-FUL5-FUL6)/2, (FUH4-FUH7)/2]
    ) {
        // horizontal
        for(x = [-1, 1]) translate([x*(FUW7+HSTL)/2, 0, (FUH7-STT1)/2]) {
            scale([HSTL, STW1, STT1]) rotate([0, 0, -x*90]) {
                hex_wedge(HSTW2/FUL7, x*HSTHS/FUL7, 0);
            }
        }
        // vertical
        translate([0, 0, (FUH7+VSTL)/2]) {
            scale([STT1, STW1, VSTL]) rotate([90, 0, -90]) {
                hex_wedge(VSTW2/FUL7, VSTVS/FUL7, 0);
            }
        }
    }
    // engines and propellers (x = left/right, o = inner/outer)
    color(OTC) for(x = [-1, 1], o = [0, 1]) {
        translate([
            x*(FUW4/2+WIL1+o*ENOX),
            WIW1/2        +o*ENOY + (-FUL1-FUL2-FUL3+FUL5+FUL6+FUL7)/2,
            (WIT1-FUH4)/2 +o*ENOZ
        ]) {
            engine();
            translate([0, (ENL+PHL)/2, PHR]) {
                aircraft_propeller(PHL, PHR, PBL, PBW, PBT, 2);
            }
        }
    }
    // landing gear
    color(OTC) for(x = [-1, 1]) translate([
        x*((FUW4+WIL1+GET)/2),
        (-FUL1-FUL2-FUL3+FUL5+FUL6+FUL7)/2,
        (-FUH4-GEH)/2
    ]) rotate(-x*90) landing_gear(GEL, GEH, WIL1+GET, GET, WHR);
    // windshield
    color(OTC) translate(
        [0, (-FUL1-FUL2+FUL4+FUL5+FUL6+FUL7+WSS)/2, (FUH4+WSS)/2]
    ) scale([FUW4*2/3, WSS, WSS]) rect_wedge(1, 0, -1/2);
    // front gun
    color(OTC) translate(
        [0, (FUL2+FUL3+FUL4+FUL5+FUL6+FUL7+GUL)/2, FUH2+(GUT-FUH4)/2]
    ) gun();
    // mid-rear guns
    color(OTC) translate(
        [0, (-FUL1-FUL2-FUL3-FUL4+FUL6+FUL7)/2, (FUH4+GUT)/2]
    ) for(i = [-1, 1]) translate([i*(FUW4/3+GUL/2), i*3/10*FUL5, 0]) {
        rotate(90) gun();
    }
}

tb3();

module fuselage(l1, l2, l3, l4, l5, l6, l7, w2, w4, w7, h2, h4, h7) {
    /*
    args:
        l1...l7:    length (front to rear)
        w2, w4, w7: width  (front to rear)
        h2, h4, h7: height (front to rear)
    */
    // front
    translate([0, (l2+l3+l4+l5+l6+l7)/2, (h2-h4)/2]) {
        scale([w2/3, l1/2, h2]) {
            // rear/front center
            translate([0, -1/2, -1/4]) cube([1, 1, 1/2], center=true);
            translate([0, 1/2, 0]) rotate([0, 180, 0]) rect_wedge(1, 0, -.5);
            // left/right
            for(x = [-1, 1]) translate([x, 0, 0]) {
                translate([0, -1/2, 0]) {  // rear
                    rotate([0, 135-x*45, 0]) rect_to_right_tri();
                }
                translate([0, 1/2, 0]) {  // front
                    rotate([0, 135-x*45, 0]) right_tri_pyramid(-1/2, -1/2);
                }
            }
        }
    }
    // front-mid
    translate([0, (-l1+l3+l4+l5+l6+l7)/2, 0]) scale([w4, l2, h4]) {
        rect_frustum(w2/w4, h2/h4, 0, (h2/h4-1)/2);
    }
    // mid-front
    translate([0, (-l1-l2+l4+l5+l6+l7)/2, 0]) {
        // rear half is seat; seat width is 2/3 of total width
        scale([w4, l3, h4]) {
            // front
            translate([0, 1/4, 0]) cube([1, 1/2, 1], center=true);
            // rear center
            translate([0, -1/4, -1/4]) cube([2/3, 1/2, 1/2], center=true);
            // rear left/right
            for(x = [-1, 1]) {
                translate([x*5/12, -1/4, 0]) cube([1/6, 1/2, 1], center=true);
            }
        }
    }
    // mid
    translate([0, (-l1-l2-l3+l5+l6+l7)/2, 0]) {
        cube([w4, l4, h4], center=true);
    }
    // mid-rear
    translate([0, (-l1-l2-l3-l4+l6+l7)/2, 0]) {
        /*
        gunners' seats; 6 cuboids; all have the same Z_min;
        from above ("S" = seat, "." = full-height):
            . . . S S .
            . . . S S .
            . . . . . .
            . S S . . .
            . S S . . .
        */
        for(x = [-1, 1]) scale([w4, l5, h4]) {
            // seats (front right / rear left)
            translate([x/6, x*3/10, -1/4]) cube([1/3, 2/5, 1/2], center=true);
            // large full-height cuboids (front left / rear right)
            translate([x/4, -x/5, 0]) cube([1/2, 3/5, 1], center=true);
            // small full-height cuboids (front right / rear left)
            translate([x*5/12, x*3/10, 0]) cube([1/6, 2/5, 1], center=true);
        }
    }
    // rear-mid
    translate([0, (-l1-l2-l3-l4-l5+l7)/2, 0]) {
        rotate(180) scale([w4, l6, h4]) {
            rect_frustum(w7/w4, h7/h4, 0, (1-h7/h4)/2);
        }
    }
    // rear
    translate([0, (-l1-l2-l3-l4-l5-l6)/2, (h4-h7)/2]) {
        cube([w7, l7, h7], center=true);
    }
}

module engine() {
    // rear
    translate([0, -ENL/4, 0]) cube([ENW, ENL/2, ENH], center=true);
    // front
    translate([0, ENL/4, 0]) {
        scale([ENW, ENL/2, ENH]) rect_frustum(1, 1/2, 0, 1/4);
    }
}

module landing_gear(w, h, le, t, wr) {
    /* diagonal beam towards viewer;
    args:
        w  = width
        h  = height (excl. non-full-length top of diagonal beam)
        le = length
        t  = beam thickness
        wr = wheel radius
    */
    hvby = (le-t*3)/2;  // vert. & horiz. beam Y
    hbw  = w-2*wr;      // horiz.         beam width
    hbz  = -h/2+wr;     // horiz.         beam Z
    vbh  = h-wr-t/2;    // vert.          beam height
    // vertical beam
    translate([0, hvby, (h-vbh)/2]) cube([t, t, vbh], center=true);
    // horizontal beam
    translate([0, hvby, hbz]) cube([hbw, t, t], center=true);
    // diagonal beam
    translate([0, -t, (h+t)/2]) scale([t, le-2*t, t]) {
        rect_prism(0, -(vbh+t)/t);
    }
    // wheels
    for(x = [-1, 1]) translate([x*hbw/2, (le-t)/2, hbz]) {
        scale([wr*2, t, wr*2]) oct_prism();
    }
}

module gun() {
    scale([GUT, GUL, GUT]) hex_prism();
}
