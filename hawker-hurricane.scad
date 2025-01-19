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
FUA   = 2/3;  // width/height ratio (must be uniform)
FUL1  = 200;
FUH1  = 120;
FUL2  = 400;
FUH2  = 250;
FUL3  = 550;
FUH3  = 100;
FUL4  = 180;
FUW1  = FUA*FUH1;
FUW2  = FUA*FUH2;
FUW3  = FUA*FUH3;
FUW4  = 20;
FBW2  = FUW2/(1+sqrt(2));  // width of flat bottom and top
FUVS3 = -1/10;  // vertical slant (of FUH2)

// wings (W=width=X, L=length=Y, T=thickness=Z, 1-3=inner to outer)
WIW1 = 180;
WIL1 = 380;
WIT1 = 70;
WIW2 = 620;
WIL2 = 190;
WIT2 = 20;
WIW3 = 80;
WIL3 = 80;

/*
cockpit; parts:
    1. front     (windshield)
    2. mid-front (side windows)
    3. mid-rear  (unglazed)
    4. rear      (unglazed)
*/
COW1 = FBW2;      // bottom
COW2 = FBW2*3/7;  // top
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
    color(FUC) fuselage(FUA, FUW4, FUL1, FUL2, FUL3, FUL4, FUH1, FUH2, FUH3, FUVS3*FUH2);
    // rear half of cockpit
    color(FUC) {
        // width at rear
        rw = COW1*(1-COL4/FUL3*(1-FUW3/FUW2));
        // total height; also total height of rear half
        h = ((FUH2-FUH3)/2-FUVS3*FUH2)/FUL3 * COL4 + COH;
        translate([0, (-FUL1-FUL2+FUL3+FUL4+COL3-COL4)/2, COH+(FUH2-h)/2]) {
            cockpit_rearhalf(rw, COW1, COW2, COL4, COL3, h, COH);
        }
    }
    // front half of cockpit
    color(OTC) translate([0, COL3+(-FUL1-FUL2+FUL3+FUL4+COL1+COL2)/2, (FUH2+COH)/2]) {
        cockpit_fronthalf(COW1, COW2, COL1, COL2, COH);
    }
    // wings
    color(PLC) for(x = [-1, 1]) {
        translate([x*(WIW1+WIW2+WIW3+FBW2)/2, (-FUL1+FUL3+FUL4)/2, (WIT1-FUH2)/2]) {
            rotate(-x*90) wing(WIL1, WIL2, WIL3, WIW1, WIW2, WIW3, WIT1, WIT2);
        }
    }
    // stabilisers and rudder
    color(PLC) translate([0, (-FUL1-FUL2-FUL3)/2, FUVS3*FUH2]) {
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

module fuselage(whr, w4, l1, l2, l3, l4, h1, h2, h3, vs3) {
    /*
    args:
        whr     = width/height ratio (front to mid-rear)
        w4      = width              (rear only)
        l1...l4 = length             (front to rear)
        h1...h3 = height             (front to rear)
        vs3     = vertical slant     (from centerline; mid-rear only)
    */
    x1  =     w4/2;
    x2a = whr*h3/(2+2*sqrt(2));
    x2b = whr*h3/2;
    x3a = whr*h2/(2+2*sqrt(2));
    x3b = whr*h2/2;
    x4a = whr*h1/(2+2*sqrt(2));
    x4b = whr*h1/2;
    //
    y1 = (-l1-l2-l3-l4)/2;
    y2 = (-l1-l2-l3+l4)/2;
    y3 = (-l1-l2+l3+l4)/2;
    y4 = (-l1+l2+l3+l4)/2;
    y5 = ( l1+l2+l3+l4)/2;
    //
    z1a = -h3/(2+2*sqrt(2)) + vs3;
    z1b = -h3/2             + vs3;
    z2a =  h3/(2+2*sqrt(2)) + vs3;
    z2b =  h3/2             + vs3;
    z3a = -h2/(2+2*sqrt(2));
    z3b = -h2/2;
    z4a =  h2/(2+2*sqrt(2));
    z4b =  h2/2;
    z5a = -h1/(2+2*sqrt(2));
    z5b = -h1/2;
    z6a =  h1/(2+2*sqrt(2));
    z6b =  h1/2;
    //
    // start indexes of vertex groups (rear to front)
    vg1 =  0;
    vg2 =  4;
    vg3 = 12;
    vg4 = 20;
    vg5 = 28;
    //
    polyhedron(
        [
            // group 1
            [ -x1, y1, z1b],
            [ -x1, y1, z2b],
            [  x1, y1, z2b],
            [  x1, y1, z1b],
            // group 2
            [-x2b, y2, z1a],
            [-x2b, y2, z2a],
            [-x2a, y2, z2b],
            [ x2a, y2, z2b],
            [ x2b, y2, z2a],
            [ x2b, y2, z1a],
            [ x2a, y2, z1b],
            [-x2a, y2, z1b],
            // group 3
            [-x3b, y3, z3a],
            [-x3b, y3, z4a],
            [-x3a, y3, z4b],
            [ x3a, y3, z4b],
            [ x3b, y3, z4a],
            [ x3b, y3, z3a],
            [ x3a, y3, z3b],
            [-x3a, y3, z3b],
            // group 4
            [-x3b, y4, z3a],
            [-x3b, y4, z4a],
            [-x3a, y4, z4b],
            [ x3a, y4, z4b],
            [ x3b, y4, z4a],
            [ x3b, y4, z3a],
            [ x3a, y4, z3b],
            [-x3a, y4, z3b],
            // group 5
            [-x4b, y5, z5a],
            [-x4b, y5, z6a],
            [-x4a, y5, z6b],
            [ x4a, y5, z6b],
            [ x4b, y5, z6a],
            [ x4b, y5, z5a],
            [ x4a, y5, z5b],
            [-x4a, y5, z5b],
        ],
        [
            // rear end (vertical; vertex group 1)
            [vg1+0, vg1+1, vg1+2, vg1+3],
            // rear section (vertex groups 1 & 2)
            [vg1+0, vg2+0, vg2+1, vg1+1],
            [vg1+1, vg2+1, vg2+2],
            [vg1+1, vg2+2, vg2+3, vg1+2],
            [vg1+2, vg2+3, vg2+4],
            [vg1+2, vg2+4, vg2+5, vg1+3],
            [vg1+3, vg2+5, vg2+6],
            [vg1+3, vg2+6, vg2+7, vg1+0],
            [vg1+0, vg2+7, vg2+0],
            // mid-rear section (vertex groups 2 & 3)
            [vg2+0, vg3+0, vg3+1, vg2+1],
            [vg2+1, vg3+1, vg3+2, vg2+2],
            [vg2+2, vg3+2, vg3+3, vg2+3],
            [vg2+3, vg3+3, vg3+4, vg2+4],
            [vg2+4, vg3+4, vg3+5, vg2+5],
            [vg2+5, vg3+5, vg3+6, vg2+6],
            [vg2+6, vg3+6, vg3+7, vg2+7],
            [vg2+7, vg3+7, vg3+0, vg2+0],
            // mid-front section (vertex groups 3 & 4)
            [vg3+0, vg4+0, vg4+1, vg3+1],
            [vg3+1, vg4+1, vg4+2, vg3+2],
            [vg3+2, vg4+2, vg4+3, vg3+3],
            [vg3+3, vg4+3, vg4+4, vg3+4],
            [vg3+4, vg4+4, vg4+5, vg3+5],
            [vg3+5, vg4+5, vg4+6, vg3+6],
            [vg3+6, vg4+6, vg4+7, vg3+7],
            [vg3+7, vg4+7, vg4+0, vg3+0],
            // front section (vertex groups 4 & 5)
            [vg4+0, vg5+0, vg5+1, vg4+1],
            [vg4+1, vg5+1, vg5+2, vg4+2],
            [vg4+2, vg5+2, vg5+3, vg4+3],
            [vg4+3, vg5+3, vg5+4, vg4+4],
            [vg4+4, vg5+4, vg5+5, vg4+5],
            [vg4+5, vg5+5, vg5+6, vg4+6],
            [vg4+6, vg5+6, vg5+7, vg4+7],
            [vg4+7, vg5+7, vg5+0, vg4+0],
            // front end (vertical; vertex group 5)
            [vg5+0, vg5+7, vg5+6, vg5+5, vg5+4, vg5+3, vg5+2, vg5+1],
        ]
    );
}

module cockpit_rearhalf(w1, w2a, w2b, l1, l2, h1, h2) {
    /*
    faces:
        4 rectangles          (front)
        3 trapezoids          (front, rear)
        2 irregular triangles (rear)
    args:
        w1, w2a, w2b = width  at rear, front bottom, front top
        l1, l2       = length at rear, front
        h1, h2       = height at rear, front
    */
    x1  =       w1/2;
    x2a =      w2a/2;
    x2b =      w2b/2;
    y1  = (-l1-l2)/2;
    y2  = ( l1-l2)/2;
    y3  = ( l1+l2)/2;
    z1  =      -h1/2;
    z2  =       h1/2-h2;
    z3  =       h1/2;
    //
    polyhedron(
        [
            // rear
            [-x1, y1, z1],
            [ x1, y1, z1],
            // mid
            [-x2a, y2, z2],
            [-x2b, y2, z3],
            [ x2b, y2, z3],
            [ x2a, y2, z2],
            // front
            [-x2a, y3, z2],
            [-x2b, y3, z3],
            [ x2b, y3, z3],
            [ x2a, y3, z2],
        ],
        [
            // rear
            [0,2,3], [0,3,4,1], [1,4,5], [0,1,5,2],
            // front
            [2,5,9,6], [2,6,7,3], [3,7,8,4], [4,8,9,5], [6,9,8,7],
        ]
    );
}

module cockpit_fronthalf(w1, w2, l1, l2, h) {
    /*
    faces:
        1 irregular hexagon (horizontal, bottom)
        1 trapezoid (vertical, rear)
        4 rectangles
        2 triangles
    args:
        w1, w2 = bottom/top width
        l1, l2 = front/rear length
        h      = height
    */
    x1 =       w2/2;
    x2 =       w1/2;
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

module wing(w1, w2, w3, l1, l2, l3, t1, t2) {
    /*
    root towards viewer;
    faces:
        1 irregular octagon   (root)
        1 irregular hexagon   (top)
        7 rectangles          (root)
        2 parallelograms      (mid)
        2 trapezoids          (mid, tip)
        6 irregular triangles (mid, tip)
    args:
        w1...w3 = width     (inner to outer)
        l1...l3 = length    (inner to outer)
        t1...t2 = thickness (inner, middle; outer is zero)
    */
    x1a = w1/(2+2*sqrt(2));
    x1b = w1/2;
    x2  = w2/2;
    x3  = w3/2;
    //
    y1 = (-l1-l2-l3)/2;
    y2 = ( l1-l2-l3)/2;
    y3 = ( l1+l2-l3)/2;
    y4 = ( l1+l2+l3)/2;
    //
    z1a = t1/(2+2*sqrt(2));
    z1b = t1/2;
    z2  = l2/(l2+l3)*t1/2;
    z3  = t1/2;
    //
    // start indexes of vertex groups (rear to front)
    vg1 = 0;
    vg2 = 8;
    vg3 = 16;
    vg4 = 20;
    //
    polyhedron(
        [
            // group 1 (rearmost)
            [-x1b, y1, -z1a],
            [-x1b, y1,  z1a],
            [-x1a, y1,  z1b],
            [ x1a, y1,  z1b],
            [ x1b, y1,  z1a],
            [ x1b, y1, -z1a],
            [ x1a, y1, -z1b],
            [-x1a, y1, -z1b],
            // group 2
            [-x1b, y2, -z1a],
            [-x1b, y2,  z1a],
            [-x1a, y2,  z1b],
            [ x1a, y2,  z1b],
            [ x1b, y2,  z1a],
            [ x1b, y2, -z1a],
            [ x1a, y2, -z1b],
            [-x1a, y2, -z1b],
            // group 3
            [ -x2, y3,   z2],
            [ -x2, y3,  z1b],
            [  x2, y3,  z1b],
            [  x2, y3,   z2],
            // group 4
            [ -x3, y4,  z3],
            [  x3, y4,  z3],
        ],
        [
            // top of entire wing (vertex groups 1-4)
            [vg1+3, vg1+2, vg2+2, vg3+1, vg4+0, vg4+1, vg3+2, vg2+3],
            // rear (vertex group 1)
            [vg1+0, vg1+1, vg1+2, vg1+3, vg1+4, vg1+5, vg1+6, vg1+7],
            // mid-rear (vertex groups 1 & 2)
            [vg1+0, vg2+0, vg2+1, vg1+1],
            [vg1+1, vg2+1, vg2+2, vg1+2],
            [vg1+3, vg2+3, vg2+4, vg1+4],
            [vg1+4, vg2+4, vg2+5, vg1+5],
            [vg1+5, vg2+5, vg2+6, vg1+6],
            [vg1+6, vg2+6, vg2+7, vg1+7],
            [vg1+7, vg2+7, vg2+0, vg1+0],
            // mid-front (vertex groups 2 & 3)
            [vg2+0, vg3+0, vg3+1, vg2+1],
            [vg2+4, vg3+2, vg3+3, vg2+5],
            [vg2+6, vg3+3, vg3+0, vg2+7],
            [vg2+1, vg3+1, vg2+2],
            [vg2+3, vg3+2, vg2+4],
            [vg2+5, vg3+3, vg2+6],
            [vg2+7, vg3+0, vg2+0],
            // front (vertex groups 3 & 4)
            [vg3+0, vg4+0, vg3+1],
            [vg3+2, vg4+1, vg3+3],
            [vg3+3, vg4+1, vg4+0, vg3+0],
        ]
    );
}

module horizontal_stabiliser(ss) {
    /*
    root towards viewer;
    [0, 0, 0] = average of max width, length, height;
    faces:
        1 octagon    (vertical, rear)
        1 hexagon    (horizontal, top)
        2 parallelograms (rear front & rear)
        2 trapezoids (bottom)
        6 triangles (rear & front)
    args:
        ss = sign of slant (-1 or +1)
    */
    xo2 = ss*HSTW1/(HSTW1+HSTW2)*HSTSL;
    xo3 = ss*HSTSL;
    x1a = HSTL1/(2+2*sqrt(2));
    x1b = HSTL1/2;
    x2  = HSTL2/2;
    x3  = HSTL3/2;
    //
    y1 = -HSTW1/2;
    y2 =  HSTW1/2;
    y3 =  HSTW1/2+HSTW2;
    //
    z1a = x1a*HSTT1/HSTL1;
    z2a = x1b*HSTT1/HSTL1;
    z3a = HSTT1/2-HSTT2;
    z3b =  HSTT1/2;
    //
    // indexes of vertex groups (rear to front)
    vg1 =  0;
    vg2 =  8;
    vg3 = 12;
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
            [xo2-x2, y2, z3a],
            [xo2-x2, y2, z3b],
            [xo2+x2, y2, z3b],
            [xo2+x2, y2, z3a],
            // front (12-13)
            [xo3-x3, y3, z3b],
            [xo3+x3, y3, z3b],
        ],
        [
            // entire top
            [vg1+2, vg2+1, vg2+4, vg2+5, vg2+2, vg1+3],
            // rear
            [vg1+0, vg1+1, vg1+2, vg1+3, vg1+4, vg1+5, vg1+6, vg1+7],
            // middle
            [vg1+0, vg2+0, vg2+1, vg1+1],
            [vg1+4, vg2+2, vg2+3, vg1+5],
            [vg1+6, vg2+3, vg2+0, vg1+7],
            [vg1+1, vg2+1, vg1+2],
            [vg1+3, vg2+2, vg1+4],
            [vg1+5, vg2+3, vg1+6],
            [vg1+7, vg2+0, vg1+0],
            // front
            [vg2+0, vg2+3, vg3+1, vg2+4],
            [vg2+0, vg2+4, vg2+1],
            [vg2+2, vg3+1, vg2+3],
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
