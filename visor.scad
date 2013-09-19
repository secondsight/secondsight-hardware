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

variant="A";
part="both";

strap_width=40;
front_width=126;
height=67;
thick=3;

include <visor_optics_mount.scad>;

depth=nominal_eye_phone_distance()+forehead_depth;
eyes=depth-forehead_depth+eye_forehead_offset; // eye to front distance

include <visor_body.scad>;
include <visor_elastic_mount.scad>;

function side_slope( width ) = atan2( (width-face_width)/2, depth );
function is_print_body( p ) = p == "body" || p == "both";
function is_print_optics( p ) = p == "optics" || p == "both";

if( variant == "A" )
{
    // The octagon slopes out to match the front
    visor( phone_height, phone_width, part );
}
if( variant == "B" )
{
    // The octagon stays mostly parallel
    visor( front_width, height, part );
}
if( variant == "test" )
{
    //angle=side_slope( phone_height );
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

module visor( width, height, part )
{
    if( is_print_body( part ) )
    {
        difference()
        {
            main_body( width, height, depth, thick, face_width, forehead_depth );
            optics_slots( width, eyes, thick );
        }
    }
    if( is_print_optics( part ) )
    {
        optics_plate( front_width );
    }
}

module optics_plate( width )
{
    angle=side_slope( width );
    translate( [ 10,  20, 0] ) slider_inside( thick, angle );
    translate( [-10,  20, 0] ) slider_inside( thick, angle );
    translate( [ 10, -20, 0] ) slider_outside( thick, angle );
    translate( [-10, -20, 0] ) slider_outside( thick, angle );
    translate( [-50,  5, 0] ) lens_holder( (phone_height+5)/2, 25 );
    translate( [ 50, -5, 0] ) rotate( [0, 0, 180] ) lens_holder( (phone_height+5)/2, 25 );
}

