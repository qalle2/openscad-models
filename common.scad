/*
Basic shapes and a demo at the end.
Max width = max length = max height = 1.
All shapes are centred at [0, 0, 0].
Always base towards viewer.
*/

module tri_wedge(fw=1, fx=0, fz=0) {
    // triangular wedge;
    // args: front width, front X/Z offset
    a =  1/2;
    f = fw/2;
    polyhedron(
        [
            // rear
            [-a, -a, -a],
            [ 0, -a,  a],
            [ a, -a, -a],
            // front
            [fx-f,  a, fz],
            [fx+f,  a, fz],
        ],
        [
            [0, 1, 2],
            [0, 3, 1],
            [1, 3, 4],
            [1, 4, 2],
            [2, 4, 3],
            [2, 3, 0],
        ]
    );
}

module tri_pyramid(fx=0, fz=0) {
    // triangular pyramid (tetrahedron);
    // args: front X/Z offset
    tri_wedge(0, fx, fz);
}

module tri_frustum(fs, fx=0, fz=0) {
    // frustum of triangular pyramid (tetrahedron);
    // args: front scale factor, front X/Z offset
    a =  1/2;
    f = fs/2;
    polyhedron(
        [
            // rear
            [  -a, -a,   -a],
            [   0, -a,    a],
            [   a, -a,   -a],
            // front
            [fx-f,  a, fz-f],
            [fx,    a, fz+f],
            [fx+f,  a, fz-f],
        ],
        [
            [0,3,4,1],  // top left
            [1,4,5,2],  // top right
            [2,5,3,0],  // bottom
            [0,1,2],    // rear
            [3,5,4],    // front
        ]
    );
}

module tri_prism(fx=0, fz=0) {
    // triangular prism;
    // args: front X/Z offset
    tri_frustum(1, fx, fz);
}

module right_tri_wedge(fw=1, fx=0, fz=0) {
    // right triangular wedge;
    // args: front width, front X/Z offset
    a =  1/2;
    f = fw/2;
    polyhedron(
        [
            // rear
            [  -a, -a, -a],
            [  -a, -a,  a],
            [   a, -a, -a],
            // front
            [fx-f,  a, fz],
            [fx+f,  a, fz],
        ],
        [
            [2,4,3,0],  // bottom
            [1,3,4],    // top
            [0,1,2],    // rear
            [0,3,1],    // left
            [1,4,2],    // right
        ]
    );
}

module right_tri_pyramid(fx=0, fz=0) {
    // triangular pyramid (tetrahedron); base is right triangle;
    // args: front X/Z offset
    right_tri_wedge(0, fx, fz);
}

module right_tri_frustum(fs, fx=0, fz=0) {
    // frustum of right triangular pyramid;
    // args: front scale factor, front X/Z offset
    a =  1/2;
    f = fs/2;
    polyhedron(
        [
            // rear
            [  -a, -a,   -a],
            [  -a, -a,    a],
            [   a, -a,   -a],
            // front
            [fx-f,  a, fz-f],
            [fx-f,  a, fz+f],
            [fx+f,  a, fz-f],
        ],
        [
            [0,3,4,1],  // top left
            [1,4,5,2],  // top right
            [2,5,3,0],  // bottom
            [0,1,2],    // rear
            [3,5,4],    // front
        ]
    );
}

module right_tri_prism(fx=0, fz=0) {
    // right triangular prism;
    // args: front X/Z offset
    right_tri_frustum(1, fx, fz);
}

module rect_to_right_tri(fx=0, fz=0) {
    // rear face is rectangle, front face is right triangle;
    // args: front X/Z offset
    a = 1/2;
    polyhedron(
        [
            // rear
            [  -a, -a,   -a],
            [  -a, -a,    a],
            [   a, -a,    a],
            [   a, -a,   -a],
            // front
            [fx-a,  a, fz-a],
            [fx-a,  a, fz+a],
            [fx+a,  a, fz-a],
        ],
        [
            [0,1,2,3],  // rear
            [0,3,6,4],  // bottom
            [0,4,5,1],  // left
            [4,6,5],    // front
            [1,5,2],    // top
            [2,6,3],    // right
            [2,5,6],    // top front right
        ]
    );
}

