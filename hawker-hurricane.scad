/* Hawker Hurricane;
every module is centred at [0, 0, 0] */

use <common.scad>

/*
Fuselage parts:
    1. octagonal frustum, front of wings
    2. octagonal prism, from leading to trailing edge of wings
    3. octagonal frustum, from trailing edge of wings to tail
    4. octagon to rectangle
*/
FUA   = 2/3;  // width/height ratio (must be uniform)
FUL1  = 200;
FUH1  = 120;
FUL2  = 400;
FUH2  = 250;
FUL3  = 550;
FUH3  = 100;
FUL4  = 180;
FUH4  =  80;
FUW1  = FUA*FUH1;
FUW2  = FUA*FUH2;
FUW3  = FUA*FUH3;
FUW4  =  20;
FBW2  = FUW2/(1+sqrt(2));  // width of flat bottom and top
FUVS3 = -1/10;  // vertical slant (of FUH2)

// wings (W=width=X, L=length=Y, T=thickness=Z, 1-3=inner to outer)
WIW1 = 180;
WIL1 = 380;
WIT1 =  70;
WIW2 = 620;
WIL2 = 190;
WIW3 =  80;
WIL3 =  80;
WHS  =  40;  // horizontal slant

/*
cockpit; parts:
    1. front     (windshield)
    2. mid-front (side windows)
    3. mid-rear  (unglazed)
    4. rear      (unglazed)
*/
COH  =  40;
COW1 = FBW2;            // bottom
COW2 = COW1-COH*FUA*2;  // top
COL1 =   30;
COL2 =  150;
COL3 =   60;
COL4 =  200;

// horizontal stabilisers (W=width=X, L=length=Y, T=thickness=Z)
HSTW1 =  190;
HSTL1 = FUL4;
HSTT1 =   30;
HSTW2 =   60;
HSTL2 =  120;
HSTL3 =   60;
HSTSL =   10;  // horizontal slant

// vertical stabiliser (L=length=Y, H=height=Z, T=thickness=X)
VSTH1 = 170;     // rear
VSTH2 = 125;     // front

// rudder (L=length=Y, H=height=Z, T=thickness=X)
RUL  = 80;                  // length
RUH1 = FUH4+VSTH1;          // height 1 (front)
RUH2 = FUH4-VSTH1+2*VSTH2;  // height 2 (rear)

// propeller
PHR = FUW1/2;  // hub radius
PHL =  50;     // hub length
PBL = 240;     // blade length
PBW =  30;     // blade width
PBT =  20;     // blade thickness

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

module hurricane() {
    /*
    Hawker Hurricane;
    args: none but uses global constants;
    */
    // fuselage
    color(FUC) fuselage(
        FUA, FUW4, FUL1, FUL2, FUL3, FUL4, FUH1, FUH2, FUH3, FUH4, FUVS3*FUH2,
        COW1, COW2, COL3, COL4, COH
    );
    // front half of cockpit (glazed)
    color(OTC) translate(
        [0, COL3+(-FUL1-FUL2+FUL3+FUL4+COL1+COL2)/2, (FUH2+COH)/2]
    ) cockpit_fronthalf(COW1, COW2, COL2, COL1, COH);
    // wings
    color(PLC) for(x = [-1, 1]) translate(
        [x*(WIW1+WIW2+WIW3+FBW2)/2, (-FUL1+FUL3+FUL4)/2, (WIT1-FUH2)/2]
    ) rotate(-x*90) aircraft_wing(
        WIW1, WIW2, WIW3, WIL1, WIL2, WIL3, WIT1, -x*WHS, WIT1/2
    );
    // stabilisers and rudder
    color(PLC) translate([0, (-FUL1-FUL2-FUL3)/2, FUVS3*FUH2]) {
        // horizontal stabilisers
        for(x = [-1, 1]) translate([x*(FUW4+HSTW1+HSTW2)/2, 0, 0]) {
            rotate(-x*90) aircraft_stabiliser(
                HSTW1, HSTW2, HSTL1, HSTL2, HSTL3, HSTT1, x*HSTSL, HSTT1/2
            );
        }
        // vertical stabiliser
        translate([0, 0, (FUH4+VSTH1)/2]) {
            vertical_stabiliser(FUW4, FUL4, VSTH1, VSTH2);
        }
        // rudder
        translate([0, (-FUL4-RUL)/2, (RUH1-FUH4)/2]) {
            rotate(180) rudder(FUW4, RUL, RUH1, RUH2);
        }
    }
    // propeller
    color(OTC) translate([0, (FUL1+FUL2+FUL3+FUL4+PHL)/2, 0]) {
        aircraft_propeller(PHL, PHR, PBL, PBW, PBT, 2);
    }
}

