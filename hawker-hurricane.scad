/* Hawker Hurricane;
every module is centered at [0, 0, 0] */

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
FUW4 = 20;
FBW2 = FUW2/(1+sqrt(2));  // width of flat bottom and top
FUE3 = -1/10;  // elevation (of FUH2)

// wings (W=width=X, L=length=Y, T=thickness=Z, 1-3=inner to outer)
WIW1 = 180;
WIL1 = 380;
WIT1 = 70;
WIW2 = 620;
WIL2 = 190;
WIT2 = 20;
WIW3 = 80;
WIL3 = 80;
WIEL = 35;   // elevation between mid and outer wing

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

// horizontal stabilisers (W=width=X, L=length=Y, T=thickness=Z)
HSTW1 =  190;
HSTL1 = FUL4;
HSTT1 =   30;
HSTW2 =   60;
HSTL2 =  130;
HSTT2 =   10;
HSTL3 =   60;
HSTSL =   15;  // horizontal slant from centerline

// vertical stabiliser (L=length=Y, H=height=Z, T=thickness=X)
VSTL1 = FUL4*2/5;          // front part
VSTL2 = FUL4*2/5;          // mid part
VSTL3 = FUL4-VSTL1-VSTL2;  // rear part
VSTH1 = 125;               // thick (lower) part
VSTH2 =  45;               // thin  (upper) part
VSTT  = FUW4;

// rudder (L=length=Y, H=height=Z, T=thickness=X)
RUL  =  80;               // length
RUH1 = FUH3+VSTH1+VSTH2;  // height 1 (front)
RUH2 = FUH3+VSTH1-VSTH2;  // height 2 (rear)
RUT  = FUW4;

// propeller
PHR = FUW1/2;  // hub radius
PHL =  50;     // hub length
PBL = 240;     // blade length
PBW =  35;     // blade width
PBT =  20;     // blade thickness

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

module hurricane() {
    /* draws everything */
    // fuselage
    color(FUC) translate([0, 0, 0]) fuselage();
    // front half of cockpit
    color(OTC) translate([0, COL3+(-FUL1-FUL2+FUL3+FUL4+COL1+COL2)/2, (FUH2+COH)/2]) {
        cockpit_fronthalf(COW, COL1, COL2, COH);
    }
    // rear half of cockpit
    color(FUC) translate([0, (-FUL1-FUL2+FUL3+FUL4+COL3-COL4)/2, (FUH2+COH)/2]) {
        cockpit_rearhalf();
    }
    // wings
    color(PLC) for(x = [-1, 1]) {
        translate([x*(WIW1+WIW2+WIW3+FBW2)/2, (-FUL1+FUL3+FUL4)/2, (WIT1-FUH2)/2]) {
            rotate(-x*90) wing(WIW1, WIW2, WIW3, WIL1, WIL2, WIL3, WIT1, WIT2, WIEL);
        }
    }
    // stabilisers and rudder
    color(PLC) translate([0, (-FUL1-FUL2-FUL3)/2, FUE3*FUH2]) {
        // horizontal stabilisers
        for(x = [-1, 1]) translate([x*(FUW4+HSTW1+HSTW2)/2, 0, 0]) {
            rotate(-x*90) horizontal_stabiliser(x);
        }
        // vertical stabiliser
        translate([0, 0, FUH3/2+(VSTH1+VSTH2)/2]) {
            vertical_stabiliser(VSTT, VSTL3, VSTL2, VSTL1, VSTH1, VSTH2);
        }
        // rudder
        translate([0, (-FUL4-RUL)/2, (RUH1-FUH3)/2]) {
            rotate(180) rudder(RUT, RUL, RUH1, RUH2);
        }
    }
    // propeller
    color(OTC) translate([0, (FUL1+FUL2+FUL3+FUL4+PHL)/2, 0]) {
        rotate([0, 30, 0]) propeller();
    }
}

hurricane();

module fuselage() {
    /* centered */
    // front
    translate([0, (FUL2+FUL3+FUL4)/2, 0]) {
        scale([FUW2, FUL1, FUH2]) oct_frustum(FUH1/FUH2);
    }
    // mid-front
    translate([0, (-FUL1+FUL3+FUL4)/2, 0]) {
        scale([FUW2, FUL2, FUH2]) oct_frustum();
    }
    // mid-rear
    translate([0, (-FUL1-FUL2+FUL4)/2, 0]) rotate(180) {
        scale([FUW2, FUL3, FUH2]) oct_frustum(FUH3/FUH2, 0, FUE3);
    }
    // rear
    translate([0, (-FUL1-FUL2-FUL3)/2, FUE3*FUH2]) {
        scale([FUW3, FUL4, FUH3]) rotate(180) square_cupola(FUW4/FUW3, 1);
    }
}

