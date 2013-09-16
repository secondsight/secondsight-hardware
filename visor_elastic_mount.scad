// Simple phone mounting structure
//  provides points for elastic bands to attach to.


//  fwidth  - width of the front of the viewer
//  fheight - height of the front of the viewer
module phone_mount( fwidth, fheight )
{
    xoffset=fwidth/2-20;
    yoffset=fheight/2-5;
    zoffset=5;
    theta=40;
    for( dir = [ [1,1,-1], [-1,1,-1], [1,-1,1], [-1,-1,1] ] )
    {
        translate( [ dir[0]*xoffset,  dir[1]*yoffset, zoffset] )
            rotate( [ dir[2]*theta,0,0] ) elastic_mount_point();
    }
}

module elastic_mount_point()
{
    translate( [0,0,thick] ) union()
    {
        cylinder( h=2*thick, r=2.5, center=true );
        translate( [0,0,thick] ) sphere( 2.5 );
    }
}