module rect_frustum(fw=1, fh=1, fx=0, fz=0) {
    // frustum of rectangular pyramid;
    // args: front width/height, front X/Z offset
    a = 1/2;
    b = fw/2;
    c = fh/2;
    polyhedron(
        [
            // rear
            [  -a, -a,   -a],
            [  -a, -a,    a],
            [   a, -a,    a],
            [   a, -a,   -a],
            // front
            [fx-b,  a, fz-c],
            [fx-b,  a, fz+c],
            [fx+b,  a, fz+c],
            [fx+b,  a, fz-c],
        ],
        [
            [0,1,2,3],  // rear
            [4,7,6,5],  // front
            [1,5,6,2],  // top
            [3,7,4,0],  // bottom
            [0,4,5,1],  // left
            [2,6,7,3],  // right
        ]
    );
}

module rect_pyramid(fx=0, fz=0) {
    // square pyramid;
    // args: front X/Z offset
    rect_frustum(0, 0, fx, fz);
}

module rect_wedge(fw=1, fx=0, fz=0) {
    // square wedge;
    // args: front width, front X/Z offset
    rect_frustum(fw, 0, fx, fz);
}

module rect_prism(fx=0, fz=0) {
    // square prism;
    // args: front X/Z offset
    rect_frustum(1, 1, fx, fz);
}

module trapez_wedge(ts=1, fw=1, fx=0, fz=0) {
    // trapezoidal wedge;
    // args: top scale factor, front width, front X/Z offset
    a =  1/2;
    b = ts/2;
    c = fw/2;
    polyhedron(
        [
            // rear
            [  -a, -a, -a],
            [  -b, -a,  a],
            [   b, -a,  a],
            [   a, -a, -a],
            // front
            [fx-c,  a, fz],
            [fx+c,  a, fz],
        ],
        [
            [0,1,2,3],  // rear
            [1,4,5,2],  // top
            [0,3,5,4],  // bottom
            [0,4,1],    // left
            [2,5,3],    // right
        ]
    );
}

module trapez_pyramid(ts=1, fx=0, fz=0) {
    // trapezoidal pyramid;
    // args: top scale factor, front X/Z offset
    trapez_wedge(ts, 0, fx, fz);
}

module trapez_frustum(ts=1, fs=1, fx=0, fz=0) {
    // frustum of trapezoidal pyramid;
    // args: top scale factor, front scale factor, front X/Z offset
    a =     1/2;
    b =    ts/2;
    c =    fs/2;
    d = ts*fs/2;
    polyhedron(
        [
            // rear
            [  -a, -a,   -a],
            [  -b, -a,    a],
            [   b, -a,    a],
            [   a, -a,   -a],
            // front
            [fx-c,  a, fz-c],
            [fx-d,  a, fz+c],
            [fx+d,  a, fz+c],
            [fx+c,  a, fz-c],
        ],
        [
            [0,1,2,3],  // rear
            [4,7,6,5],  // front
            [1,5,6,2],  // top
            [3,7,4,0],  // bottom
            [0,4,5,1],  // left
            [2,6,7,3],  // right
        ]
    );
}

module trapez_prism(ts=1, fx=0, fz=0) {
    // trapezoidal prism;
    // args: top scale factor, front X/Z offset
    trapez_frustum(ts, 1, fx, fz);
}

module trapez_frustum2(rtw=1, fbw=1, ftw=1, fh=1, fx=0, fz=0) {
    /*
    frustum of trapezoidal pyramid;
    front aspect ratio may differ from rear;
    args:
        rtw     = rear top width
        fbw/ftw = front bottom/top width
        fh      = front height
        fx/fz   = front X/Z offset
    */
    a =   1/2;
    b = rtw/2;
    c = fbw/2;
    d = ftw/2;
    e =  fh/2;
    polyhedron(
        [
            // rear
            [  -a, -a,   -a],
            [  -b, -a,    a],
            [   b, -a,    a],
            [   a, -a,   -a],
            // front
            [fx-c,  a, fz-e],
            [fx-d,  a, fz+e],
            [fx+d,  a, fz+e],
            [fx+c,  a, fz-e],
        ],
        [
            [0,1,2,3],  // rear
            [4,7,6,5],  // front
            [1,5,6,2],  // top
            [3,7,4,0],  // bottom
            [0,5,1],    // left top
            [0,4,5],    // left bottom
            [2,6,3],    // right top
            [3,6,7],    // right bottom
        ]
    );
}

