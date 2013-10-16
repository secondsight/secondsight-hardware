// Raw definition for the polyhedron used in the visor body.

function make_poly_face( wid, ht, horiz, vert )=[ wid, ht, horiz, vert ]; 
function make_poly_inside( wid, ht, horiz, vert, wall )=[ wid-2*wall, ht-2*wall, horiz-wall, vert-wall ]; 

// Handle parameters for polygon shape.
function _width( desc )=desc[0];
function _height( desc )=desc[1];
function _horiz_side( desc )=desc[2];
function _vert_side( desc )=desc[3];

// Define the point for the corners of the body polyhedrons
function polybody_points( phone, face, depth )=[
            [-_horiz_side(phone)/2, _height(phone)/2, 0 ], [-_width(phone)/2, _vert_side(phone)/2, 0 ],     // p-tl  (0,1)
            [-_width(phone)/2,-_vert_side(phone)/2, 0 ], [-_horiz_side(phone)/2, -_height(phone)/2, 0 ],    // p-bl  (2,3)
            [ _horiz_side(phone)/2,-_height(phone)/2, 0 ], [ _width(phone)/2,-_vert_side(phone)/2, 0 ],     // p-br  (4,5)
            [ _width(phone)/2, _vert_side(phone)/2, 0 ], [ _horiz_side(phone)/2, _height(phone)/2, 0 ],     // p-tr  (6,7)
            [ _horiz_side(face)/2, _height(face)/2, depth ], [ _width(face)/2, _vert_side(face)/2, depth ], // f-tr  (8,9)
            [ _width(face)/2,-_vert_side(face)/2, depth ], [ _horiz_side(face)/2, -_height(face)/2, depth ],// f-br  (10,11)
            [-_horiz_side(face)/2,-_height(face)/2, depth ], [-_width(face)/2,-_vert_side(face)/2, depth ], // f-bl  (12,13)
            [-_width(face)/2, _vert_side(face)/2, depth ], [-_horiz_side(face)/2, _height(face)/2, depth ], // f-tl  (14,15)
        ];

// Ten-sided polyhedron making the smooth visor body.
//
// phone - a vector containing parameters for the phone side of the body
// face  - a vector containing parameters for the face side of the body
// depth - the depth of the body, front to back
//
// The vectors for phone and face contain 4 parameters.
//   - width      : the full width of the object on this side
//   - height     : the full height of the object on this side
//   - horiz_side : the width of the center side of the horizontal
//   - vert_side  : the height of the center side of the vertical
module polybody( phone, face, depth )
{
    polyhedron(
        points=polybody_points( phone, face, depth ),
        triangles=[
            [1,2,3], [3,0,1], [0,3,4], [4,7,0], [7,4,5], [5,6,7], // phone
            [0,15,14], [14,1,0],  // top-left
            [7,8,15], [15,0,7],   // top
            [8,7,9], [9,7,6],     // top-right
            [5,10,9], [9,6,5],    // right
            [4,11,10], [10,5,4],  // bottom-right
            [3,12,11], [11,4,3],  // bottom
            [2,13,3], [13,12,3],  // bottom-left
            [2,1,14], [14,13,2],  // left
            [8,14,15], [8,9,14], [9,13,14], [9,10,13], [10,12,13], [10,11,12] // face
        ]
    );
}
// Ten-sided polyhedron making the grooved visor body.
//
// phone - a vector containing parameters for the phone side of the body
// face  - a vector containing parameters for the face side of the body
// depth - the depth of the body, front to back
//
// The vectors for phone and face contain 4 parameters.
//   - width      : the full width of the object on this side
//   - height     : the full height of the object on this side
//   - horiz_side : the width of the center side of the horizontal
//   - vert_side  : the height of the center side of the vertical
module polybody_concave( phone, face, depth )
{
    polyhedron(
        points=polybody_points( phone, face, depth ),
        triangles=[
            [1,2,3], [3,0,1], [0,3,4], [4,7,0], [7,4,5], [5,6,7], // phone
            [0,15,1], [1,15,14],  // top-left
            [7,8,15], [15,0,7],   // top
            [6,8,7], [6,9,8],     // top-right
            [5,10,9], [9,6,5],    // right
            [4,11,5], [5,11,10],  // bottom-right
            [3,12,11], [11,4,3],  // bottom
            [2,12,3], [2,13,12],  // bottom-left
            [2,1,14], [14,13,2],  // left
            [8,14,15], [8,9,14], [9,13,14], [9,10,13], [10,12,13], [10,11,12] // face
        ]
    );
}
