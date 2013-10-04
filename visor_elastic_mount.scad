// Simple phone mounting structure
//  provides points for elastic bands to attach to.

// Add elastic mounts for the A and B variants with the triangular
// corner pieces.
//
//  fwidth  - width of the front of the viewer
//  fheight - height of the front of the viewer
//  wall    - thickness of walls
module phone_mount_narrow( fwidth, fheight, wall )
{
    phone_mount( fwidth, fheight, wall, 5, 3 );
}

// Add elastic mounts for the C variant which is slopes more smoothly
// from face to phone.
//
//  fwidth  - width of the front of the viewer
//  fheight - height of the front of the viewer
//  wall    - thickness of walls
module phone_mount_wide( fwidth, fheight, wall )
{
    phone_mount( fwidth, fheight, wall, 2.5, 5 );
}

//  fwidth  - width of the front of the viewer
//  fheight - height of the front of the viewer
//  wall    - thickness of walls
module phone_mount( fwidth, fheight, wall, y_delta, zoffset )
{
    xoffset=fwidth/2-20;
    yoffset=fheight/2-y_delta;
    theta=40;
    for( dir = [ [1,1,-1], [-1,1,-1], [1,-1,1], [-1,-1,1] ] )
    {
        translate( [ dir[0]*xoffset,  dir[1]*yoffset, zoffset] )
            rotate( [ dir[2]*theta,0,0] ) elastic_mount_point( wall );
    }
}

// Define one mount point
//
//  wall - width of the visor wall
module elastic_mount_point( wall )
{
    len=3*wall;
    r_base=3;
    r_tip=2.5;
    translate( [0,0,len/2] ) union()
    {
        cylinder( h=len, r1=r_base, r2=r_tip, center=true );
        translate( [0,0,len/2] ) sphere( r_tip );
    }
}

// Define a shelf/ridge to provide a little support for the phone to
//  take some stress off the rubber bands.
//
// wall    - thickness of the visor walls
// width   - width of the shelf supporting the phone
// opening - width of the opening at the bottom of the face
// step    - the depth of the support at the bottom of the opening
module phone_support_ridge( wall, width, opening, step )
{
    thick=2;
    shelf=6;
    offset=(wall+thick)/2+0.125;
    union()
    {
        translate( [0,0,thick/2] ) cube( [ opening, wall+2*thick+0.25, thick ], center=true );
        translate( [0, offset, (shelf+step)/2] ) cube( [ width, thick, shelf+step ], center=true );
        translate( [0,-offset, (thick+step)/2] ) cube( [ opening+wall*2, thick, step+thick ], center=true );
    }
}