module cockpit_fronthalf(w, l1, l2, h) {
    /*
    faces:
        1 irregular hexagon (horizontal, bottom)
        1 trapezoid (vertical, rear)
        4 rectangles
        2 triangles
    args:
        w      = bottom width (top width = w/3)
        l1, l2 = front/rear length
        h      = height
    */
    x1 =        w/6;
    x2 =        w/2;
    y1 = (-l1-l2)/2;
    y2 = (-l1+l2)/2;
    y3 = ( l1+l2)/2;
    z  =        h/2;
    //
    polyhedron(
        [
            // rear
            [-x2, y1, -z],
            [-x1, y1,  z],
            [ x1, y1,  z],
            [ x2, y1, -z],
            // mid
            [-x2, y2, -z],
            [-x1, y2,  z],
            [ x1, y2,  z],
            [ x2, y2, -z],
            // front
            [-x1, y3, -z],
            [ x1, y3, -z],
        ],
        [
            // bottom
            [0,3,7,9,8,4],
            // rear
            [0,1,2,3],
            // mid
            [0,4,5,1], [1,5,6,2], [2,6,7,3],
            // front
            [4,8,5], [5,8,9,6], [6,9,7],
        ]
    );
}

module cockpit_rearhalf() {
    /* Z centring is done only according to the front half;
    faces:
        4 rectangles          (front)
        3 trapezoids          (front, rear)
        2 irregular triangles (rear)
    */
    x1 =  COW * (1 - COL4/FUL3 * (1-FUW3/FUW2)) / 2;
    x2 =  COW/6;
    x3 =  COW/2;
    y1 = -COL4/2 - COL3/2;
    y2 = -COL3/2 + COL4/2;
    y3 =  COL3/2 + COL4/2;
    z1 = -COH/2 + ((FUH3-FUH2)/2+FUE3*FUH2)/FUL3 * COL4;
    z2 = -COH/2;
    z3 =  COH/2;
    //
    polyhedron(
        [
            // rear
            [-x1, y1, z1],
            [ x1, y1, z1],
            // mid
            [-x3, y2, z2],
            [-x2, y2, z3],
            [ x2, y2, z3],
            [ x3, y2, z2],
            // front
            [-x3, y3, z2],
            [-x2, y3, z3],
            [ x2, y3, z3],
            [ x3, y3, z2],
        ],
        [
            // rear
            [0,2,3], [0,3,4,1], [1,4,5], [0,1,5,2],
            // front
            [2,5,9,6], [2,6,7,3], [3,7,8,4], [4,8,9,5], [6,9,8,7],
        ]
    );
}

module wing(l1, l2, l3, w1, w2, w3, t1, t2, vs) {
    /*
    root towards viewer;
    faces:
        1 irregular octagon   (root)
        8 rectangles          (root)
        2 parallelograms      (mid)
        4 trapezoids          (mid, tip)
        6 irregular triangles (mid, tip)
    args:
        l1, l2, l3 = length (inner to outer)
        w1, w2, w3 = width  (inner to outer)
        t1, t2     = thickness (inner, middle; outer is zero)
        vs         = vertical slant from centerline
    */
    x1a = w1/(2+2*sqrt(2));
    x1b = w1/2;
    x2  = w2/2;
    x3  = w3/2;
    y1  = (-l1-l2-l3)/2;
    y2  = ( l1-l2-l3)/2;
    y3  = ( l1+l2-l3)/2;
    y4  = ( l1+l2+l3)/2;
    z1a = t1/(2+2*sqrt(2));
    z1b = t1/2;
    z2  = vs-t2/2;
    z3  = vs+t2*vs/t1;
    z4  = vs+t2/2;
    //
    translate([0, 0, 0]) {
        polyhedron(
            [
                // rear (0-7)
                [-x1b, y1, -z1a],
                [-x1b, y1,  z1a],
                [-x1a, y1,  z1b],
                [ x1a, y1,  z1b],
                [ x1b, y1,  z1a],
                [ x1b, y1, -z1a],
                [ x1a, y1, -z1b],
                [-x1a, y1, -z1b],
                // mid-rear (8-15)
                [-x1b, y2, -z1a],
                [-x1b, y2,  z1a],
                [-x1a, y2,  z1b],
                [ x1a, y2,  z1b],
                [ x1b, y2,  z1a],
                [ x1b, y2, -z1a],
                [ x1a, y2, -z1b],
                [-x1a, y2, -z1b],
                // mid-front (16-19)
                [-x2, y3, z2],
                [-x2, y3, z4],
                [ x2, y3, z4],
                [ x2, y3, z2],
                // front (20-21)
                [-x3, y4, z3],
                [ x3, y4, z3],
            ],
            [
                // rear
                [0,1,2,3,4,5,6,7],
                // mid-rear
                [ 0,  8,  9,  1],
                [ 1,  9, 10,  2],
                [ 2, 10, 11,  3],
                [ 3, 11, 12,  4],
                [ 4, 12, 13,  5],
                [ 5, 13, 14,  6],
                [ 6, 14, 15,  7],
                [ 7, 15,  8,  0],
                // mid-front
                [ 8,16,17, 9], [ 9,17,10],
                [10,17,18,11], [11,18,12],
                [12,18,19,13], [13,19,14],
                [14,19,16,15], [15,16, 8],
                // front
                [16,20,17], [17,20,21,18],
                [18,21,19], [19,21,20,16],
            ]
        );
    }
}

