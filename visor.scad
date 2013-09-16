// Definition of the aetherAR visor

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

include <visor_body.scad>
include <visor_elastic_mount.scad>

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
        translate( [0,0,-0.55*depth] ) main_body( phone_height, phone_width, face_width, forehead_depth );
        translate( [0,0,phone_height/2] ) cube( phone_height, center=true );
    }
}