module hex_to_rect(fw=(sqrt(7)-1)/3, fh=1/2, fx=0, fz=0) {
    // rear face is hexagon, front face is rectangle;
    // args: front width/height, front X/Z offset
    a = 1/2;
    b = (sqrt(7)-1)/6;
    c = fw/2;
    d = fh/2;
    polyhedron(
        [
            // rear (0-5)
            [  -a, -a,    0],
            [  -b, -a,    a],
            [   b, -a,    a],
            [   a, -a,    0],
            [   b, -a,   -a],
            [  -b, -a,   -a],
            // front (6-9)
            [fx-c,  a, fz-d],
            [fx-c,  a, fz+d],
            [fx+c,  a, fz+d],
            [fx+c,  a, fz-d],
        ],
        [
            [0,1,2,3,4,5],  // rear
            [6,9,8,7],      // front
            [1,7,8,2],      // top
            [4,9,6,5],      // bottom
            [0,7,1],        // top left
            [2,8,3],        // top right
            [3,8,9],        // right
            [3,9,4],        // bottom right
            [5,6,0],        // bottom left
            [0,6,7],        // left
        ]
    );
}

module hex_pyramid(fx=0, fz=0) {
    // hexagonal pyramid;
    // args: front X/Z offset
    hex_to_rect(0, 0, fx, fz);
}

module hex_wedge(fw=1, fx=0, fz=0) {
    // hexagonal wedge;
    // args: front width, front X/Z offset
    hex_to_rect(fw, 0, fx, fz);
}

module hex_frustum(fs, fx=0, fz=0) {
    // frustum of hexagonal pyramid;
    // args: front scale factor, front X/Z offset
    a =  1/2;
    b =  (sqrt(7)-1)/6;
    c = fs/2;
    d = fs*(sqrt(7)-1)/6;
    polyhedron(
        [
            // rear
            [  -a, -a,    0],
            [  -b, -a,    a],
            [   b, -a,    a],
            [   a, -a,    0],
            [   b, -a,   -a],
            [  -b, -a,   -a],
            // front
            [fx-c,  a, fz  ],
            [fx-d,  a, fz+c],
            [fx+d,  a, fz+c],
            [fx+c,  a, fz  ],
            [fx+d,  a, fz-c],
            [fx-d,  a, fz-c],
        ],
        [
            [0, 1, 2, 3, 4, 5],  // rear
            [6,11,10, 9, 8, 7],  // front
            [0, 6, 7, 1],      // top    left
            [1, 7, 8, 2],      // top
            [2, 8, 9, 3],      // top    right
            [0, 5,11, 6],      // bottom left
            [4,10,11, 5],      // bottom
            [3, 9,10, 4],      // bottom right
        ]
    );
}

module hex_prism(fx=0, fz=0) {
    // hexagonal prism;
    // args: front X/Z offset
    hex_frustum(1, fx, fz);
}

module rect_cupola(fw, fh, fx=0, fz=0) {
    // rear face is octagon, front face is rectangle;
    // args: front width/height, front X/Z offset
    a =  1/2;
    b =  1/(2+2*sqrt(2));
    x = fw/2;
    z = fh/2;
    polyhedron(
        [
            // rear
            [  -a, -a,   -b],
            [  -a, -a,    b],
            [  -b, -a,    a],
            [   b, -a,    a],
            [   a, -a,    b],
            [   a, -a,   -b],
            [   b, -a,   -a],
            [  -b, -a,   -a],
            // front
            [fx-x,  a, fz-z],
            [fx-x,  a, fz+z],
            [fx+x,  a, fz+z],
            [fx+x,  a, fz-z],
        ],
        [
            [0, 1, 2,3,4,5,6,7],  // rear
            [8,11,10,9],          // front
            [0, 8, 9,1],          //        left
            [2, 9,10,3],          // top
            [4,10,11,5],          //        right
            [6,11, 8,7],          // bottom
            [1, 9, 2],            // top    left
            [3,10, 4],            // top    right
            [5,11, 6],            // bottom right
            [7, 8, 0],            // bottom left
        ]
    );
}

module oct_pyramid(fx=0, fz=0) {
    // octagonal pyramid;
    // args: front X/Z offset
    rect_cupola(0, 0, fx, fz);
}