hurricane();

module fuselage(
    whr, w4, l1, l2, l3, l4, h1, h2, h3, h4, vs3, cw1, cw2, cl1, cl2, ch
) {
    /*
    shape: four sections longitudinally;
    args:
        whr      = width/height ratio (front to mid-rear)
        w4       = width              (rear only)
        l1...l4  = length             (front to rear)
        h1...h3  = height             (front to rear)
        vs3      = vertical slant     (mid-rear only)
        cw1, cw2 = cockpit width      (front bottom, front top)
        cl1, cl2 = cockpit length     (front, rear)
        ch       = cockpit height
    TODO: order of args should be rear to front
    */
    // rear (square cupola)
    translate([0, (-l1-l2-l3)/2, vs3]) rotate(180) {
        scale([h3*whr, l4, h3]) rect_cupola(FUW4/(h3*whr), h4/h3);
    }
    // mid-rear (octagonal frustum)
    translate([0, (-l1-l2+l4)/2, 0]) rotate(180) {
        scale([h2*whr, l3, h2]) oct_frustum(h3/h2, 0, vs3/h2);
    }
    // mid-front (octagonal prism)
    translate([0, (-l1+l3+l4)/2, 0]) {
        scale([h2*whr, l2, h2]) oct_prism();
    }
    // front (square frustum)
    translate([0, (l2+l3+l4)/2, 0]) {
        scale([h2*whr, l1, h2]) oct_frustum(h1/h2);
    }
    // rear half of cockpit (non-glazed)
    rw = cw1*(1-(cl2/l3)*(1-h3/h2));  // rear width
    cvs = -ch/2+((h3-h2)/2+vs3)*(cl2/l3);  // vertical slant
    // rear
    translate([0, (-l1-l2+l3+l4-cl2)/2, (ch+h2)/2]) {
        scale([cw1, cl2, ch]) rotate(180) {
            trapez_wedge(cw2/cw1, rw/cw1, 0, cvs/ch);
        }
    }
    // front
    translate([0, (-l1-l2+l3+l4+cl1)/2, (ch+h2)/2]) {
        scale([cw1, cl1, ch]) trapez_prism(cw2/cw1);
    }
}

module cockpit_fronthalf(w1, w2, l1, l2, h) {
    /*
    args:
        w1, w2 = width  (bottom, top)
        l1, l2 = length (rear, front)
        h      = height
    */
    // rear
    translate([0, -l2/2, 0]) scale([w1, l1, h]) {
        trapez_prism(w2/w1);
    }
    // front
    translate([0, l1/2]) scale([w1, l2, h]) {
        trapez_wedge(w2/w1, w2/w1, 0, -1/2);
    }
}

module vertical_stabiliser(w, le, h1, h2) {
    /*
    root towards viewer;
    args:
        w      = width
        le     = length (bottom; top = this / 3)
        h1, h2 = height (rear, front)
    */
    // bottom rear (full-width part)
    translate([0, -le/6, (-h1+h2)/2]) scale([w, le*2/3, h2]) {
        rotate([90, 0, 0]) rect_frustum(1, 1/2, 0, 1/4);
    }
    // top rear
    translate([0, -le/3, h2/2]) scale([w, le/3, h1-h2]) {
        rotate([90, 0, 90]) rect_wedge();
    }
    // bottom front
    translate([0, 0, (-h1+h2)/2]) scale([w, le/3, h2]) {
        rotate([-90, 0, 0]) tri_prism(0, 1);
    }
    // top front
    translate([0, 0, h2/2]) scale([w, le/3, h1-h2]) {
        rotate([90, 0, 180]) tri_pyramid(0, -1/2);
    }
}

module rudder(w, le, h1, h2) {
    /*
    root towards viewer;
    args:
        w      = width
        le     = length
        h1, h2 = height (larger, smaller)
    */
    // middle
    scale([w, le, h2]) rotate([0, 90, 0]) rect_wedge();
    // bottom
    translate([0, 0, (-h1-h2)/4]) scale([w, le, (h1-h2)/2]) {
        rect_pyramid(0, 1/2);
    }
    // top
    translate([0, 0, (h1+h2)/4]) scale([w, le, (h1-h2)/2]) {
        tri_pyramid(0, -1/2);
    }
}
