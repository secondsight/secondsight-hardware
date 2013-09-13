// Experiment with octogon shape

// Use dimensions for Galaxy S4
//    Dimensions are portrait mode.
phone_width=69.8;
phone_height=136.6;
phone_thickness=7.9;
view_width=65;
view_height=110;

// Potentially user-specific data
face_width=116;
forehead_depth=37.5;
variant="A";

strap_width=40;
front_width=126;
height=67;
depth=65;
thick=3;

if( variant == "A" )
{
    main_body( phone_height, phone_width, face_width, forehead_depth );
}
if( variant == "B" )
{
    main_body( front_width, height, face_width, forehead_depth );
}
if( variant == "test" )
{
    intersection()
    {
        translate( [0,0,-depth/2] ) main_body( phone_height, phone_width, face_width, forehead_depth );
        translate( [0,0,phone_height/2] ) cube( phone_height, center=true );
    }
}

// Build the body from the pieces
module main_body( fwidth, fheight, face, forehead_depth )
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    shell_outer( fwidth, fheight, face );
                    body_front_outer();
                }
                face( face, forehead_depth, depth );
                nose_slice( thick );
            }
            translate([face/2+thick, 0, depth-7]) rotate([180,-90,0]) strap_mount();
            translate([-face/2-thick, 0, depth-7]) rotate([0,-90,0]) strap_mount();
        }
        shell_inner( fwidth, fheight, face );
        body_front_inner();
    }
}

module strap_mount()
{
    length=30;
    width=strap_width+2*thick;
    thickness=2*thick;
    difference()
    {
        cube( [length, width, thickness], center=true );
        // gap for strap
        translate( [length/2-1.5*thick,0,0] ) cube( [thick, strap_width, 1.5*thickness], center=true );
        // slope on face of mount
        translate( [-length/2-thick,0,0] ) rotate([0,-20,0]) cube( [1.5*width,1.5*width,thickness], center=true );
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

module body_front_inner()
{
    scale( [1,phone_width/phone_height,1] )
        polyprism_hole( len=1.2*phone_width/2, bottom=phone_height/2, top=phone_height/4, wall=thick, sides=4 );
}

// Define the rear "squashed octagon" portion of the viewer
//  fwidth  - the width of the front of this part of the body
//  fheight - the height of the front of this part of the body
//  face    - width of the face
module shell_outer( fwidth, fheight, face )
{
    scale( [1,fheight/fwidth,1] )
        polyprism( len=depth, bottom=fwidth/2, top=face/2, sides=8 );
}

//  fwidth  - the width of the front of this part of the body
//  fheight - the height of the front of this part of the body
//  face    - width of the face
module shell_inner( fwidth, fheight, face )
{
    scale( [1,fheight/fwidth,1] )
        polyprism_hole( len=depth, bottom=fwidth/2, top=face/2, wall=thick, sides=8 );
}

// Define the portions to remove to fit a forehead.
// face_width - across forehead
// depth      - distance from forehead touch to temples of viewer
// height     - distance from front to back of viewer
module face( face_width, depth, height )
{
    radius=0.75*face_width;
    translate([0,0,radius+depth]) rotate([90,0,0])
        cylinder( h=1.25*height, r=radius, center=true, $fn=32 );
}

// Define the portion that is open around the nose.
//  thickness  - wall thickness
module nose_slice( thickness )
{
    theta=10;
    spread=5.8;
    slice=35;
    translate( [0,-height/2+0.75*thickness,depth/2] )
    intersection()
    {
        union()
        {
            translate([spread,0,0] ) rotate( [0,theta,0] ) cube( [slice, thickness*4, 1.2*depth], center=true );
            translate([-spread,0,0] ) rotate( [0,-theta,0] ) cube( [slice, thickness*4, 1.2*depth], center=true );
        }
        // cut it off slightly above the base
        translate([0,0,thickness]) cube( depth, center=true );
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
