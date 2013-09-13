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

// Two variations of the design:
//  In the first, the main body slopes all of the way to the edges.
//  In the second, the body is slightly straighter, with a flare at the front.
front_width=phone_height;
height=phone_width;
//front_width=126;
//height=67;
depth=65;
thick=3;

main_body();

// Build the body from the pieces
module main_body()
{
    difference()
    {
        union()
        {
            shell_outer();
            body_front_outer();
        }
        shell_inner();
        body_front_inner();
        face();
        nose_slice( thick );
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
module shell_outer()
{
    scale( [1,height/front_width,1] )
        polyprism( len=depth, bottom=front_width/2, top=face_width/2, sides=8 );
}

module shell_inner()
{
    scale( [1,height/front_width,1] )
        polyprism_hole( len=depth, bottom=front_width/2, top=face_width/2, wall=thick, sides=8 );
}

// Define the portions to remove to fit a face.
module face()
{
    radius=0.75*face_width;
    translate([0,0,radius+forehead_depth]) rotate([90,0,0])
        cylinder( h=1.25*depth, r=radius, center=true, $fn=32 );
}

module nose_slice( thickness )
{
    theta=10;
    spread=5.8;
    slice=35;
    translate( [0,-height/2+0.75*thickness,depth/2] )
    union()
    {
        translate([spread,0,0] ) rotate( [0,theta,0] ) cube( [slice, thickness*4, 1.2*depth], center=true );
        translate([-spread,0,0] ) rotate( [0,-theta,0] ) cube( [slice, thickness*4, 1.2*depth], center=true );
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
