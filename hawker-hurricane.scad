/* Hawker Hurricane;
every module is centered at [0, 0, 0] */

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
WIT1 = 70;
WIW2 = 620;
WIL2 = 190;
WIW3 = 80;
WIL3 = 80;

/*
cockpit; parts:
    1. front     (windshield)
    2. mid-front (side windows)
    3. mid-rear  (unglazed)
    4. rear      (unglazed)
*/
COW1 = FBW2;    // bottom
COW2 = FBW2/3;  // top
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
HSTL2 =  120;
HSTL3 =   60;
HSTSL =   10;  // horizontal slant from centerline

// vertical stabiliser (L=length=Y, H=height=Z, T=thickness=X)
VSTL1 = FUL4;    // bottom
VSTL2 = FUL4/3;  // top
VSTH1 = 170;     // rear
VSTH2 = 125;     // front
VSTT  = FUW4;

// rudder (L=length=Y, H=height=Z, T=thickness=X)
RUL  = 80;                  // length
RUH1 = FUH4+VSTH1;          // height 1 (front)
RUH2 = FUH4-VSTH1+2*VSTH2;  // height 2 (rear)
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
    color(FUC) fuselage(FUA, FUW4, FUL1, FUL2, FUL3, FUL4, FUH1, FUH2, FUH3, FUH4, FUVS3*FUH2);
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
            rotate(-x*90) wing(WIL1, WIL2, WIL3, WIW1, WIW2, WIW3, WIT1);
        }
    }
    // stabilisers and rudder
    color(PLC) translate([0, (-FUL1-FUL2-FUL3)/2, FUVS3*FUH2]) {
        // horizontal stabilisers
        for(x = [-1, 1]) translate([x*(FUW4+HSTW1+HSTW2)/2, 0, 0]) {
            rotate(-x*90) horizontal_stabiliser(HSTL1, HSTL2, HSTL3, HSTW1, HSTW2, HSTT1, x*HSTSL);
        }
        // vertical stabiliser
        translate([0, 0, (FUH4+VSTH1)/2]) {
            vertical_stabiliser(VSTT, VSTL1, VSTL2, VSTH1, VSTH2);
        }
        // rudder
        translate([0, (-FUL4-RUL)/2, (RUH1-FUH4)/2]) {
            rudder(RUT, RUL, RUH1, RUH2);
        }
    }
    // propeller
    color(OTC) translate([0, (FUL1+FUL2+FUL3+FUL4+PHL)/2, 0]) {
        rotate([0, 30, 0]) propeller(PHL, PHR, PBL, PBW, PBT);
    }
}

hurricane();

module fuselage(whr, w4, l1, l2, l3, l4, h1, h2, h3, h4, vs3) {
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
    z0a = -h4/2             + vs3;
    z0b =  h4/2             + vs3;
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
            [ -x1, y1, z0a],
            [ -x1, y1, z0b],
            [  x1, y1, z0b],
            [  x1, y1, z0a],
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
    args:
        w1, w2a, w2b = width  at rear, front bottom, front top
        l1, l2       = length at rear, front
        h1, h2       = height at rear, front
    */
    x1  = w1/2;
    x2a = w2a/2;
    x2b = w2b/2;
    //
    y1 = (-l1-l2)/2;
    y2 = ( l1-l2)/2;
    y3 = ( l1+l2)/2;
    //
    z1 = -h1/2;
    z2 =  h1/2-h2;
    z3 =  h1/2;
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
            [0,3,4,1],  // rear  top
            [0,1,5,2],  // rear  bottom
            [0,2,3],    // rear  left
            [1,4,5],    // rear  right
            [3,7,8,4],  // front top
            [2,5,9,6],  // front bottom
            [2,6,7,3],  // front left
            [4,8,9,5],  // front right
            [6,9,8,7],  // front
        ]
    );
}

