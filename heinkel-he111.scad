/*
Heinkel He 111 from behind;
scale: 1 unit = 9.2 mm (actual wingspan = 22.6 metres)
*/

use <common.scad>

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

/*
wings
    "1" = inner, "2" = middle, "3" = outer
    "length" = from root to tip
    "width"  = from leading to trailing edge
*/
WIL1  = 240; WIW1 = FUL3; WIT1 = WIW1/5;
WIL2  = 940; WIW2 = 250;
WIL3  = 100; WIW3 = 100;
WIHS  = 100;   // horizontal slant of middle & outer wings
WIVS  = 100;   // vertical   slant of middle & outer wings

/*
stabilisers
    L = length = from root to tip
    W = width  = from leading to trailing edge
*/
// horizontal & vertical
STW1 = FUL5;  // width at root
STT  = 40;    // thickness at root
// horizontal
HSTL1 = 280;
HSTL2 = 140;
HSTW2 = 250;
HSTW3 = 120;
HSTHS = 0.03*STW1;  // horizontal slant
// vertical
VSTL1 = 200;
VSTL2 = 100;
VSTW2 = 200;
VSTW3 = 100;
VSTHS = 0.10*STW1;  // horizontal slant

// engines
ENR =  70;  // radius
ENL = 360;  // length

// propellers
PHL =  50;  // hub   length
PBL = 180;  // blade length
PBW =  30;  // blade width  (at root)

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

module he111() {
    /* Heinkel He 111 */
    color(FUC) fuselage(FUL1, FUL2, FUL3, FUL4, FUL5, FUH1, FUH2, FUH3, FUH4, FUH5, FUA);
    // wings
    color(PLC) for(x = [-1, 1]) {
        translate([x*(WIL1+WIL2+WIL3+FBW3)/2, (-FUL1-FUL2+FUL4+FUL5)/2, (WIT1-FUH3)/2]) {
            rotate(-x*90) wing(WIL1, WIL2, WIL3, WIW1, WIW2, WIW3, WIT1, x*WIHS, WIVS);
        }
    }
    // stabilisers
    color(PLC) translate([0, (-FUL1-FUL2-FUL3-FUL4)/2, 0]) {
        // horizontal
        for(x = [-1, 1]) translate([x*(HSTL1+HSTL2)/2, 0, 0]) rotate(-x*90) {
            stabiliser(HSTL1, HSTL2, STW1, HSTW2, HSTW3, STT, x*HSTHS);
        }
        // vertical
        translate([0, 0, (VSTL1+VSTL2)/2]) rotate([90, 0, -90]) {
            stabiliser(VSTL1, VSTL2, STW1, VSTW2, VSTW3, STT, VSTHS);
        }
    }
    // engines and propellers
    color(OTC) for(x = [-1, 1]) {
        translate([x*(FBW3/2+WIL1), (-FUL1-FUL2+FUL3+FUL4+FUL5)/2, (WIT1-FUH3)/2]) {
            engine(ENL, ENR, WIT1/2);
            translate([0, (ENL+PHL)/2, 0]) propeller(ENR, PHL, PBL, PBW);
        }
    }
}

he111();

module fuselage(l1, l2, l3, l4, l5, h1, h2, h3, h4, h5, whr) {
    /*
    args:
        l1...l5: length (front to rear)
        h1...h5: height (front to rear)
        whr:     width/height ratio
    */
    // front
    translate([0, (l2+l3+l4+l5)/2, 0]) {
        scale([whr*h2, l1, h2]) oct_frustum(h1/h2);
    }
    // mid-front
    translate([0, (-l1+l3+l4+l5)/2, 0]) {
        scale([whr*h3, l2, h3]) oct_frustum(h2/h3);
    }
    // mid
    translate([0, (-l1-l2+l4+l5)/2, 0]) {
        scale([whr*h3, l3, h3]) oct_frustum(1);
    }
    // mid-rear
    translate([0, (-l1-l2-l3+l5)/2, 0]) {
        rotate(180) scale([whr*h3, l4, h3]) oct_frustum(h4/h3);
    }
    // rear
    translate([0, (-l1-l2-l3-l4)/2, 0]) {
        rotate(180) scale([whr*h4, l5, h4]) oct_frustum(h5/h4);
    }
}

module wing(l1, l2, l3, w1, w2, w3, t1, hs, vs) {
    /*
    root towards viewer;
    args:
        l1...l3 = length    (inner to outer)
        w1...w3 = width     (inner to outer)
        t1      = thickness (inner)
        hs, vs  = slant of middle and outer wing (horizontal, vertical)
    */
    l2r = l2/(l2+l3);
    l3r = l3/(l2+l3);
    // inner (straight)
    translate([0, (-l2-l3)/2, 0])
        scale([w1, l1, t1])
            hex_frustum(1);
    // middle
    translate([0, (l1-l3)/2, 0])
        scale([w1, l2, t1])
            hex_to_rect(w2/w1, l3r, l2r*hs/w1, l2r*vs/t1);
    // outer
    translate([l2r*hs, (l1+l2)/2, l2r*vs])
        scale([w2, l3, l3r*t1])
            rect_wedge(w3/w2, l3r*hs/w2, vs/t1);
}

module stabiliser(l1, l2, w1, w2, w3, t1, hs) {
    /*
    root towards viewer;
    args:
        l1, l2     = length    (inner, outer)
        w1, w2, w3 = width     (inner, middle, outer)
        t1         = thickness (inner)
        hs         = horizontal slant
    */
    l1r = l1/(l1+l2);
    l2r = l2/(l1+l2);
    // inner
    translate([0, -l2/2, 0]) {
        scale([w1, l1, t1]) hex_to_rect(w2/w1, l2r, hs/w1*l1r, 0);
    }
    // outer
    translate([hs*l1r, l1/2, 0]) {
        scale([w2, l2, t1*l2r]) rect_wedge(w3/w2, hs/w1*l2r, 0);
    }
}

module engine(le, r1, r2) {
    /*
    args:
        le     = length
        r1, r2 = radius (front, rear)
    */
    // heights of hexagonal frustums to make them regular
    h1 = r1*sqrt(3);
    h2 = r2*sqrt(3);
    // front half
    translate([0, le/4, 0]) {
        scale([r1*2, le/2, h1]) hex_frustum(1);
    }
    // rear half
    translate([0, -le/4, 0]) rotate(180) {
        scale([r1*2, le/2, h1]) hex_frustum(r2/(h1/2));
    }
}

module propeller(hr, hl, bl, bw) {
    /*
    args:
        hr, hl = hub   radius, length
        bl, bw = blade length, width
    */
    // propeller hub (base is regular hexagon)
    scale([hr, hl, hr*sqrt(3)/2]) hex_frustum(1/2);
    // propeller blades
    for(i = [0:2]) rotate([0, 30+i*120, 0]) {
        translate([bl/2, 0, 0]) rotate([0, 45, -90]) {
            scale([bw, bl, bw/2]) hex_wedge(1/2);
        }
    }
}
