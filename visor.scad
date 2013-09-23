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
IPD_min=52;
IPD_max=78;
IPD_avg=63;

variant="A";
plate="both";

strap_width=40;
front_width=126;
height=67;
thick=3;
lens_diameter=25;

include <visor_optics_mount.scad>;

eyes=nominal_eye_phone_distance();
depth=eyes-eye_forehead_offset+forehead_depth;

include <visor_body.scad>;
include <visor_elastic_mount.scad>;

function side_slope( width ) = atan2( (width-face_width)/2, depth );
function is_print_body( p ) = p == "body" || p == "both" || p == "assembled";
function is_print_optics( p ) = p == "optics" || p == "both";

if( variant == "A" )
{
    // The octagon slopes out to match the front
    visor( phone_height, phone_width, plate, lens_diameter );
}
if( variant == "B" )
{
    // The octagon stays mostly parallel
    visor( front_width, height, plate, lens_diameter );
}
if( variant == "test" )
{
    assign( angle=side_slope( phone_height ) )
    {
        translate( [-10,  20, 0] ) slider_inside( thick, angle );
        translate( [-10, -20, 0] ) slider_outside( thick, angle );
//        translate( [-50,  5, 0] ) lens_holder( (phone_height+5)/2, lens_diameter );
    }
}

module visor( width, height, plate, lens )
{
    if( is_print_body( plate ) )
    {
        difference()
        {
            main_body( width, height, depth, thick, face_width, forehead_depth );
            optics_slots( width, eyes, thick );
        }
    }
    if( is_print_optics( plate ) )
    {
        optics_plate( front_width, lens );
    }
    if( plate == "assembled" )
    {
        optics_assembled( front_width, lens );
    }
}

module optics_plate( width, lens )
{
    angle=side_slope( width );
    xoff=lens < 40 ? 50 : 45;
    translate( [ 10,  20, 0] ) slider_inside( thick, angle );
    translate( [-10,  20, 0] ) slider_inside( thick, angle );
    translate( [ 10, -20, 0] ) slider_outside( thick, angle );
    translate( [-10, -20, 0] ) slider_outside( thick, angle );
    translate( [-xoff,  5, 0] ) lens_holder( (phone_height+5)/2, lens );
    translate( [ xoff, -5, 0] ) rotate( [0, 0, 180] ) lens_holder( (phone_height+5)/2, lens );
}

module optics_assembled( width, lens )
{
    angle=side_slope( width );
    theta=90-2*angle;
    xoff=IPD_min/2;
    lens_z=38;
    translate( [ width/2+2,  0, lens_z+0.5] ) rotate( [180,-theta,180] ) slider_inside( thick, angle );
    translate( [-width/2-2,  0, lens_z+0.5] ) rotate( [180,-theta,0] ) slider_inside( thick, angle );
    translate( [ width/2-4.5, 0, lens_z-0.25] ) rotate( [180,180-theta,180] ) slider_outside( thick, angle );
    translate( [-width/2+4.5, 0, lens_z-0.25] ) rotate( [0,-theta,0] ) slider_outside( thick, angle );
    translate( [ xoff, 0, lens_z-2] ) lens_holder( (phone_height+5)/2, lens );
    translate( [-xoff, 0, lens_z-2] ) rotate( [0, 0, 180] ) lens_holder( (phone_height+5)/2, lens );
%   translate( [ xoff, 0, lens_z] ) cylinder( h=1, r=lens/2, center=true );
%   translate( [-xoff, 0, lens_z] ) cylinder( h=1, r=lens/2, center=true );
}

