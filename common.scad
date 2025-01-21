/*
Basic shapes and a demo at the end.
Max width = max length = max height = 1.
All shapes are centred at [0, 0, 0].
*/

module tetrahedron(fx=0, fz=0) {
    /*
    not regular;
    bottom towards viewer;
    faces:
        4 triangles
    args:
        fx, fz = front X/Z offset
    */
    a = 1/2;
    polyhedron(
        [
            // rear
            [-a, -a, -a],
            [ 0, -a,  a],
            [ a, -a, -a],
            // front
            [fx,  a, fz],
        ],
        [
            [0, 1, 2],
            [0, 2, 3],
            [0, 3, 1],
            [1, 3, 2],
        ]
    );
}

module tri_wedge(fw=1, fx=0, fz=0) {
    /*
    triangular wedge;
    faces:
        4 triangles (1 of them vertical and rear)
        1 trapezoid
    the front is a horizontal edge;
    args:
        fw     = front edge width
        fx, fz = front X/Z offset from centerline
    */
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

module tri_frustum(fs=1, fx=0, fz=0) {
    /*
    a frustum of a tetrahedron;
    (a triangular pyramid cut by a plane parallel to the base);
    base towards viewer;
    X & Z centering is based on rear face only;
    faces:
        2 triangles (vertical; front and rear)
        3 trapezoids
    args:
        fs     = front width/height scale factor
        fx, fz = front X/Z offset from centerline
    note: front face must have same width/height ratio as rear face;
    otherwise side faces would not be planes;
    note: default settings = triangular prism
    */
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
            [0, 1, 2],
            [3, 5, 4],
            [0, 3, 4, 1],
            [1, 4, 5, 2],
            [2, 5, 3, 0],

        ]
    );
}

module sixth_cube() {
    /*
    like a cube but 5/6 sliced away from top front right along 3 vertices;
    faces:
        3 isosceles right triangles (bottom, rear, left)
        1 equilateral     triangle  (top front right)
    */
    a = 1/2;
    polyhedron(
        [
            [-a, -a, -a],
            [ a, -a, -a],
            [-a,  a, -a],
            [-a, -a,  a],
        ],
        [
            [0, 1, 2],
            [0, 2, 3],
            [0, 3, 1],
            [1, 3, 2],
        ]
    );
}

module five_sixths_cube() {
    /*
    like a cube but 1/6 sliced away from top front right along 3 vertices;
    faces:
        3 squares                   (bottom, rear, left)
        3 isosceles right triangles (top, front, right)
        1 equilateral     triangle  (top front right)
    */
    a = 1/2;
    polyhedron(
        [
            [-a, -a, -a],
            [ a, -a, -a],
            [-a,  a, -a],
            [ a,  a, -a],
            [-a, -a,  a],
            [ a, -a,  a],
            [-a,  a,  a],
        ],
        [
            [0, 1, 3, 2],
            [0, 2, 6, 4],
            [0, 4, 5, 1],
            [1, 5, 3],
            [2, 3, 6],
            [3, 5, 6],
            [4, 6, 5],
        ]
    );
}

module square_pyramid(fx=0, fz=0) {
    /*
    faces:
        1 square (vertical, rear)
        4 triangles
    args:
        fx, fz = front X/Z offset from centerline
    */
    a = 1/2;
    polyhedron(
        [
            // rear
            [-a, -a, -a],
            [-a, -a,  a],
            [ a, -a,  a],
            [ a, -a, -a],
            // front
            [fx,  a, fz],
        ],
        [
            [0, 1, 2, 3],
            [0, 4, 1],
            [1, 4, 2],
            [2, 4, 3],
            [0, 3, 4],
        ]
    );
}

module wedge(fw=1, fx=0, fz=0) {
    /*
    faces:
        1 square (vertical, rear)
        2 trapezoids
        2 triangles
    the front is a horizontal edge;
    args:
        fw     = front edge width
        fx, fz = front X/Z offset from centerline
    */
    a =  1/2;
    f = fw/2;
    polyhedron(
        [
            // rear
            [  -a, -a, -a],
            [  -a, -a,  a],
            [   a, -a,  a],
            [   a, -a, -a],
            // front
            [fx-f,  a, fz],
            [fx+f,  a, fz],
        ],
        [
            [0, 1, 2, 3],
            [0, 4, 1],
            [1, 4, 5, 2],
            [2, 5, 3],
            [0, 3, 5, 4],
        ]
    );
}

