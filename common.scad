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
            [-a, -a, -a],
            [-a, -a,  a],
            [ a, -a,  a],
            [ a, -a, -a],
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

// demo (derived objects in orange)
DER = [1, .5, 0];
scale(100) {
    translate([ 3, 0,  4]) color(DER) tri_pyramid();
    translate([ 1, 0,  4])            tri_wedge(1/2);
    translate([-3, 0,  4]) color(DER) tri_prism();
    translate([-5, 0,  4])            tri_frustum(1/2);

    translate([ 3, 0,  2]) color(DER) right_tri_pyramid();
    translate([ 1, 0,  2])            right_tri_wedge(1/2);
    translate([-3, 0,  2]) color(DER) right_tri_prism();
    translate([-5, 0,  2])            right_tri_frustum(1/2);

    translate([ 3, 0,  0]) color(DER) rect_pyramid();
    translate([ 1, 0,  0]) color(DER) rect_wedge(1/2);
    translate([-1, 0,  0])            rect_to_right_tri();
    translate([-3, 0,  0]) color(DER) rect_prism();
    translate([-5, 0,  0])            rect_frustum(1/2, 1/2);

    translate([ 3, 0, -2]) color(DER) hex_pyramid();
    translate([ 1, 0, -2]) color(DER) hex_wedge(1/2);
    translate([-1, 0, -2])            hex_to_rect();
    translate([-3, 0, -2]) color(DER) hex_prism();
    translate([-5, 0, -2])            hex_frustum(1/2);

    translate([ 3, 0, -4]) color(DER) oct_pyramid();
    translate([ 1, 0, -4]) color(DER) oct_wedge(1/2);
    translate([-1, 0, -4])            rect_cupola(1/2, 1/2);
    translate([-3, 0, -4]) color(DER) oct_prism();
    translate([-5, 0, -4])            oct_frustum(1/2);
}
