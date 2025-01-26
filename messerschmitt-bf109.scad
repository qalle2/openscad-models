// Messerschmitt BF 109G
// TODO: add vertical slant to mid-rear fuselage

use <common.scad>

// fuselage; from front to rear;
// 2nd section = same Y positions as wings
FUA  = 4/7;  // width/height ratio (must be uniform)
FUL1 = 150;
FUL2 = 220;
FUL3 = 330;
FUL4 =  90;
FUH1 =  70;
FUH2 = 110;
FUH3 =  70;
FUH4 =  40;
FUW1 = FUA*FUH1;
FUW2 = FUA*FUH2;
FUW3 = FUA*FUH3;
FUW4 = 10;
FBW2 = FUW2/(1+1*sqrt(2));  // flat bottom width

// cockpit (COL4 = FUL3)
COL1 = 30;
COL2 = 70;
COL3 = 30;
COH  = 20;

// wings
WIL1 = 430;
WIL2 =  60;
WIW1 = FUL2;
WIW2 = 120;
WIW3 =  60;
WIT  =  30;
WIHS =  30;  // horizontal slant
WIVS =  50;  // vertical   slant

// horizontal stabilisers
HSTL1 = 130;
HSTL2 =  15;
HSTW1 = 100;
HSTW2 =  70;
HSTW3 =  50;
HSTT  =  10;
HSTHS = -10;  // horizontal slant

// vertical stabiliser
VSTL1 =  95;  // rear
VSTL2 =  75;  // front
VSTW1 = 100;
VSTW2 =  40;
VSTW3 =  20;
VSTT  =  10;
VSTVS = -50;  // vertical slant

// rudder
RUL  = 50;
RUH1 = FUH4+VSTL1;
RUH2 = RUH1-(VSTL1-VSTL2)*2;

// propeller
PHL =  50;  // hub   length
PHR = FUW1/2;  // hub   radius
PBL = 130;  // blade length
PBW =  20;  // blade width
PBT =  10;  // blade thickness

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

module bf109() {
    color(FUC) fuselage();
    // wings
    color(PLC) for(i = [-1, 1]) translate([i*(WIL1+WIL2+FBW2)/2, (-FUL1+FUL3+FUL4)/2, -(FUH2-WIT)/2]) {
        rotate(-i*90) aircraft_stabiliser(WIL1, WIL2, WIW1, WIW2, WIW3, WIT, -i*WIHS, WIVS);
    }
    // horizontal stabilisers
    color(PLC) for(i = [-1, 1]) translate([i*(HSTL1+HSTL2)/2, (-FUL1-FUL2-FUL3-FUL4+HSTW1)/2-20, FUH3/2+15]) {
        rotate(-i*90) aircraft_stabiliser(HSTL1, HSTL2, HSTW1, HSTW2, HSTW3, HSTT, -i*HSTHS, 0);
    }
    // vertical stabiliser
    color(PLC) translate([0, (-FUL1-FUL2-FUL3-FUL4+HSTW1)/2, (FUH4+VSTL1)/2]) {
        vertical_stabiliser(VSTT, VSTW1, VSTL1, VSTL2);
    }
    // rudder
    color(PLC) translate([0, (-FUL1-FUL2-FUL3-FUL4-RUL)/2, (RUH1-FUH4)/2]) {
        rotate(180) rudder(FUW4, RUL, RUH1, RUH2);
    }
    // cockpit (glazed)
    color(OTC) cockpit_front();
    // cockpit (non-glazed)
    color(FUC) cockpit_rear();
    // propeller
    color(OTC) translate([0, (FUL1+FUL2+FUL3+FUL4+PHL)/2, 0]) aircraft_propeller(PHL, PHR, PBL, PBW, PBT, 3);
}

bf109();

module fuselage() {
    // front
    translate([0, (FUL2+FUL3+FUL4)/2, 0]) scale([FUW2, FUL1, FUH2]) oct_frustum(FUH1/FUH2);
    // mid-front
    translate([0, (-FUL1+FUL3+FUL4)/2, 0]) scale([FUW2, FUL2, FUH2]) oct_prism();
    // mid-rear
    translate([0, (-FUL1-FUL2+FUL4)/2, 0]) scale([FUW2, FUL3, FUH2]) rotate(180) oct_frustum(FUH3/FUH2);
    // rear
    translate([0, (-FUL1-FUL2-FUL3)/2, 0]) scale([FUW3, FUL4, FUH3]) rotate(180) rect_cupola(FUW4/FUW3, FUH4/FUH3);
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

module cockpit_front() {
    // glazed cockpit
    // front
    translate([0, (-FUL1-FUL2+FUL3+FUL4+COL1)/2+COL2+COL3, (FUH2+COH)/2]) {
        scale([FBW2, COL1, COH]) trapez_wedge(1/3, 1/3, 0, -1/2);
    }
    // rear
    translate([0, (-FUL1-FUL2+FUL3+FUL4+COL2)/2+COL3, (FUH2+COH)/2]) {
        scale([FBW2, COL2, COH]) trapez_prism(1/3);
    }
}

module cockpit_rear() {
    // non-glazed cockpit
    // front
    translate([0, (-FUL1-FUL2+FUL3+FUL4+COL3)/2, (FUH2+COH)/2]) {
        scale([FBW2, COL3, COH]) trapez_prism(1/3);
    }
    // rear (same length as FUL3)
    vs = -COH/2-(FUH2-FUH3)/2;  // vertical slant
    translate([0, (-FUL1-FUL2+FUL4)/2, (FUH2+COH)/2]) scale([FBW2, FUL3, COH]) rotate(180) trapez_wedge(1/3, FUH3/FUH2, 0, vs/COH);
}