module rect_frustum(fw=1, fh=1, fx=0, fz=0) {
    /*
    a frustum of a rectangular pyramid
    (a rectangular pyramid cut by a plane parallel to the base);
    base towards viewer;
    four of the faces are vertical;
    X & Z centering is based on rear face only;
    faces:
        2 rectangles (vertical; front and rear)
        4 trapezoids
    args:
        fw, fh = front width/height
        fx, fz = front X/Z offset from centerline
    */
    polyhedron(
        [
            // rear
            [   -1/2, -1/2,    -1/2],
            [   -1/2, -1/2,     1/2],
            [    1/2, -1/2,     1/2],
            [    1/2, -1/2,    -1/2],
            // front
            [fx-fw/2,  1/2, fz-fh/2],
            [fx-fw/2,  1/2, fz+fh/2],
            [fx+fw/2,  1/2, fz+fh/2],
            [fx+fw/2,  1/2, fz-fh/2],
        ],
        [
            [0, 1, 2, 3],
            [0, 4, 5, 1],
            [1, 5, 6, 2],
            [2, 6, 7, 3],
            [3, 7, 4, 0],
            [4, 7, 6, 5],
        ]
    );
}

module hex_pyramid(fx=0, fz=0) {
    /*
    args:
        fx, fz = front X/Z offset from centerline
    note: for a hexagon with width=height=1, the edge must be (sqrt(7)-1)/3
    */
    a = 1/2;
    b = (sqrt(7)-1)/6;
    polyhedron(
        [
            // rear
            [-a, -a,  0],
            [-b, -a,  a],
            [ b, -a,  a],
            [ a, -a,  0],
            [ b, -a, -a],
            [-b, -a, -a],
            // front
            [fx,  a, fz],
        ],
        [
            [0, 1, 2, 3, 4, 5],
            [0, 6, 1],
            [1, 6, 2],
            [2, 6, 3],
            [3, 6, 4],
            [4, 6, 5],
            [5, 6, 0],
        ]
    );
}

module hex_wedge(fw=(sqrt(7)-1)/3, fx=0, fz=0) {
    /*
    fw     = front width
             (default = smaller width of rear hexagon)
    fx, fz = front X/Z offset from centerline
    */
    a = 1/2;
    b = (sqrt(7)-1)/6;
    c = fw/2;
    polyhedron(
        [
            // rear
            [  -a, -a,  0],
            [  -b, -a,  a],
            [   b, -a,  a],
            [   a, -a,  0],
            [   b, -a, -a],
            [  -b, -a, -a],
            // front
            [fx-c,  a, fz],
            [fx+c,  a, fz],
        ],
        [
            [0,1,2,3,4,5],  // rear
            [1,6,7,2],      // top
            [4,7,6,5],      // bottom
            [0,6,1],        // top    left
            [2,7,3],        // top    right
            [3,7,4],        // bottom right
            [5,6,0],        // bottom left
        ]
    );
}