module cockpit_fronthalf(w1, w2, l1, l2, h) {
    /*
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
            [0,3,7,9,8,4], // bottom
            [0,1,2,3],     // rear
            [0,4,5,1],     // rear left
            [2,6,7,3],     // rear right
            [1,5,6,2],     // top
            [5,8,9,6],     // front center
            [4,8,5],       // front left
            [6,9,7],       // front right
        ]
    );
}

module wing(w1, w2, w3, l1, l2, l3, t1) {
    /*
    root towards viewer;
    args:
        w1...w3 = width     (inner to outer)
        l1...l3 = length    (inner to outer)
        t1      = thickness (inner)
    */
    x1 = w1/2;
    x2 = w2/2;
    x3 = w3/2;
    //
    y1 = (-l1-l2-l3)/2;
    y2 = ( l1-l2-l3)/2;
    y3 = ( l1+l2-l3)/2;
    y4 = ( l1+l2+l3)/2;
    //
    z1 = t1/2;
    z2 = z1-l3/(l2+l3)*t1;
    //
    polyhedron(
        [
            // rear (0-5)
            [-x1, y1,   0],
            [-x2, y1,  z1],
            [ x2, y1,  z1],
            [ x1, y1,   0],
            [ x2, y1, -z1],
            [-x2, y1, -z1],
            // mid-rear (6-11)
            [-x1, y2,   0],
            [-x1, y2,   0],
            [ x1, y2,   0],
            [ x1, y2,   0],
            [ x2, y2, -z1],
            [-x2, y2, -z1],
            // mid-front (12-15)
            [-x2, y3,  z2],
            [-x2, y3,  z1],
            [ x2, y3,  z1],
            [ x2, y3,  z2],
            // front (16-17)
            [-x3, y4,  z1],
            [ x3, y4,  z1],
        ],
        [
            [ 0, 1, 2, 3, 4, 5],  // rear
            [ 1,13,16,17,14, 2],  // top
            [10,15,17,16,12,11],  // bottom front
            [ 0, 6,13, 1],  // top left
            [ 2,14, 8, 3],  // top right
            [ 3, 8,10, 4],  // rear bottom right
            [ 4,10,11, 5],  // rear bottom
            [ 5,11, 6, 0],  // rear bottom left
            [ 6,12,13],     // mid left
            [ 8,14,15],     // mid right
            [ 8,15,10],     // mid bottom right
            [11,12, 6],     // mid bottom left
            [12,16,13],     // front left
            [14,17,15],     // front right
        ]
    );
}

module horizontal_stabiliser(w1, w2, w3, l1, l2, t1, hs=0) {
    /*
    root towards viewer;
    args:
        w1...w3 = width     (inner to outer)
        l1...l2 = length    (inner to outer)
        t1      = thickness (inner)
        hs      = horizontal slant
    */
    xo1 = l1/(l1+l2)*hs;
    xo2 = hs;
    x1  = w1/2;
    x2  = w2/2;
    x3  = w3/2;
    //
    y1 = (-l1-l2)/2;
    y2 = ( l1-l2)/2;
    y3 = ( l1+l2)/2;
    //
    z1  = x1*t1/w1;
    z2a = t1/2-l2/(l1+l2)*t1;
    z2b = t1/2;
    //
    polyhedron(
        [
            // rear
            [   -x1, y1,   0],
            [   -x2, y1,  z1],
            [    x2, y1,  z1],
            [    x1, y1,   0],
            [    x2, y1, -z1],
            [   -x2, y1, -z1],
            // mid
            [xo1-x2, y2, z2a],
            [xo1-x2, y2, z2b],
            [xo1+x2, y2, z2b],
            [xo1+x2, y2, z2a],
            // front
            [xo2-x3, y3, z2b],
            [xo2+x3, y3, z2b],
        ],
        [
            [0, 1, 2, 3, 4, 5],  //        rear
            [1, 7,10,11, 8, 2],  // top
            [4, 9,11,10, 6, 5],  // bottom
            [0, 7, 1],           // top    rear  left
            [2, 8, 3],           // top    rear  right
            [3, 9, 4],           // bottom rear  right
            [5, 6, 0],           // bottom rear  left
            [0, 6, 7],           //        rear  left
            [3, 8, 9],           //        rear  right
            [6,10, 7],           //        front left
            [8,11, 9],           //        front right
        ]
    );
}

