// Hawker Hurricane

/*
Fuselage parts:
    1. octagonal frustum, front of wings
    2. octagonal prism, from leading to trailing edge of wings
    3. octagonal frustum, from trailing edge of wings to tail
*/
FUA  = 2/3;  // width/height (must be uniform)
FUL1 = 200;
FUH1 = 120;
FUL2 = 400;
FUH2 = 250;
FUL3 = 550;
FUH3 = 100;
FUW1 = FUA*FUH1;
FUW2 = FUA*FUH2;
FUW3 = FUA*FUH3;
FBW2 = FUW2/(1+sqrt(2));  // width of flat bottom and top
FUE3 = -1/10;  // elevation (of FUH2)

// wings ("length"=root to tip)
WIA  = 1/6;  // height/width (must be uniform)
WIL1 = 200;
WIW1 = 380;
WIL2 = 700;
WIW2 = 100;  // at tip
WIH1 = WIA*WIW1;
WIH2 = WIA*WIW2;
WTE  = 1/2;  // wingtip elevation (of WIH1)

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

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

// fuselage
color(FUC) {
    // front
    translate([0, (FUL1+FUL2)/2, 0]) {
        scale([FUW2, FUL1, FUH2]) octfrustum(FUH1/FUH2, 0, 0);
    }
    // mid
    scale([FUW2, FUL2, FUH2]) octprism();
    // rear
    translate([0, -(FUL2+FUL3)/2, 0]) rotate(180) {
        scale([FUW2, FUL3, FUH2]) octfrustum(FUH3/FUH2, 0, FUE3);
    }
}

// cockpit; Y of mid-rear part = Y of rear of mid fuselage
translate([0, 0, (FUH2+COH)/2]) {
    // front
    color(OTC) translate([0, COL2+COL3+(COL1-FUL2)/2, 0]) {
        scale([COW, COL1, COH]) cockpitend(1/3, -1/2);
    }
    // mid-front
    color(OTC) translate([0, COL3+(COL2-FUL2)/2, 0]) {
        scale([COW, COL2, COH]) trapezprism();
    }
    // mid-rear
    color(FUC) translate([0, (COL3-FUL2)/2, 0]) {
        scale([COW, COL3, COH]) trapezprism();
    }
    // rear
    color(FUC) translate([0, -(FUL2+COL4)/2, 0]) {
        scale([COW, COL4, COH]) rotate(180) {
            cockpitend(
                1-COL4/FUL3*(1-FUW3/FUW2),
                -1/2 + ((FUH3-FUH2)/2+FUE3*FUH2)/FUL3 * COL4/COH
            );
        }
    }
}

// wings
color(PLC) for(x = [-1, 1]) {
    // inner
    translate([x*(WIL1+FBW2)/2, 0, (WIH1-FUH2)/2]) rotate(-x*90) {
        scale([WIW1, WIL1, WIH1]) octprism();
    }
    // outer
    translate([x*(WIL1+(WIL2+FBW2)/2), 0, (WIH1-FUH2)/2]) rotate(-x*90) {
        scale([WIW1, WIL2, WIH1]) octfrustum(WIW2/WIW1, 0, WTE);
    }
}

module trapezprism() {
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

module cockpitend(fxs, fzo) {
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

module octprism() {
    /*
    a right octagonal prism;
    distance between any two parallel faces = 1;
    centred at [0, 0, 0]; base towards viewer
    */
    a = 1/(2+2*sqrt(2));  // small
    b = 1/2;              // big
    polyhedron(
        [
            // rear
            [-b, -b, -a],
            [-b, -b,  a],
            [-a, -b,  b],
            [ a, -b,  b],
            [ b, -b,  a],
            [ b, -b, -a],
            [ a, -b, -b],
            [-a, -b, -b],
            // front
            [-b,  b, -a],
            [-b,  b,  a],
            [-a,  b,  b],
            [ a,  b,  b],
            [ b,  b,  a],
            [ b,  b, -a],
            [ a,  b, -b],
            [-a,  b, -b],
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

module octfrustum(fs, fx, fy) {
    /*
    a frustum of an octagonal pyramid;
    centred at [0, 0, 0] (if fxo = fyo = 0);
    base towards viewer;
    front and rear faces: two vertical regular octagons
    with width = height = Y distance = 1;
    other faces: eight trapezoids;
    same as the octagonal prism if fs=1 and fxo = fyo = 0;
    args:
        fs = front width & height scale factor
        fx = front X offset from centreline
        fy = front Y offset from centreline
    note: front face must have same width/height ratio as rear face;
    otherwise side faces would not be planes
    */
    ra =  1/(2+2*sqrt(2));  // rear  small
    fa = fs/(2+2*sqrt(2));  // front small
    y  =  1/2;
    rb =  1/2;              // rear  big
    fb = fs/2;              // front big
    polyhedron(
        [
            // rear
            [  -rb, -y,   -ra],
            [  -rb, -y,    ra],
            [  -ra, -y,    rb],
            [   ra, -y,    rb],
            [   rb, -y,    ra],
            [   rb, -y,   -ra],
            [   ra, -y,   -rb],
            [  -ra, -y,   -rb],
            // front
            [fx-fb,  y, fy-fa],
            [fx-fb,  y, fy+fa],
            [fx-fa,  y, fy+fb],
            [fx+fa,  y, fy+fb],
            [fx+fb,  y, fy+fa],
            [fx+fb,  y, fy-fa],
            [fx+fa,  y, fy-fb],
            [fx-fa,  y, fy-fb],
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