// Hawker Hurricane

/*
Fuselage parts:
    1. frustum, front of wings
    2. prism, from leading to trailing edge of wings
    3. frustum, from trailing edge of wings to tail
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
FBW2 = FUW2/(1+sqrt(2));  // flat bottom width

// wings ("length"=root to tip)
WIA  = 1/6;  // height/width (must be uniform)
WIL1 = 200;
WIW1 = 380;
WIL2 = 700;
WIW2 = 100;  // at tip
WIH1 = WIA*WIW1;
WIH2 = WIA*WIW2;

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

// fuselage
color(FUC) {
    // front
    translate([0, (FUL1+FUL2)/2, 0]) {
        scale([FUW2, FUL1, FUH2]) frustum(FUH1/FUH2, 0, 0);
    }
    // mid
    scale([FUW2, FUL2, FUH2]) prism();
    // rear
    translate([0, -(FUL2+FUL3)/2, 0]) rotate(180) {
        scale([FUW2, FUL3, FUH2]) frustum(FUH3/FUH2, 0, 0);
    }
}

// wings
color(PLC) for(x = [-1, 1]) {
    // inner
    translate([x*(WIL1+FBW2)/2, 0, (WIH1-FUH2)/2]) rotate(-x*90) {
        scale([WIW1, WIL1, WIH1]) prism();
    }
    // outer
    translate([x*(WIL1+(WIL2+FBW2)/2), 0, (WIH1-FUH2)/2]) rotate(-x*90) {
        scale([WIW1, WIL2, WIH1]) frustum(WIW2/WIW1, 0, 0);
    }
}

module prism() {
    /*
    a right octagonal prism;
    distance between any two parallel faces = 1;
    centered at [0, 0, 0]; base towards viewer
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

module frustum(fs, fx, fy) {
    /*
    a frustum of an octagonal pyramid;
    centered at [0, 0, 0] (if fxo = fyo = 0);
    base towards viewer;
    front and rear faces: two vertical regular octagons
    with width = height = Y distance = 1;
    other faces: eight trapezoids;
    same as the octagonal prism if fs=1 and fxo = fyo = 0;
    args:
        fs = front width & height scale factor
        fx = front X offset from centerline
        fy = front Y offset from centerline
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