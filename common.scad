// basic shapes and a demo at the end

module sixth_cube() {
    /*
    like a unit cube centred at [0, 0, 0]
    but 5/6 sliced away from top front right along 3 vertices;
    faces:
        3 isosceles right triangles
        1 equilateral     triangle
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

module half_cube() {
    /*
    like a unit cube centred at [0, 0, 0]
    but 1/2 sliced away from top front along 4 vertices;
    faces:
        2 squares
        1 rectangle
        2 isosceles right triangles
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
        ],
        [
            [0, 1, 3, 2],
            [0, 2, 4],
            [0, 4, 5, 1],
            [1, 5, 3],
            [2, 3, 5, 4],
        ]
    );
}

module five_sixths_cube() {
    /*
    like a unit cube centred at [0, 0, 0]
    but 1/6 sliced away from top front right along 3 vertices;
    faces:
        3 squares
        3 isosceles right triangles
        1 equilateral     triangle
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

module right_rect_frustum(fw, fh) {
    /*
    a right frustum of a rectangular pyramid
    (a right rectangular pyramid cut by a plane parallel to the base);
    base towards viewer;
    four of the faces are vertical;
    rear width = rear height = length = 1;
    centered at [0, 0, 0];
    faces:
        2 rectangles (front and rear)
        4 trapezoids
    args:
        fw = front width
        fh = front height
    */
    polyhedron(
        [
            // rear
            [ -1/2, -1/2,  -1/2],
            [ -1/2, -1/2,   1/2],
            [  1/2, -1/2,   1/2],
            [  1/2, -1/2,  -1/2],
            // front
            [-fw/2,  1/2, -fh/2],
            [-fw/2,  1/2,  fh/2],
            [ fw/2,  1/2,  fh/2],
            [ fw/2,  1/2, -fh/2],
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


module rect_frustum(fw, fh, fx, fz) {
    /*
    a frustum of a rectangular pyramid
    (a rectangular pyramid cut by a plane parallel to the base);
    base towards viewer;
    four of the faces are vertical;
    rear width = rear height = length = 1;
    centered at [0, 0, 0] but X & Z centering is based on rear face only;
    faces:
        2 rectangles (front and rear)
        4 trapezoids
    args:
        fw = front width
        fh = front height
        fx = front X offset from centerline
        fz = front Z offset from centerline
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

module oct_prism() {
    /*
    a right octagonal prism;
    distance between any two parallel faces = 1;
    centred at [0, 0, 0];
    faces:
        2 regular octagons (front and rear)
        8 rectangles
    base towards viewer
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

module right_oct_frustum(fs) {
    /*
    a right frustum of an octagonal pyramid;
    centred at [0, 0, 0];
    base towards viewer;
    front and rear faces: two vertical regular octagons
    with width = height = Y distance = 1;
    other faces: eight trapezoids;
    same as octagonal prism if fs = 1;
    faces:
        2 regular octagons (front and rear)
        8 trapezoids
    args:
        fs = front width & height scale factor
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
            [-rb, -y, -ra],
            [-rb, -y,  ra],
            [-ra, -y,  rb],
            [ ra, -y,  rb],
            [ rb, -y,  ra],
            [ rb, -y, -ra],
            [ ra, -y, -rb],
            [-ra, -y, -rb],
            // front
            [-fb,  y, -fa],
            [-fb,  y,  fa],
            [-fa,  y,  fb],
            [ fa,  y,  fb],
            [ fb,  y,  fa],
            [ fb,  y, -fa],
            [ fa,  y, -fb],
            [-fa,  y, -fb],
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

module oct_frustum(fs, fx, fz) {
    /*
    a frustum of an octagonal pyramid;
    centred at [0, 0, 0] (if fx = fz = 0);
    base towards viewer;
    front and rear faces: two vertical regular octagons
    with width = height = Y distance = 1;
    other faces: eight trapezoids;
    same as the octagonal prism if fs = 1 and fx = fz = 0;
    faces:
        2 regular octagons (front and rear)
        8 trapezoids
    args:
        fs = front width & height scale factor
        fx = front X offset from centreline
        fz = front Z offset from centreline
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

module oct_to_edge(fw) {
    /*
    a transition between a regular octagon (rear)
    and a horizontal edge (front);
    max width = max length = max height = 1;
    centred at [0, 0, 0];
    faces:
        1 regular octagon (vertical, rear)
        2 trapezoids
        6 isosceles triangles
    */
    a =  1/(2+2*sqrt(2));  // small
    b =  1/2;              // big
    f = fw/2;
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
            [-f,  b,  0],
            [ f,  b,  0],
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

module oct_to_rect(fw, fh) {
    /*
    a transition between an octagon and a rectangle;
    max width = max length = max height = 1;
    centred at [0, 0, 0];
    faces:
        1 regular octagon (vertical, rear)
        1 rectangle       (vertical, front)
        4 trapezoids
        4 isosceles triangles
    args:
        fw = front width
        fh = front height
    faces:
        1 regular octagon (rear)
        2 trapezoids
        6 isosceles triangles
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
            [-fx, y, -fz],
            [-fx, y,  fz],
            [ fx, y,  fz],
            [ fx, y, -fz],
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

// demo
scale(100) {
    translate([-9, 0, 0]) sixth_cube();
    translate([-7, 0, 0]) half_cube();
    translate([-5, 0, 0]) five_sixths_cube();
    translate([-3, 0, 0]) right_rect_frustum(1/2, 1/3);
    translate([-1, 0, 0]) rect_frustum(1/2, 1/3, 1/6, 1/6);
    translate([ 1, 0, 0]) oct_prism();
    translate([ 3, 0, 0]) right_oct_frustum(1/2);
    translate([ 5, 0, 0]) oct_frustum(1/2, 1/6, 1/6);
    translate([ 7, 0, 0]) oct_to_edge(1/4);
    translate([ 9, 0, 0]) oct_to_rect(1/4, 1/6);
}
