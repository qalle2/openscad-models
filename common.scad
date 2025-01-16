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

module rect_frustum(fw, fh, fx=0, fz=0) {
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

module oct_pyramid(fx, fz) {
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

module oct_wedge(fw=1, fx=0, fz=0) {
    /*
    faces:
        1 regular octagon (vertical, rear)
        2 trapezoids
        6 isosceles triangles
    the front is a horizontal edge;
    args:
        fw     = front edge width
        fx, fz = front X/Z offset from centerline
    */
    a =  1/(2+2*sqrt(2));  // small
    b =  1/2;              // big
    f = fw/2;              // front
    polyhedron(
        [
            // rear
            [  -b, -b, -a],
            [  -b, -b,  a],
            [  -a, -b,  b],
            [   a, -b,  b],
            [   b, -b,  a],
            [   b, -b, -a],
            [   a, -b, -b],
            [  -a, -b, -b],
            // front
            [fx-f,  b, fz],
            [fx+f,  b, fz],
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

module square_cupola(fw=1, fh=1, fxo=0, fzo=0) {
    /*
    faces:
        1 regular octagon (vertical, rear)
        1 rectangle       (vertical, front)
        4 trapezoids
        4 isosceles triangles
    args:
        fw, fh   = front width/height
        fxo, fzo = front X/Z offset from centerline
    */
    ra =  1/(2+2*sqrt(2));  // rear small
    rb =  1/2;              // rear big
    y  =  1/2;
    fx = fw/2;
    fz = fh/2;
    polyhedron(
        [
            // rear
            [-rb, -y, -ra],
            [-rb, -y,  ra],
            [-ra, -y,  rb],
            [ ra, -y,  rb],
            [ rb, -y,  ra],
            [ rb, -y, -ra],
            [ ra, -y, -rb],
            [-ra, -y, -rb],
            // front
            [fxo-fx, y, fzo-fz],
            [fxo-fx, y, fzo+fz],
            [fxo+fx, y, fzo+fz],
            [fxo+fx, y, fzo-fz],
        ],
        [
            [0, 1, 2, 3, 4, 5, 6, 7],
            [8, 11, 10, 9],
            [0, 8, 9, 1],
            [1, 9, 2],
            [2, 9, 10, 3],
            [3, 10, 4],
            [4, 10, 11, 5],
            [5, 11, 6],
            [6, 11, 8, 7],
            [7, 8, 0],
        ]
    );
}

module oct_frustum(fs=1, fx=0, fz=0) {
    /*
    a frustum of an octagonal pyramid;
    X & Z centring doesn't depend on fx & fz;
    base towards viewer;
    faces:
        2 regular octagons (vertical; front and rear)
        8 trapezoids
    args:
        fs     = front width & height scale factor
        fx, fz = front X/Z offset from centreline
    note: front face must have same width/height ratio as rear face;
    otherwise side faces would not be planes;
    note: default settings = octagonal prism
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
            [fx-fb,  y, fz-fa],
            [fx-fb,  y, fz+fa],
            [fx-fa,  y, fz+fb],
            [fx+fa,  y, fz+fb],
            [fx+fb,  y, fz+fa],
            [fx+fb,  y, fz-fa],
            [fx+fa,  y, fz-fb],
            [fx-fa,  y, fz-fb],
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
    translate([ 0, 0,  2]) tetrahedron(1/4, 1/4);
    translate([ 2, 0,  2]) tri_wedge(1/2, 1/8, 1/4);
    translate([ 4, 0,  2]) tri_frustum(1/2, 1/6, 1/6);

    translate([-4, 0,  0]) sixth_cube();
    translate([-2, 0,  0]) five_sixths_cube();
    translate([ 0, 0,  0]) square_pyramid(1/4, 1/4);
    translate([ 2, 0,  0]) wedge(1/2, 1/8, 1/4);
    translate([ 4, 0,  0]) rect_frustum(1/2, 1/3, 1/6, 1/6);

    translate([ 0, 0, -2]) oct_pyramid(1/4, 1/4);
    translate([ 2, 0, -2]) oct_wedge(1/4, 1/6, 1/6);
    translate([ 4, 0, -2]) square_cupola(1/3, 1/4, 1/8, 1/8);
    translate([ 6, 0, -2]) oct_frustum(1/2, 1/6, 1/6);
}
