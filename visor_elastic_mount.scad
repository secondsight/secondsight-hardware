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

module elastic_mount_point( wall )
{
    translate( [0,0,1.5*wall] ) union()
    {
        cylinder( h=3*wall, r1=3, r2=2.5, center=true );
        translate( [0,0,1.5*wall] ) sphere( 2.5 );
    }
}