module oct_wedge(fw=1, fx=0, fz=0) {
    // octagonal wedge;
    // args: front width, front X/Z offset
    rect_cupola(fw, 0, fx, fz);
}

module oct_frustum(fs, fx=0, fz=0) {
    // frustum of octagonal pyramid;
    // args: front scale factor, front X/Z offset
    a  = 1/2;
    b =  1/(2+2*sqrt(2));
    c = fs/2;
    d = fs/(2+2*sqrt(2));
    polyhedron(
        [
            // rear
            [  -a, -a,   -b],
            [  -a, -a,    b],
            [  -b, -a,    a],
            [   b, -a,    a],
            [   a, -a,    b],
            [   a, -a,   -b],
            [   b, -a,   -a],
            [  -b, -a,   -a],
            // front
            [fx-c,  a, fz-d],
            [fx-c,  a, fz+d],
            [fx-d,  a, fz+c],
            [fx+d,  a, fz+c],
            [fx+c,  a, fz+d],
            [fx+c,  a, fz-d],
            [fx+d,  a, fz-c],
            [fx-d,  a, fz-c],
        ],
        [
            [ 0, 1, 2, 3, 4, 5, 6, 7],  // rear
            [15,14,13,12,11,10, 9, 8],  // front
            [ 0, 8, 9, 1],  // left
            [ 1, 9,10, 2],  // top left
            [ 2,10,11, 3],  // top
            [ 3,11,12, 4],  // top right
            [ 4,12,13, 5],  // right
            [ 5,13,14, 6],  // bottom right
            [ 6,14,15, 7],  // bottom
            [ 7,15, 8, 0],  // bottom left
        ]
    );
}

module oct_prism(fx=0, fz=0) {
    // octagonal prism;
    // args: front X/Z offset
    oct_frustum(1, fx, fz);
}

module oct_frustum2(fw, fh, fx=0, fz=0) {
    // frustum of octagonal pyramid;
    // front aspect ratio may differ from rear;
    // args: front width/height, front X/Z offset
    a  = 1/2;
    b =  1/(2+2*sqrt(2));
    c = fw/2;
    d = fw/(2+2*sqrt(2));
    e = fh/2;
    f = fh/(2+2*sqrt(2));
    polyhedron(
        [
            // rear (0-7)
            [  -a, -a,   -b],
            [  -a, -a,    b],
            [  -b, -a,    a],
            [   b, -a,    a],
            [   a, -a,    b],
            [   a, -a,   -b],
            [   b, -a,   -a],
            [  -b, -a,   -a],
            // front (8-15)
            [fx-c,  a, fz-f],
            [fx-c,  a, fz+f],
            [fx-d,  a, fz+e],
            [fx+d,  a, fz+e],
            [fx+c,  a, fz+f],
            [fx+c,  a, fz-f],
            [fx+d,  a, fz-e],
            [fx-d,  a, fz-e],
        ],
        [
            [ 0, 1, 2, 3, 4, 5, 6, 7],  // rear
            [ 8,15,14,13,12,11,10, 9],  // front
            [ 0, 8, 9, 1],  // left
            [ 1, 9, 2],     // left top
            [ 2, 9,10],     // top left
            [ 2,10,11, 3],  // top
            [ 3,11,12],     // top right
            [ 3,12, 4],     // right top
            [ 4,12,13, 5],  // right
            [ 6,13,14],     // bottom right
            [ 5,13, 6],     // right bottom
            [ 6,14,15, 7],  // bottom
            [ 0, 7, 8],     // left bottom
            [ 7,15, 8],     // bottom left
        ]
    );
}

module aircraft_wing(l1, l2, l3, w1, w2, w3, t1, hs=0, vs=0) {
    /*
    an aircraft wing;
    root towards viewer;
    args:
        l1...l3 = length       (inner to outer)
        w1...w3 = width        (inner to outer)
        t1      = thickness    (inner)
        hs, vs  = slant of middle & outer sections (horizontal, vertical)
    */
    l2r = l2/(l2+l3);
    l3r = l3/(l2+l3);
    // inner
    translate([0, (-l2-l3)/2, 0]) {
        scale([w1, l1, t1]) hex_prism();
    }
    // middle
    translate([0, (l1-l3)/2, 0]) {
        scale([w1, l2, t1]) hex_to_rect(w2/w1, l3r, l2r*hs/w1, l2r*vs/t1);
    }
    // outer
    translate([l2r*hs, (l1+l2)/2, l2r*vs]) {
        scale([w2, l3, l3r*t1]) rect_wedge(w3/w2, l3r*hs/w2, vs/t1);
    }
}

