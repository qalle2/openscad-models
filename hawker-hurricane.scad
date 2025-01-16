// Hawker Hurricane

use <common.scad>

/*
Fuselage parts:
    1. octagonal frustum, front of wings
    2. octagonal prism, from leading to trailing edge of wings
    3. octagonal frustum, from trailing edge of wings to tail
    4. octagon to rectangle
*/
FUA  = 2/3;  // width/height (must be uniform)
FUL1 = 200;
FUH1 = 120;
FUL2 = 400;
FUH2 = 250;
FUL3 = 550;
FUH3 = 100;
FUL4 = 180;
FUW1 = FUA*FUH1;
FUW2 = FUA*FUH2;
FUW3 = FUA*FUH3;
FBW2 = FUW2/(1+sqrt(2));  // width of flat bottom and top
FUE3 = -1/10;  // elevation (of FUH2)

// wings ("length"=root to tip)
WIL1 = 180;
WIW1 = 380;
WIH1 = 70;
WIL2 = 620;
WIW2 = 190;  // between mid and outer wing
WIH2 = 20;
WIL3 = 80;
WIW3 = 80;   // width at tip
WIE2 = 1/2;  // elevation between mid and outer wing (of WIH1)

/*
cockpit; parts:
    1. front     (windshield)
    2. mid-front (side windows)
    3. mid-rear  (unglazed)
    4. rear      (unglazed)
*/
COW  = FBW2;
COL1 =   30;
COL2 =  150;
COL3 =   60;
COL4 =  200;
COH  =   40;

// horizontal stabilisers (length = from root to tip)
HSTL1 =  190;  // length 1
HSTW1 = FUL4;  // width 1
HSTT1 =   30;  // thickness 1
HSTL2 =   60;
HSTW2 =  130;
HSTT2 =   10;
HSTW3 =   60;
HSTSL =   15;  // horizontal slant from centerline

// vertical stabilisers and rudder (length = from root to tip)
VSTL1 =  125;      // vertical   - length of thick (lower) part
VSTL2 =   45;      // vertical   - length of thin  (upper) part
VSTW1 = FUL4*2/5;  // vertical - width of front part
VSTW2 = FUL4*2/5;  // vertical - width of mid part
VSTW3 = FUL4-VSTW1-VSTW2;  // vertical - width of rear part
RUL   =   60;      // rudder length (front to rear)
RUH1  = FUH3+VSTL1+VSTL2;  // rudder height 1 (front)
RUH2  = FUH3+VSTL1-VSTL2;  // rudder height 2 (rear)

PHR = FUW1/2;  // propeller hub radius
PHL =  50;     // propeller hub length
PBL = 240;     // propeller blade length
PBW =  35;     // propeller blade width
PBT =  20;     // propeller blade thickness

THIN = 20;  // thickness of many thin objects

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

// fuselage
color(FUC) {
    // front
    translate([0, (FUL1+FUL2)/2, 0]) {
        scale([FUW2, FUL1, FUH2]) oct_frustum(FUH1/FUH2);
    }
    // mid-front
    scale([FUW2, FUL2, FUH2]) oct_frustum();
    // mid-rear
    translate([0, -(FUL2+FUL3)/2, 0]) rotate(180) {
        scale([FUW2, FUL3, FUH2]) oct_frustum(FUH3/FUH2, 0, FUE3);
    }
    // rear
    translate([0, -FUL3-(FUL2+FUL4)/2, FUE3*FUH2]) {
        scale([FUW3, FUL4, FUH3]) rotate(180) square_cupola(THIN/FUW3, 1);
    }
}

// cockpit; Y of mid-rear part = Y of rear of mid fuselage
translate([0, 0, (FUH2+COH)/2]) {
    // front
    color(OTC) translate([0, COL2+COL3+(COL1-FUL2)/2, 0]) {
        scale([COW, COL1, COH]) cockpit_end(1/3, -1/2);
    }
    // mid-front
    color(OTC) translate([0, COL3+(COL2-FUL2)/2, 0]) {
        scale([COW, COL2, COH]) trapez_prism();
    }
    // mid-rear
    color(FUC) translate([0, (COL3-FUL2)/2, 0]) {
        scale([COW, COL3, COH]) trapez_prism();
    }
    // rear
    color(FUC) translate([0, -(FUL2+COL4)/2, 0]) {
        scale([COW, COL4, COH]) rotate(180) {
            cockpit_end(
                1-COL4/FUL3*(1-FUW3/FUW2),
                -1/2 + ((FUH3-FUH2)/2+FUE3*FUH2)/FUL3 * COL4/COH
            );
        }
    }
}

