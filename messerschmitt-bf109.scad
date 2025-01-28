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
FUL2 = 220; FUW2 =  78; FUH2 =  95;
FUL3 = 324; FUW3 =  33; FUH3 =  70;
FUL4 = 100; FUW4 =  10; FUH4 =  40;
FUZ1 =   6;  // Z position
FUZ4 =  35;  // Z position
FBW2 = FUW2/(1+1*sqrt(2));  // flat bottom/top width
FBW3 = FUW3/(1+1*sqrt(2));  // flat bottom/top width
// center Y of each section
FUCY1 = (      FUL2+FUL3+FUL4)/2;
FUCY2 = (-FUL1     +FUL3+FUL4)/2;
FUCY3 = (-FUL1-FUL2     +FUL4)/2;
FUCY4 = (-FUL1-FUL2-FUL3     )/2;

/* cockpit; parts (front to rear):
    1, 2: nonglazed
    3:    glazed & nonglazed
    4:    glazed
    5:    glazed & nonglazed
    6:    nonglazed
*/
COL1 = FUL1;
COL3 = 20;
COL4 = 70;
COL5 = 30;
COL2 = FUL2-COL3-COL4-COL5;
COL6 = FUL3;
COW1 = FBW2;            // bottom (excl. front & rear)
COW2 = FBW2/2;          // top (excl. front & rear)
COW3 = FBW2*FUW1/FUW2;  // front
COW4 = FBW3;            // rear
COH1 = 40;              // glazed cockpit
COH2 = 20;              // just front of glazed cockpit
COH3 = 14;              // between front and front-mid fuselage

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
HSTX  =  18;  // horizontal position
HSTZ  =  41;  // vertical   position
HSTHS =  -8;  // horizontal slant

// vertical stabiliser
VSTL1 =  95;  // rear
VSTL2 =  70;  // front
VSTW  =  90;
VSTT  =  10;
VSTVS = -50;  // vertical slant

// rudder
RUL  = 50;
RUH1 = FUH4+VSTL1;
RUH2 = RUH1-(VSTL1-VSTL2)*2;

// propeller
PHL =  53;     // hub   length
PHR = FUW1/2;  // hub   radius
PBL = 140;     // blade length
PBW =  35;     // blade width
PBT =  10;     // blade thickness

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

module bf109() {
    color(FUC) fuselage(
        FUL1, FUL2, FUL3, FUL4, FUW1, FUW2, FUW3, FUW4,
        FUH1, FUH2, FUH3, FUH4, FUZ1, FUZ4
    );
    // cockpit
    color(FUC) translate([0, FUCY1+(FUL1-COL1-COL2-COL3)/2, (FUH2+COH2)/2]) {
        fvs = -COH3/2+(FUH1-FUH2)/2+FUZ1;  // front vertical slant
        cockpit_nonglazed_front(COL1, COL2, COL3, COW1, COW2, COW3, COH2, COH3, fvs);
    }
    color(OTC) translate([0, FUCY2+(-FUL2+COL3+COL4+COL5)/2, (FUH2+COH1)/2]) {
        cockpit_glazed(COL3, COL4, COL5, COW1, COW2, COH1, COH2);
    }
    color(FUC) translate([0, FUCY2+(-FUL2+COL5-COL6)/2, (FUH2+COH1)/2]) {
        rvs = -COH1/2-(FUH2-FUH3)/2+FUZ4;  // rear vertical slant
        cockpit_nonglazed_rear(COL5, COL6, COW1, COW2, COW4, COH1, rvs);
    }
    // wings
    color(PLC) for(i = [-1, 1]) {
        translate([i*(WIL1+WIL2+FBW2)/2, FUCY2, -(FUH2-WIT)/2]) {
            rotate(-i*90) aircraft_stabiliser(
                WIL1, WIL2, WIW1, WIW2, WIW3, WIT, -i*WIHS, WIVS
            );
        }
    }
    // stabilisers and rudder
    color(PLC) translate([0, FUCY4-FUL4/2, FUZ4]) {
        // horizontal stabilisers
        for(i = [-1, 1]) translate([i*(HSTL1+HSTL2)/2, HSTX, HSTZ]) {
            rotate(-i*90) aircraft_stabiliser(
                HSTL1, HSTL2, HSTW1, HSTW2, HSTW3, HSTT, -i*HSTHS
            );
        }
        // vertical stabiliser
        translate([0, VSTW/2, (FUH4+VSTL1)/2]) {
            vertical_stabiliser(VSTT, VSTW, VSTL1, VSTL2);
        }
        // rudder
        translate([0, -RUL/2, (RUH1-FUH4)/2]) {
            rotate(180) rudder(FUW4, RUL, RUH1, RUH2);
        }
    }
    // propeller
    color(OTC) translate([0, FUCY1+(FUL1+PHL)/2, FUZ1]) {
        propeller(PHL, PHR, PBL, PBW, PBT);
    }
}

