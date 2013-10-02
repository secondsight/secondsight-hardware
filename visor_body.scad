// aetherAR visor - main body shape.

// Handle parameters for body shape.
function _width( desc )=desc[0];
function _height( desc )=desc[1];
function _horiz_side( desc )=desc[2];
function _vert_side( desc )=desc[3];

// Depends on the following globals:
//  phone_width  -  body_front_outer(), body_front_inner(),
//  phone_height -  body_front_outer(), body_front_inner(),
//  height       -  main_body()
//  strap_width  -  strap_mount()

// Build the body from the pieces (too many parameters)
//  fwidth         - the width of the front of this part of the body
//  fheight        - the height of the front of this part of the body
//  depth          - the measured from front of visor to the back
//  wall           - thickness of the walls of the visor
//  face           - width of the face
//  forehead_depth - distance from forehead touch to temples of viewer
module main_body( fwidth, fheight, depth, wall, face, forehead_depth, variant )
{
    protrude=0.1;
    difference()
    {
        union()
        {
            difference()
            {
                // core shape
                if( variant == "C" )
                {
                    solid_body(
                        [ fwidth, fheight, 116, 55.8 ],
                        [ face, height, 63, 35 ],
                        depth,
                        wall
                    );
                }
                else
                {
                    union()
                    {
                        shell_outer( fwidth, fheight, depth, face );
                        body_front_outer();
                    }
                }
                // carve out back of viewer
                face( face, depth-forehead_depth, depth );
                nose_slice( fheight, depth, wall );
            }
            // add straps
            translate([ face/2+0.75*wall, 0, depth-8]) rotate([180,-85,0]) strap_mount( wall );
            translate([-face/2-0.75*wall, 0, depth-8]) rotate([0,-95,0]) strap_mount( wall );
            phone_mount( fwidth, fheight, wall, variant );
        }
        // These must be subtracted last to deal with any added parts that might
        //  intrude on the middle volume.
        if( variant == "C" )
        {
            translate( [0,0,-protrude] ) solid_body(
                [ fwidth-2*wall, fheight-2*wall, 116-wall, 55.8-wall ],
                [ face-2*wall, height-2*wall, 63-wall, 35-wall ],
                depth+2*protrude,
                wall
            );
        }
        else
        {
            shell_inner( fwidth, fheight, depth, wall, face );
            body_front_inner( wall );
        }
    }
}

// Mount points for the strap.
//   lying flat, must be rotated up to mount.
//  wall    - thickness of the walls of the visor
module strap_mount( wall )
{
    strap_fudge=1;
    length=33;
    width=strap_width+3*wall+strap_fudge;
    thickness=1.5*wall;
    difference()
    {
        union()
        {
            difference()
            {
                cube( [length, width, thickness], center=true );
                // gap for strap
                translate( [length/2 - 2*wall,0,0] ) cube( [4*wall, strap_width+strap_fudge, 1.5*thickness], center=true );
            }
            // rod to support strap
            translate( [length/2 - 2.25*wall,width/2,0] ) rotate( [90,0,0] )
                polyprism( len=width, top=thickness/2, bottom=thickness/2, sides=8 );
            translate( [length/2,width/2,0] ) rotate( [90,0,0] )
                polyprism( len=width, top=thickness/2, bottom=thickness/2, sides=8 );
        }
        translate( [-length/2-wall,0,0] ) rotate([0,-20,0]) cube( [1.5*width,1.5*width,thickness], center=true );
        // slopes on edges of mount
        for( dir = [1,-1] )
        {
            translate( [-0.4*width,dir*0.82*width,0] ) rotate( [0,0,dir*20] ) cube( width, center=true );
        }
    }
}

// Define the front rectangular portion of the viewer
module body_front_outer()
{
    scale( [1,phone_width/phone_height,1] )
        polyprism( len=1.2*phone_width/2, bottom=phone_height/2, top=phone_height/4, sides=4 );
}

//  wall    - thickness of the walls of the visor
module body_front_inner( wall )
{
    scale( [1,(phone_width-wall)/(phone_height-wall),1] )
        polyprism_hole( len=1.2*phone_width/2, bottom=phone_height/2, top=phone_height/4, wall=wall, sides=4 );
}

// Define the rear "squashed octagon" portion of the viewer
//  fwidth  - the width of the front of this part of the body
//  fheight - the height of the front of this part of the body
//  depth   - the measured from front of visor to the back
//  face    - width of the face
module shell_outer( fwidth, fheight, depth, face )
{
    scale( [1,fheight/fwidth,1] )
        polyprism( len=depth, bottom=fwidth/2, top=face/2, sides=8 );
}