module horizontal_stabiliser(ss) {
    /*
    root towards viewer;
    [0, 0, 0] = average of max width, length, height;
    faces:
        1 octagon (vertical, rear)
        2 trapezoids (rear top & bottom)
        ?
    args:
        ss = sign of slant (-1 or +1)
    */
    xo2 = ss*HSTW1/(HSTW1+HSTW2)*HSTSL;  // middle X offset
    xo3 = ss*HSTSL;                      // front X offset
    x1a = HSTL1/(2+2*sqrt(2));           // rear X - smaller
    x1b = HSTL1/2;                       // rear X - larger
    x2  = HSTL2/2;                       // middle X
    x3  = HSTL3/2;                       // front X
    y1  = -HSTW1/2;                      // rear Y
    y2  = HSTW1/2;                       // mid Y
    y3  = HSTW1/2+HSTW2;                 // front Y
    z1a = x1a*HSTT1/HSTL1;               // rear Z - smaller
    z2a = x1b*HSTT1/HSTL1;               // rear Z - larger
    z2  = HSTT2/2;                       // middle Z
    //
    translate([0, -HSTW2/2, 0]) polyhedron(
        [
            // rear (0-7)
            [  -x1b, y1, -z1a],
            [  -x1b, y1,  z1a],
            [  -x1a, y1,  z2a],
            [   x1a, y1,  z2a],
            [   x1b, y1,  z1a],
            [   x1b, y1, -z1a],
            [   x1a, y1, -z2a],
            [  -x1a, y1, -z2a],
            // mid (8-11)
            [xo2-x2, y2,  -z2],
            [xo2-x2, y2,   z2],
            [xo2+x2, y2,   z2],
            [xo2+x2, y2,  -z2],
            // front (12-13)
            [xo3-x3, y3,    0],
            [xo3+x3, y3,    0],
        ],
        [
            // rear
            [0,1,2,3,4,5,6,7],
            // middle
            [0, 8, 9,1], [1, 9,2],
            [2, 9,10,3], [3,10,4],
            [4,10,11,5], [5,11,6],
            [6,11, 8,7], [7, 8,0],
            // front
            [8,11,13,12], [ 8,12, 9],
            [9,12,13,10], [10,13,11],
        ]
    );
}

module vertical_stabiliser(w, l1, l2, l3, h1, h2) {
    /*
    root towards viewer;
    faces:
        2 irregular pentagons (vertical rear and horizontal bottom)
        2 rectangles
        2 parallelograms
        2 trapezoids
        2 right triangles
    [0, 0, 0] = average of max width, length, height
    args:
        w          = width
        l1, l2, l3 = length (rear to front)
        h1, h2     = height (bottom to top)
    */
    x = w/2;
    translate([0, (-l1-l2-l3)/2, (-h1-h2)/2]) polyhedron(
        [
            // first rear to front, then clockwise from rear
            [-x, 0,        0],  //  0
            [-x, 0,       h1],  //  1
            [ 0, 0,    h1+h2],  //  2
            [ x, 0,       h1],  //  3
            [ x, 0,        0],  //  4
            [-x, l1,      h1],  //  5
            [ 0, l1,   h1+h2],  //  6
            [ x, l1,      h1],  //  7
            [-x, l1+l2,    0],  //  8
            [ x, l1+l2,    0],  //  9
            [ 0, l1+l3,   h1],  // 10
            [ 0, l1+l2+l3, 0],  // 11
        ],
        [
            // bottom
            [0, 4, 9, 11, 8],
            // first rear to front, then left to right
            [0,  1,  2,  3, 4],
            [0,  8,  5,  1],
            [3,  7,  9,  4],
            [5,  8, 11, 10],
            [7, 10, 11,  9],
            [1,  5,  6,  2],
            [2,  6,  7,  3],
            [5, 10,  6],
            [6, 10,  7],
        ]
    );
}

module rudder(w, l, h1, h2) {
    /*
    root towards viewer;
    faces:
        1 irregular pentagon       (vertical, rear)
        2 irregular quadrilaterals (vertical)
        2 right     triangles
        1 isosceles triangle
    [0, 0, 0] = average of max width, length, height
    args:
        w     = width
        l     = length
        h1/h2 = larger/smaller height
    */
    x  =  w/2;
    y  =  l/2;
    z1 = h1/2;       // large
    z2 = h1/2-h2/4;  // small
    polyhedron(
        [
            // rear
            [-x, -y, -z1],
            [-x, -y,  z2],
            [ 0, -y,  z1],
            [ x, -y,  z2],
            [ x, -y, -z1],
            // front
            [ 0,  y, -z2],
            [ 0,  y,  z2],
        ],
        [[0,1,2,3,4], [0,4,5], [0,5,6,1], [1,6,2], [2,6,3], [3,6,5,4]]
    );
}

module propeller() {
    // hub
    scale([PHR*2, PHL, PHR*2]) square_cupola(1/2, 1/2);
    // blades
    for(x = [0, 1]) rotate([0, x*180, 0]) translate([PBL/2, 0, 0]) {
        rotate([0,-45,-90]) scale([PBW, PBL, PBT]) wedge(1/2);
    }
}
