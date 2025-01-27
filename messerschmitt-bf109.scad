// Messerschmitt BF 109G

use <common.scad>

/*
fuselage; sections:
    1: front     (oct. frustum)
    2: mid-front (oct. prism; same Y positions as wings)
    3: mid-rear  (oct. frustum)
    4: rear      (rect. cupola)
*/
FUL1 = 154; FUW1 =  67; FUH1 =  72;
FUL2 = 220; FUW2 =  78; FUH2 = 114;
FUL3 = 324; FUW3 =  33; FUH3 =  70;
FUL4 = 100; FUW4 =  10; FUH4 =  40;
FUVS3 = 15;  // vertical slant
FBW2 = FUW2/(1+1*sqrt(2));  // flat bottom/top width
FBW3 = FUW3/(1+1*sqrt(2));  // flat bottom/top width

// cockpit (COL5 = FUL3)
COL2 = 20;
COL3 = 70;
COL4 = 30;
COL1 = FUL2-COL2-COL3-COL4;
COH  = 20;
COW1 = FBW2;    // top
COW2 = COW1/2;  // bottom

// wings
WIL1 = 460;
WIL2 =  60;
WIW1 = FUL2;
WIW2 = 120;
WIW3 =  45;
WIT  =  31;
WIHS =  25;  // horizontal slant
WIVS =  53;  // vertical   slant

// horizontal stabilisers
HSTL1 = 137;
HSTL2 =  12;
HSTW1 = 105;
HSTW2 =  72;
HSTW3 =  56;
HSTT  =  10;
HSTX  = -28;  // horizontal position
HSTZ  =  41;  // vertical   position
HSTHS =  -8;  // horizontal slant

// vertical stabiliser
VSTL1 =  95;  // rear
VSTL2 =  65;  // front
VSTW  = 100;
VSTT  =  10;
VSTVS = -50;  // vertical slant

// rudder
RUL  = 50;
RUH1 = FUH4+VSTL1;
RUH2 = RUH1-(VSTL1-VSTL2)*2;

// propeller
PHL =  53;     // hub   length
PHR = FUW1/2;  // hub   radius
PBL = 148;     // blade length
PBW =  25;     // blade width
PBT =  10;     // blade thickness

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

module bf109() {
    color(FUC) fuselage(
        FUL1, FUL2, FUL3, FUL4, FUW1, FUW2, FUW3, FUW4,
        FUH1, FUH2, FUH3, FUH4, FUVS3
    );
    // wings
    color(PLC) for(i = [-1, 1]) translate([i*(WIL1+WIL2+FBW2)/2, (-FUL1+FUL3+FUL4)/2, -(FUH2-WIT)/2]) {
        rotate(-i*90) aircraft_stabiliser(WIL1, WIL2, WIW1, WIW2, WIW3, WIT, -i*WIHS, WIVS);
    }
    // horizontal stabilisers
    color(PLC) for(i = [-1, 1]) translate([i*(HSTL1+HSTL2)/2, (-FUL1-FUL2-FUL3-FUL4+HSTW1)/2+HSTX, FUVS3+HSTZ]) {
        rotate(-i*90) aircraft_stabiliser(HSTL1, HSTL2, HSTW1, HSTW2, HSTW3, HSTT, -i*HSTHS, 0);
    }
    // vertical stabiliser
    color(PLC) translate([0, (-FUL1-FUL2-FUL3-FUL4+VSTW)/2, (FUH4+VSTL1)/2+FUVS3]) {
        vertical_stabiliser(VSTT, VSTW, VSTL1, VSTL2);
    }
    // rudder
    color(PLC) translate([0, (-FUL1-FUL2-FUL3-FUL4-RUL)/2, (RUH1-FUH4)/2+FUVS3]) {
        rotate(180) rudder(FUW4, RUL, RUH1, RUH2);
    }
    // cockpit
    color(FUC) translate([0, (-FUL1+FUL2+FUL3+FUL4-COL1-COL2)/2, FUH2/2+COH/4]) {
        cockpit_front_nonglazed(COL1, COL2, COW1, COW2, COH);
    }
    color(FUC) translate([0, (-FUL1-FUL2+FUL4+COL4)/2, (FUH2+COH)/2]) {
        rvs = -COH/2-(FUH2-FUH3)/2+FUVS3;  // rear vertical slant
        cockpit_rear_nonglazed(COL4, FUL3, COW1, COW2, FBW3, COH, rvs);
    }
    color(OTC) translate([0, (-FUL1-FUL2+FUL3+FUL4+COL2+COL3+COL4)/2, (FUH2+COH)/2]) {
        cockpit_glazed(COL2, COL3, COL4, COW1, COW2, COH);
    }
    // propeller
    color(OTC) translate([0, (FUL1+FUL2+FUL3+FUL4+PHL)/2, 0]) aircraft_propeller(PHL, PHR, PBL, PBW, PBT, 3);
}