module aircraft_stabiliser(l1, l2, w1, w2, w3, t1, hs=0, vs=0) {
    /*
    an aircraft stabiliser;
    like the mid and outer sections of the wing;
    root towards viewer;
    args:
        l1, l2  = length    (inner, outer)
        w1...w3 = width     (inner to outer)
        t1      = thickness (inner)
        hs, vs  = slant     (horizontal, vertical)
    */
    l1r = l1/(l1+l2);
    l2r = l2/(l1+l2);
    // inner
    translate([0, -l2/2, 0]) {
        scale([w1, l1, t1]) hex_to_rect(w2/w1, l2r, l1r*hs/w1, l1r*vs/t1);
    }
    // outer
    translate([l1r*hs, l1/2, l1r*vs]) {
        scale([w2, l2, l2r*t1]) rect_wedge(w3/w2, l2r*hs/w2, vs/t1);
    }
}

module aircraft_propeller(hl, hr, bl, bw, bt, bc) {
    /*
    an aircraft propeller;
    args:
        hl, hr         = hub   length, radius
        bl, bw, bt, bc = blade length, width, thickness, count
    */
    // hub (base is regular hexagon)
    scale([hr*2, hl, hr*sqrt(3)]) hex_frustum(1/2);
    // blades
    for(i = [0:bc-1]) rotate([0, 30+i*(360/bc), 0]) {
        translate([bl/2, 0, 0]) rotate([0, 45, -90]) {
            scale([bw, bl, bt]) hex_wedge(1/2);
        }
    }
}

// demo (derived objects in orange)
DER = [1, .5, 0];
scale(100) {
    translate([ 4, 0,  6]) color(DER) tri_pyramid();
    translate([ 2, 0,  6])            tri_wedge(1/2);
    translate([-2, 0,  6]) color(DER) tri_prism();
    translate([-4, 0,  6])            tri_frustum(1/2);

    translate([ 4, 0,  4]) color(DER) right_tri_pyramid();
    translate([ 2, 0,  4])            right_tri_wedge(1/2);
    translate([-2, 0,  4]) color(DER) right_tri_prism();
    translate([-4, 0,  4])            right_tri_frustum(1/2);

    translate([ 4, 0,  2]) color(DER) rect_pyramid();
    translate([ 2, 0,  2]) color(DER) rect_wedge(1/2);
    translate([ 0, 0,  2])            rect_to_right_tri();
    translate([-2, 0,  2]) color(DER) rect_prism();
    translate([-4, 0,  2])            rect_frustum(1/2, 1/2);

    translate([ 4, 0,  0]) color(DER) trapez_pyramid(1/2);
    translate([ 2, 0,  0])            trapez_wedge(1/2, 1/2);
    translate([-2, 0,  0]) color(DER) trapez_prism(1/2);
    translate([-4, 0,  0])            trapez_frustum(1/2, 1/2);
    translate([-6, 0,  0])            trapez_frustum2(2/3, 1/2, 1/4, 1/2);

    translate([ 4, 0, -2]) color(DER) hex_pyramid();
    translate([ 2, 0, -2]) color(DER) hex_wedge(1/2);
    translate([ 0, 0, -2])            hex_to_rect();
    translate([-2, 0, -2]) color(DER) hex_prism();
    translate([-4, 0, -2])            hex_frustum(1/2);

    translate([ 4, 0, -4]) color(DER) oct_pyramid();
    translate([ 2, 0, -4]) color(DER) oct_wedge(1/2);
    translate([ 0, 0, -4])            rect_cupola(1/2, 1/2);
    translate([-2, 0, -4]) color(DER) oct_prism();
    translate([-4, 0, -4])            oct_frustum(1/2);
    translate([-6, 0, -4])            oct_frustum2(1/3, 1/2);

    translate([ 5, 0, -6]) color(DER) aircraft_wing(1, 5, 1, 5, 3, 1, 1);
    translate([ 0, 0, -6]) color(DER) aircraft_stabiliser(3, 1, 3, 2, 1, 1);
    translate([-5, 0, -6]) color(DER) aircraft_propeller(1, 1, 2, 1/2, 1/4, 2);

}
