// secondsight Visor project
// Copyright 2013 by secondsight.io, Some Rights Reserved.
//
// Definition of slide-on phone support.

overlap=0.1;

// Add modification to the visor body to mount the phone holder.
//
//  fwidth  - width of the front of the viewer
//  fheight - height of the front of the viewer
//  wall    - thickness of walls
module phone_mount_add( fwidth, fheight, wall )
{
    translate( [ 0, fheight/2, 0 ] ) slide_rail( 0.85*fwidth );
    translate( [ 0,-fheight/2, 0 ] ) mirror( [ 0, 1, 0 ] ) slide_rail( 0.85*fwidth );
//  translate( [ fwidth/2, 0, 0 ] ) rotate( [ 0, 0, -90 ] ) slide_rail( 0.8*fheight );
}

module slide_rail( length )
{
    width=1.5;
    thickness=2;
    translate( [ 0, (width-overlap)/2, thickness/2 ] ) difference()
    {
        cube( [ length, width+overlap, thickness ], center=true );
        translate( [ 0, 0.75*width, 0.75*width] ) rotate( [ 45, 0, 0 ] ) cube( [ length+overlap, 1.5*width, 1.5*width ], center=true );
        translate( [ length/2, width/2, 0 ] ) rotate( [ 0, 0, 45 ] ) cube( 1.5*width, center=true );
        translate( [-length/2, width/2, 0 ] ) rotate( [ 0, 0, 45 ] ) cube( 1.5*width, center=true );
    }
}

module phone_support_ridge( wall, width, opening, step )
{
}

module phone_holder( height, width, thick, wall, space )
{
    x_inside=height+2*space;
    y_inside=width+2*space;
    z_inside=thick+space;
    r_corner=10;
    z_top=thick+wall+space-2*overlap;
    union()
    {
        difference()
        {
            rounded_plate( x_inside+2*wall, y_inside+2*wall, z_inside+wall, r_corner+wall );
            translate( [ 0, 0, wall ] ) rounded_plate( x_inside, y_inside, z_inside+overlap, r_corner );
        }
       translate( [ 0, width/2, z_top] ) holder_rail( 0.85*height, wall );
       translate( [ 0,-width/2, z_top] ) mirror( [ 0, 1, 0 ] ) holder_rail( 0.85*height, wall/2 );
       translate( [ (height+wall)/2+overlap, 0, z_top+1 ] ) cube( [wall,5,wall] , center=true );
    }
}

module holder_rail( length, wall )
{
    width=1.5;
    thickness=2;
    union()
    {
        translate( [ 0, width/2-overlap, thickness/2 ] ) difference()
        {
            translate( [ 0, width/2, 0 ] ) cube( [ length, width, thickness ], center=true );
            translate( [ 0, 0, overlap ] ) difference()
            {
                cube( [ length+overlap, width+2*overlap, thickness ], center=true );
                translate( [ 0, 0.75*width, 0.75*width] ) rotate( [ 45, 0, 0 ] ) cube( [ length+overlap*2, 1.5*width, 1.5*width ], center=true );
            }
        }
//  *     translate( [ 0, (width+wall-overlap)/2, thickness/2-1.5*wall ] ) intersection()
//        {
//            cube( [ length, width+overlap, width+wall ], center=true );
//            translate( [0, -0.45*(width+wall), 0.45*(width+wall) ] ) rotate( [ 45, 0, 0 ] ) cube( [ length+overlap, 1.5*(width+wall), 1.5*(width+wall) ], center=true );
//        }
    }
}

module rounded_plate( x, y, z, rad )
{
    x_off=x/2-rad;
    y_off=y/2-rad;
    hull()
    {
        for( pos = [ [-x_off,y_off], [x_off,y_off], [x_off,-y_off], [-x_off,-y_off] ] )
        {
            translate( [ pos[0], pos[1], 0 ] ) cylinder( h=z, r=rad );
        }
    }
}