bf109();

module fuselage(l1, l2, l3, l4, w1, w2, w3, w4, h1, h2, h3, h4, vs3) {
    /*
    args:
        l1...l4: length (front to rear)
        w1...w4: width  (front to rear)
        h1...h4: height (front to rear)
        vs3:     vertical slant of mid-rear section
    */
    // front
    translate([0, (l2+l3+l4)/2, 0]) scale([w2, l1, h2]) {
        oct_frustum2(w1/w2, h1/h2);
    }
    // mid-front
    translate([0, (-l1+l3+l4)/2, 0]) scale([w2, l2, h2]) oct_prism();
    // mid-rear
    translate([0, (-l1-l2+l4)/2, 0]) scale([w2, l3, h2]) rotate(180) oct_frustum2(w3/w2, h3/h2, 0, vs3/h2);
    // rear
    translate([0, (-l1-l2-l3)/2, vs3]) scale([w3, l4, h3]) rotate(180) rect_cupola(w4/w3, h4/h3);
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

module cockpit_front_nonglazed(l1, l2, w1, w2, h) {
    /*
    args:
        l1, l2 = length (front to rear)
        w1, w2 = width  (bottom, top)
        h      = height
    */
    // front (from front edge of mid-front fuselage)
    translate([0, l2/2, 0]) {
        scale([w1, l1, h/2]) trapez_wedge(w2/w1, 1, 0, -1/2);
    }
    // mid-front (just front of glazed cockpit)
    translate([0, -l1/2, 0]) {
        scale([w1, l2, h/2]) rotate(180) trapez_wedge(w2/w1, 1, 0, -1/2);
    }
}

module cockpit_rear_nonglazed(l1, l2, w1, w2, w3, h, rvs) {
    /*
    args:
        l1, l2  = length (front, rear)
        w1...w3 = width  (front bottom, front top, rear)
        h       = height (front)
        rvs     = rear vertical slant
    */
    // mid-rear (just rear of glazed cockpit)
    translate([0, l2/2, 0]) scale([w1, l1, h]) {
        trapez_wedge(w2/w1, 1, 0, -1/2);
    }
    // rear
    translate([0, -l1/2, 0]) scale([w1, l2, h]) {
        rotate(180) trapez_wedge(w2/w1, w3/w1, 0, rvs/h);
    }
}

module cockpit_glazed(l1, l2, l3, w1, w2, h) {
    /*
    args:
        l1, l2, l3 = length (front to rear)
        w1, w2     = width  (bottom, top)
        h          = height
    */
    // front
    translate([0, (l2+l3)/2, 0]) {
        scale([w1, l1, h]) trapez_wedge(w2/w1, w2/w1);
    }
    // mid
    translate([0, (-l1+l3)/2, 0]) {
        scale([w1, l2, h]) trapez_prism(w2/w1);
    }
    // rear
    translate([0, (-l1-l2)/2, 0]) {
        scale([w1, l3, h]) rotate(180) trapez_wedge(w2/w1, w2/w1, 0, 1/2);
    }
}