module hex_to_rect(fw=(sqrt(7)-1)/3, fh=1/2, fx=0, fz=0) {
    /*
    fw     = front width
             (default = smaller width of rear hexagon)
    fh     = front height
    fx, fz = front X/Z offset from centerline
    */
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

module hex_frustum(fs=(sqrt(7)-1)/3, fxo=0, fzo=0) {
    /*
    args:
        fs       = front scale factor
                   (default = smaller width of rear hexagon)
        fxo, fzo = front X/Z offset from centerline
    note: front face must have same width/height ratio as rear face;
    otherwise side faces would not be planes
    */
    a =  1/2;
    b =  (sqrt(7)-1)/6;
    c = fs/2;
    d = fs*(sqrt(7)-1)/6;
    polyhedron(
        [
            // rear
            [   -a, -a,     0],
            [   -b, -a,     a],
            [    b, -a,     a],
            [    a, -a,     0],
            [    b, -a,    -a],
            [   -b, -a,    -a],
            // front
            [fxo-c,  a, fzo  ],
            [fxo-d,  a, fzo+c],
            [fxo+d,  a, fzo+c],
            [fxo+c,  a, fzo  ],
            [fxo+d,  a, fzo-c],
            [fxo-d,  a, fzo-c],
        ],
        [
            [0, 1, 2,3,4,5],  // rear
            [6,11,10,9,8,7],  // front
            [0, 6, 7,1],  // top left
            [1, 7, 8,2],  // top
            [2, 8, 9,3],  // top right
            [0, 5,11,6],  // bottom left
            [4,10,11,5],  // bottom
            [3, 9,10,4],  // bottom right
        ]
    );
}

module oct_pyramid(fx=0, fz=0) {
    /*
    faces:
        1 regular octagon (vertical, rear)
        8 triangles
    args:
        fx, fz = front X/Z offset from centerline
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
            [fx,  b, fz],
        ],
        [
            [0, 1, 2, 3, 4, 5, 6, 7],
            [0, 8, 1],
            [1, 8, 2],
            [2, 8, 3],
            [3, 8, 4],
            [4, 8, 5],
            [5, 8, 6],
            [6, 8, 7],
            [0, 7, 8],
        ]
    );
}

module oct_wedge(fw=1/(1+1*sqrt(2)), fxo=0, fzo=0) {
    /*
    faces:
        1 regular octagon (vertical, rear)
        2 trapezoids
        6 isosceles triangles
    the front is a horizontal edge;
    args:
        fw       = front edge width
                   (default = smaller width of rear octagon)
        fxo, fzo = front X/Z offset from centerline
    */
    a =  1/(2+2*sqrt(2));  // small
    b =  1/2;              // big
    f = fw/2;              // front
    polyhedron(
        [
            // rear
            [   -b, -b,  -a],
            [   -b, -b,   a],
            [   -a, -b,   b],
            [    a, -b,   b],
            [    b, -b,   a],
            [    b, -b,  -a],
            [    a, -b,  -b],
            [   -a, -b,  -b],
            // front
            [fxo-f,  b, fzo],
            [fxo+f,  b, fzo],
        ],
        [
            [0, 1, 2, 3, 4, 5, 6, 7],
            [0, 8, 1],
            [1, 8, 2],
            [2, 8, 9, 3],
            [3, 9, 4],
            [4, 9, 5],
            [5, 9, 6],
            [6, 9, 8, 7],
            [0, 7, 8],
        ]
    );
}

module square_cupola(fw=1/(1+1*sqrt(2)), fh=1/(1+1*sqrt(2)), fxo=0, fzo=0) {
    /*
    rear: regular octagon, front: rectangle,
    connected by trapezoids and triangles;
    args:
        fw, fh   = front width/height
                   (default = smaller width&height of rear octagon)
        fxo, fzo = front X/Z offset from centerline
    */
    a =  1/2;
    b =  1/(2+2*sqrt(2));
    x = fw/2;
    z = fh/2;
    polyhedron(
        [
            // rear
            [   -a, -a,    -b],
            [   -a, -a,     b],
            [   -b, -a,     a],
            [    b, -a,     a],
            [    a, -a,     b],
            [    a, -a,    -b],
            [    b, -a,    -a],
            [   -b, -a,    -a],
            // front
            [fxo-x,  a, fzo-z],
            [fxo-x,  a, fzo+z],
            [fxo+x,  a, fzo+z],
            [fxo+x,  a, fzo-z],
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

module oct_frustum(fs=1/(1+1*sqrt(2)), fxo=0, fzo=0) {
    /*
    a frustum of an octagonal pyramid;
    X & Z centring doesn't depend on fx & fz;
    base towards viewer;
    faces:
        2 regular octagons (vertical; front and rear)
        8 trapezoids
    args:
        fs       = front width & height scale factor
                   (default = smaller width & height of rear octagon)
        fxo, fzo = front X/Z offset from centreline
    note: front face must have same width/height ratio as rear face;
    otherwise side faces would not be planes
    */
    a  = 1/2;
    b =  1/(2+2*sqrt(2));
    c = fs/2;
    d = fs/(2+2*sqrt(2));
    polyhedron(
        [
            // rear
            [   -a, -a,    -b],
            [   -a, -a,     b],
            [   -b, -a,     a],
            [    b, -a,     a],
            [    a, -a,     b],
            [    a, -a,    -b],
            [    b, -a,    -a],
            [   -b, -a,    -a],
            // front
            [fxo-c,  a, fzo-d],
            [fxo-c,  a, fzo+d],
            [fxo-d,  a, fzo+c],
            [fxo+d,  a, fzo+c],
            [fxo+c,  a, fzo+d],
            [fxo+c,  a, fzo-d],
            [fxo+d,  a, fzo-c],
            [fxo-d,  a, fzo-c],
        ],
        [
            [ 0,  1,  2,  3,  4,  5, 6, 7],
            [15, 14, 13, 12, 11, 10, 9, 8],
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

// demo
scale(100) {
    translate([-2, 0,  3]) tetrahedron();
    translate([ 0, 0,  3]) tri_wedge(1/2);
    translate([ 2, 0,  3]) tri_frustum(1/2);

    translate([-4, 0,  1]) sixth_cube();
    translate([-2, 0,  1]) five_sixths_cube();
    translate([ 0, 0,  1]) square_pyramid();
    translate([ 2, 0,  1]) wedge(1/2);
    translate([ 4, 0,  1]) rect_frustum(1/2, 1/2);

    translate([-3, 0, -1]) hex_pyramid();
    translate([-1, 0, -1]) hex_wedge();
    translate([ 1, 0, -1]) hex_to_rect();
    translate([ 3, 0, -1]) hex_frustum();

    translate([-3, 0, -3]) oct_pyramid();
    translate([-1, 0, -3]) oct_wedge();
    translate([ 1, 0, -3]) square_cupola();
    translate([ 3, 0, -3]) oct_frustum();
}