//  fwidth  - the width of the front of this part of the body
//  fheight - the height of the front of this part of the body
//  depth   - the measured from front of visor to the back
//  wall    - thickness of the walls of the visor
//  face    - width of the face
module shell_inner( fwidth, fheight, depth, wall, face )
{
    scale( [1,(fheight-wall)/(fwidth-wall),1] )
        polyprism_hole( len=depth, bottom=fwidth/2, top=face/2, wall=wall, sides=8 );
}

// Define the portions to remove to fit a forehead.
// face_width - across forehead
// depth      - distance from forehead touch to front of visor
// height     - distance from front to back of viewer
module face( face_width, depth, height )
{
    radius=0.75*face_width;
    translate([0,0,radius+depth]) rotate([90,0,0])
        cylinder( h=1.25*height, r=radius, center=true, $fn=32 );
}

// Define the portion that is open around the nose.
//  height - nominal height of the front of the visor
//  depth   - the measured from front of visor to the back
//  wall   - wall thickness
module nose_slice( height, depth, wall )
{
    theta=8;
    slice=32;
    translate( [0,-height/2+0.75*wall,0] )
    intersection()
    {
        union()
        {
            rotate( [0,theta,0] ) translate( [0,0,depth/2] ) cube( [slice, wall*4, 1.2*depth], center=true );
            rotate( [0,-theta,0] ) translate( [0,0,depth/2] ) cube( [slice, wall*4, 1.2*depth], center=true );
        }
        // cut it off slightly above the base
        translate([0,0,wall+depth/2]) cube( depth, center=true );
    }
}

// Convert polygon opposite face distance to radius
function radius_from_side(dist,sides) = dist/cos(180/sides);

//
//  Polygonal prism centered in x-y, with sitting on z-origin.
//  len - length of prism
//  bottom - bottom radius
//  top - top radius
//  sides - number of sides of the polygon
module polyprism( len, bottom, top, sides )
{
    translate( [0,0,len/2] ) rotate( [0,0,180/sides] )
        cylinder( h=len,
                  r1=radius_from_side( bottom, sides ), r2=radius_from_side( top, sides ),
                  center=true, $fn=sides
        );
}

//
//  Polygonal prism hole, expected to be subtracted from a polyprism
//  len    - length of prism
//  bottom - bottom face-distance
//  top    - top face-distance
//  wall   - thickness of remaining wall
//  sides  - number of sides of the polygon
module polyprism_hole( len, bottom, top, wall, sides )
{
    fudge=0.04;
    translate( [0,0,(len-fudge)/2] ) rotate( [0,0,180/sides] )
        cylinder( h=len+fudge,
                  r1=radius_from_side( bottom, sides )-wall, r2=radius_from_side( top, sides )-wall,
                  center=true, $fn=sides
        );
}

module solid_body( phone, face, depth, wall )
{
    polyhedron(
        points=[
            [-_horiz_side(phone)/2, _height(phone)/2, 0 ], [-_width(phone)/2, _vert_side(phone)/2, 0 ],     // p-tl  (0,1)
            [-_width(phone)/2,-_vert_side(phone)/2, 0 ], [-_horiz_side(phone)/2, -_height(phone)/2, 0 ],    // p-bl  (2,3)
            [ _horiz_side(phone)/2,-_height(phone)/2, 0 ], [ _width(phone)/2,-_vert_side(phone)/2, 0 ],     // p-br  (4,5)
            [ _width(phone)/2, _vert_side(phone)/2, 0 ], [ _horiz_side(phone)/2, _height(phone)/2, 0 ],     // p-tr  (6,7)
            [ _horiz_side(face)/2, _height(face)/2, depth ], [ _width(face)/2, _vert_side(face)/2, depth ], // f-tr  (8,9)
            [ _width(face)/2,-_vert_side(face)/2, depth ], [ _horiz_side(face)/2, -_height(face)/2, depth ],// f-br  (10,11)
            [-_horiz_side(face)/2,-_height(face)/2, depth ], [-_width(face)/2,-_vert_side(face)/2, depth ], // f-bl  (12,13)
            [-_width(face)/2, _vert_side(face)/2, depth ], [-_horiz_side(face)/2, _height(face)/2, depth ], // f-tl  (14,15)
        ],
        triangles=[
            [1,2,3], [3,0,1], [0,3,4], [4,7,0], [7,4,5], [5,6,7],              // phone
            [0,15,14], [14,1,0], [7,8,15], [15,0,7], [6,9,8], [8,7,6],         // top
            [5,10,9], [9,6,5],                                                 // right
            [4,11,10], [10,5,4], [3,12,11], [11,4,3], [2,13,12], [12,3,2],     // bottom
            [2,1,14], [14,13,2],                                               // left
            [8,14,15], [8,9,14], [9,13,14], [9,10,13], [10,12,13], [10,11,12]  // face
        ]
    );
}