bf109();

module fuselage(l1, l2, l3, l4, w1, w2, w3, w4, h1, h2, h3, h4, z1, z3) {
    /*
    args:
        l1...l4: length (front to rear)
        w1...w4: width  (front to rear)
        h1...h4: height (front to rear)
        z1, z3:         Z positions (front, mid-rear)
    */
    y1 = (    l2+l3+l4)/2;
    y2 = (-l1   +l3+l4)/2;
    y3 = (-l1-l2   +l4)/2;
    y4 = (-l1-l2-l3   )/2;
    // front
    translate([0, y1, 0]) scale([w2, l1, h2]) {
        oct_frustum2(w1/w2, h1/h2, 0, z1/h2);
    }
    // mid-front
    translate([0, y2, 0]) scale([w2, l2, h2]) {
        oct_prism();
    }
    // mid-rear
    translate([0, y3, 0]) scale([w2, l3, h2]) {
        rotate(180) oct_frustum2(w3/w2, h3/h2, 0, z3/h2);
    }
    // rear
    translate([0, y4, z3]) scale([w3, l4, h3]) {
        rotate(180) rect_cupola(w4/w3, h4/h3);
    }
}

module cockpit_nonglazed_front(l1, l2, l3, w1, w2, w3, h1, h2, fvs) {
    /*
    args:
        l1...l3 = length (front to rear)
        w1...w3 = width  (rear bottom, rear top, front)
        h1, h2  = height (rear, mid)
        fvs     = front vertical slant
    */
    // front
    translate([0, (l2+l3)/2, (h2-h1)/2]) scale([w1, l1, h2]) {
        trapez_wedge(w2/w1, w3/w1, 0, fvs/h2);
    }
    // mid
    translate([0, (-l1+l3)/2, 0]) scale([w1, l2, h1]) {
        trapez_frustum2(
            w2/w1, 1, w2/w1, h2/h1, 0, (h2-h1)/2/h1
        );
    }
    // rear
    translate([0, (-l1-l2)/2, 0]) scale([w1, l3, h1]) {
        rotate(180) trapez_wedge(w2/w1, 1, 0, -1/2);
    }
}

module cockpit_glazed(l1, l2, l3, w1, w2, h1, h2) {
    /*
    args:
        l1...l3 = length (front to rear)
        w1, w2  = width  (bottom, top)
        h1, h2  = height (rear, front)
    */
    // front
    translate([0, (l2+l3)/2, 0]) scale([w1, l1, h1]) {
        trapez_wedge(w2/w1, w2/w1, 0, -1/2+h2/h1);
    }
    // mid
    translate([0, (-l1+l3)/2, 0]) scale([w1, l2, h1]) {
        trapez_prism(w2/w1);
    }
    // rear
    translate([0, (-l1-l2)/2, 0]) scale([w1, l3, h1]) {
        rotate(180) trapez_wedge(w2/w1, w2/w1, 0, 1/2);
    }
}

module cockpit_nonglazed_rear(l1, l2, w1, w2, w3, h, rvs) {
    /*
    args:
        l1, l2     = length (front, rear)
        w1, w2, w3 = width  (front bottom, front top, rear)
        h          = height
        rvs        = rear vertical slant
    */
    // front
    translate([0, l2/2, 0]) scale([w1, l1, h]) {
        trapez_wedge(w2/w1, 1, 0, -1/2);
    }
    // rear
    translate([0, -l1/2, 0]) scale([w1, l2, h]) {
        rotate(180) trapez_wedge(w2/w1, w3/w1, 0, rvs/h);
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

module propeller(hl, hr, bl, bw, bt) {
    /*
    an aircraft propeller;
    args:
        hl, hr     = hub   length, radius
        bl, bw, bt = blade length, width, thickness, count
    */
    // hub
    scale([hr*2, hl, hr*2]) oct_frustum(1/2);
    // blades
    for(i = [0:2]) rotate([0, i*120-30, 0]) translate([bl/2, 0, 0]) {
        rotate([0, 45, -90]) scale([bw, bl, bt]) hex_wedge(1/2);
    }
}
