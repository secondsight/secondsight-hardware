// Definition of the aetherAR visor

// Use dimensions for Galaxy S4
//    Dimensions are portrait mode.
phone_width=69.8;
phone_height=136.6;
phone_thickness=7.9;
view_width=65;
view_height=110;

// Potentially user-specific data
face_width=116;           // temple-to-temple distance
forehead_depth=27.5;      // temple to front of forehead distance
eye_forehead_offset=5;    // distance from forehead to eye

variant="test";

strap_width=40;
front_width=126;
height=67;
thick=3;

include <visor_optics_mount.scad>;

//depth=70;
depth=nominal_eye_phone_distance()+forehead_depth;
eyes=depth-forehead_depth+eye_forehead_offset; // eye to front distance

include <visor_body.scad>;
include <visor_elastic_mount.scad>;

if( variant == "A" )
{
    // The octagon slopes out to match the front
    difference()
    {
        main_body( phone_height, phone_width, depth, thick, face_width, forehead_depth );
        optics_slots( front_width, eyes, thick );
    }
}
if( variant == "B" )
{
    // The octagon stays mostly parallel
    difference()
    {
        main_body( front_width, height, depth, thick, face_width, forehead_depth );
        optics_slots( front_width, eyes, thick );
    }
}
if( variant == "test" )
{
    intersection()
    {
        difference()
        {
            main_body( phone_height, phone_width, depth, thick, face_width, forehead_depth );
            optics_slots( front_width, eyes, thick );
        }
        translate( [0.95*front_width,0,-10] ) cube( phone_height, center=true );
    }
}