// wings
color(PLC) translate([0, 0, (WIH1-FUH2)/2]) for(x = [-1, 1]) {
    // inner
    translate([x*(WIL1+FBW2)/2, 0, 0]) rotate(-x*90) {
        scale([WIW1, WIL1, WIH1]) oct_frustum();
    }
    // mid
    translate([x*(WIL1+(WIL2+FBW2)/2), 0, 0]) rotate(-x*90) {
        scale([WIW1, WIL2, WIH1]) square_cupola(WIW2/WIW1, WIH2/WIH1, 0, WIE2);
    }
    // outer
    translate([x*(WIL1+WIL2+(WIL3+FBW2)/2), 0, WIE2*WIH1]) rotate(-x*90) {
        scale([WIW2, WIL3, WIH2]) wedge(WIW3/WIW2, 0, WIE2);
    }
}

// horizontal stabilisers
color(PLC) translate([0, -FUL3-(FUL2+FUL4)/2, FUE3*FUH2]) {
    for(x = [-1, 1]) {
        // inner
        translate([x*(HSTL1+THIN)/2, 0, 0]) rotate(-x*90) scale([HSTW1, HSTL1, HSTT1]) square_cupola(HSTW2/HSTW1, HSTT2/HSTT1, x*HSTSL/HSTW1, 0);
        // outer
        translate([x*(HSTL1+(HSTL2+THIN)/2), -HSTSL, 0]) rotate(-x*90) scale([HSTW2, HSTL2, HSTT2]) wedge(HSTW3/HSTW2);
    }
}

// vertical stabiliser and rudder
color(PLC) translate([0, -FUL3-(FUL2+FUL4)/2, FUE3*FUH2+FUH3/2]) {
    translate([0, -(FUL4-VSTW3)/2,       VSTL1/2])       scale([THIN, VSTW3, VSTL1])                       cube(center=true);                // bottom mid-rear
    translate([0,  (FUL4-VSTW1)/2,       VSTL1/2])       scale([THIN, VSTW1, VSTL1]) rotate([-90, 180, 0]) tri_frustum(1, 0, -VSTW2/VSTW1);  // bottom front
    translate([0,  (FUL4-VSTW2)/2-VSTW1, VSTL1/2])       scale([THIN, VSTW2, VSTL1])                       wedge(1, 0, -1/2);                // bottom mid-front
    translate([0,  (FUL4-VSTW1)/2-VSTW2, VSTL1+VSTL2/2]) scale([THIN, VSTW1, VSTL2])                       tetrahedron(0, -1/2);             // top front
    translate([0, -(FUL4-VSTW3)/2,       VSTL1+VSTL2/2]) scale([THIN, VSTW3, VSTL2]) rotate([90, 0, 90])   wedge();                          // top mid
    translate([0, -(FUL4+RUL)/2,         VSTL1+VSTL2/2]) scale([THIN, RUL,   VSTL2]) rotate([90, 0,  0])   tetrahedron(0, -1/2);             // top rear
    translate([0, -(FUL4+RUL)/2,         VSTL1-RUH2/2])  scale([THIN, RUL,   RUH2])  rotate([0, 90, 180])  wedge();                          // middle rear
    translate([0, -(FUL4+RUL)/2,         VSTL2/2-FUH3])  scale([THIN, RUL,   VSTL2]) rotate(180)           square_pyramid(0, 1/2);           // bottom rear
}

// propeller
color(OTC) translate([0, FUL1+(FUL2+PHL)/2, 0]) {
    // hub
    scale([PHR*2, PHL, PHR*2]) oct_frustum(1/2);
    // blades
    for(x = [0, 1]) rotate([0, 30-x*180, 0]) translate([PBL/2, 0, 0]) {
        rotate([0,-60,-90]) scale([PBW, PBL, PBT]) oct_wedge(1/2);
    }
}

module trapez_prism() {
    /*
    a trapezoidal prism; trapezoids face front and rear;
    length, height and bottom width = 1;
    top width = 1/3
    */
    a = 1/6;
    b = 1/2;
    polyhedron(
        [
            // rear
            [-b, -b, -b],
            [-a, -b,  b],
            [ a, -b,  b],
            [ b, -b, -b],
            // front
            [-b,  b, -b],
            [-a,  b,  b],
            [ a,  b,  b],
            [ b,  b, -b],
        ],
        [
            [0, 1, 2, 3],
            [0, 3, 7, 4],
            [0, 4, 5, 1],
            [1, 5, 6, 2],
            [2, 6, 7, 3],
            [4, 7, 6, 5],
        ]
    );
}

module cockpit_end(fxs, fzo) {
    /*
    trapezoid on rear end, horizontal line on front end;
    an irregular triangular prism?
    maximum dimensions: 1*1*1 if fzo=0;
    fxs = front X scale factor (1 = same as rear);
    fzo = front Z offset (from centerline)
    */
    a  = 1/6;
    b  = 1/2;
    fx = fxs/2;
    polyhedron(
        [
            // rear
            [ -b, -b,  -b],
            [ -a, -b,   b],
            [  a, -b,   b],
            [  b, -b,  -b],
            // front
            [-fx,  b, fzo],
            [ fx,  b, fzo],
        ],
        [
            [0, 1, 2, 3],
            [0, 3, 5, 4],
            [1, 4, 5, 2],
            [0, 4, 1],
            [2, 5, 3],
        ]
    );
}