module vertical_stabiliser(w, l1, l2, h1, h2) {
    /*
    root towards viewer;
    args:
        w      = width
        l1, l2 = length (bottom, top)
        h1, h2 = height (rear, front)
    */
    x = w/2;
    //
    y1 = -l1/2;
    y2 = -l1/2+l2;
    y3 =  l2/2;
    y4 =  l1/2;
    //
    z1 = -h1/2;
    z2 = -h1/2+h2;
    z3 =  h1/2;
    //
    polyhedron(
        [
            // rear (0-4)
            [-x, y1, z1],
            [-x, y1, z2],
            [ 0, y1, z3],
            [ x, y1, z2],
            [ x, y1, z1],
            // mid-rear (5-7)
            [-x, y2, z2],
            [ 0, y2, z3],
            [ x, y2, z2],
            // mid-front (8-10)
            [-x, y3, z1],
            [ x, y3, z1],
            [ 0, y3, z2],
            // front (11)
            [ 0, y4, z1],
        ],
        [
            [0, 4, 9,11, 8],  // bottom
            [0, 1, 2, 3, 4],  //        rear
            [0, 8, 5, 1],     // bottom rear  left
            [3, 7, 9, 4],     // bottom rear  right
            [5, 8,11,10],     // bottom front left
            [7,10,11, 9],     // bottom front right
            [1, 5, 6, 2],     // top    rear  left
            [2, 6, 7, 3],     // top    rear  right
            [5,10, 6],        // top    front left
            [6,10, 7],        // top    front right
        ]
    );
}

module rudder(w, l, h1, h2) {
    /*
    args:
        w     = width
        l     = length
        h1/h2 = larger/smaller height
    */
    x  =  w/2;
    y  =  l/2;
    z1 = h1/2;
    z2 = h2/2;
    //
    polyhedron(
        [
            // rear (0-1)
            [ 0, -y, -z2],
            [ 0, -y,  z2],
            // front (2-6)
            [-x,  y, -z1],
            [-x,  y,  z2],
            [ 0,  y,  z1],
            [ x,  y,  z2],
            [ x,  y, -z1],
        ],
        [
            [2,6,5,4,3],  // front (root)
            [0,2,3,1],    // bottom left
            [0,1,5,6],    // bottom right
            [0,6,2],      // bottom
            [1,3,4],      // top    left
            [1,4,5],      // top    right
        ]
    );
}

module propeller(hl, hr, bl, bw, bt) {
    /*
    args:
        hl, hr     = hub    length, radius
        bl, bw, bt = bladde length, width, thickness
    */
    propeller_hub(hl, hr);
    for(x = [0, 1]) rotate([0, x*180, 0]) translate([bl/2, 0, 0]) {
        rotate([0, -45, -90]) propeller_blade(bl, bw, bt);
    }
}

module propeller_hub(l, r) {
    /*
    a square cupola; base towards viewer;
    args: length, radius
    */
    x = r/(1+1*sqrt(2));
    y = l/2;
    z = r/(1+1*sqrt(2));
    //
    polyhedron(
        [
            // rear (0-7)
            [-r, -y, -z],
            [-r, -y,  z],
            [-x, -y,  r],
            [ x, -y,  r],
            [ r, -y,  z],
            [ r, -y, -z],
            [ x, -y, -r],
            [-x, -y, -r],
            // front (8-11)
            [-x,  y, -z],
            [-x,  y,  z],
            [ x,  y,  z],
            [ x,  y, -z],
        ],
        [
            [0, 1, 2,3,4,5,6,7],  // rear
            [8,11,10,9],          // front
            // sides
            [0, 8, 9,1], [1, 9,2],
            [2, 9,10,3], [3,10,4],
            [4,10,11,5], [5,11,6],
            [6,11, 8,7], [7, 8,0],
        ]
    );
}

module propeller_blade(l, w, t) {
    /*
    a rectangular wedge; root towards viewer;
    args: length, width, thickness
    */
    x1 = w/2;
    x2 = w/4;
    y  = l/2;
    z  = t/2;
    //
    polyhedron(
        [
            // rear (0-3)
            [-x1, -y, -z],
            [-x1, -y,  z],
            [ x1, -y,  z],
            [ x1, -y, -z],
            // front (4-5)
            [-x2,  y,  0],
            [ x2,  y,  0],
        ],
        [
            [0,1,2,3],  // rear
            [0,3,5,4],  // bottom
            [1,4,5,2],  // top
            [0,4,1],    // left
            [2,5,3],    // right
        ]
    );
}
