// Definition of the aetherAR secondsight visor

// Use dimensions for Galaxy S4
//    Dimensions are portrait mode.
phone_width=69.8;
phone_height=136.6;
phone_thickness=7.9;
view_width=65;
view_height=110;

IPD_min=52;
IPD_max=78;
IPD_avg_male=64.7;
IPD_avg_female=62.3;
IPD_avg=63;

// Potentially user-specific data
include <user_params.scad>;

variant="C";
plate="assembled";

strap_width=40;
front_width=126;
height=67;
thick=3;
lens_name="b&l 35 5x";
//lens_name="edmund 25x50";

include <lenses.scad>;
lens=lens_descriptor( lens_name );

include <visor_optics_mount.scad>;

eyes=nominal_eye_phone_distance( lens );
depth=eyes-eye_forehead_offset+forehead_depth;

include <visor_body.scad>;
include <visor_elastic_mount.scad>;

function calc_temple_distance( lens ) = lens_diam(lens)+IPD_max+2*thick+12; // 12 is for optics mount hardware.
function temple_distance( lens ) = max(user_temple_distance,calc_temple_distance( lens ));
function side_slope( width, lens ) = atan2( (width-temple_distance(lens))/2, depth );
function is_print_body( p ) = p == "body" || p == "both" || p == "assembled";
function is_print_optics( p ) = p == "optics" || p == "both";

if( variant == "C" )
{
    // Single smooth body
    visor_plate( phone_height, phone_width, plate, lens )
        smooth_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth );
}
if( variant == "D" )
{
    // Single smooth body, with corner grooves
    visor_plate( phone_height, phone_width, plate, lens )
        grooved_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth );
}
if( variant == "test" )
{
//    rotate( [0,0,90] ) assign( angle=side_slope( phone_height, lens ) )
//    {
//        lens_holder( (phone_height+5)/2, lens_descriptor( "b&l 35 5x" ) );
//    }
    intersection()
    {
        difference()
        {
            translate( [0,0,-60] )
            visor_plate( phone_height, phone_width, "body", lens )
                grooved_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth );
            translate( [ 0.1*phone_height, 0, phone_height/2+3 ] ) cube( phone_height, center=true );
        }
        translate( [ -phone_height/2, 0, phone_height/2 ] ) cube( phone_height, center=true );
    }
}


// Everything to be printed for the visor
//  width -   front width of the visor
//  height -  height of the visor
//  plate -   indicator of which set of components to print
//  lens  -   lens descriptor
//  child(0) is the definition of the body
module visor_plate( width, height, plate, lens )
{
    if( is_print_body( plate ) )
    {
        difference()
        {
            child(0);
//            optics_slots( width, eyes, thick );
            if( plate == "assembled" )
            {
                // remove strap mount supports if assembled
                both_strap_mounts( temple_distance(lens), depth, thick ) remove_strap_support( thick );
            }
            translate( [0, height/2, 7] ) rotate( [ 90, 0, 180 ] ) logo();
        }
    }
    if( is_print_optics( plate ) )
    {
        optics_plate( front_width, height, lens );
    }
    if( plate == "assembled" )
    {
        optics_assembled( width, height, lens );
    }
}

// Plate for printing the lenses
//  width  -   front width of visor
//  height -   front height of visor
//  lens   -   descriptor for the lenses to use
module optics_plate( width, height, lens )
{
    angle=side_slope( width, lens );
    xoff=lens_diam( lens ) < 40 ? 42 : 38;
//    translate( [ 10,  20, 0] ) slider_inside( thick, angle );
//    translate( [-10,  20, 0] ) slider_inside( thick, angle );
//    translate( [ 10, -20, 0] ) slider_outside( thick, angle );
//    translate( [-10, -20, 0] ) slider_outside( thick, angle );
//    translate( [-xoff,  5, 0] ) lens_holder( (phone_height+5)/2, lens );
//    translate( [ xoff, -5, 0] ) rotate( [0, 0, 180] ) lens_holder( (phone_height+5)/2, lens );

    translate( [ 0, -height/2-10, 0] ) phone_support_ridge( thick, 52, 32, 3 );
}

// Display the optics in it's assembled form
//  width -    front width of visor
//  lens  -    descriptor for the lenses to use
module optics_assembled( width, height, lens )
{
    // tweakable
    xoff=IPD_avg/2;
    lens_z=lens_phone_offset( lens );

    // non-tweakable
    dlens=lens_diam( lens );
    angle=side_slope( width, lens );
    theta=90-angle;
    mount_x=width/2-lens_z*sin(angle);

//    // Left side assembly
//    color( "Khaki" ) translate( [-mount_x+5,  0, lens_z] ) rotate( [0, theta,180] ) slider_inside( thick, angle );
//    color( "Tan" )   translate( [-mount_x-2, 0, lens_z] ) rotate( [0,180+theta,180] ) slider_outside( thick, angle );
//    color( "Olive" ) translate( [-xoff, 0, lens_z-2] ) rotate( [0, 0, 180] ) lens_holder( (phone_height+5)/2, lens );
//    // right side assembly
//    color( "Khaki" ) translate( [ mount_x-5,  0, lens_z] ) rotate( [0, theta,0] ) slider_inside( thick, angle );
//    color( "Tan" )   translate( [ mount_x+2, 0, lens_z] ) rotate( [0,180+theta,0] ) slider_outside( thick, angle );
//    color( "Olive" ) translate( [ xoff, 0, lens_z-2] ) lens_holder( (phone_height+5)/2, lens );
//
//    color( "Orange" ) translate( [ 0, -height/2+1, 5] ) rotate( [ 180, 0, 0 ] ) phone_support_ridge( thick, 52, 32, 3 );

    // lenses
%   translate( [-xoff, 0, lens_z] ) cylinder( h=1, r=dlens/2, center=true );
%   translate( [ xoff, 0, lens_z] ) cylinder( h=1, r=dlens/2, center=true );
}

module logo()
{
    scale([0.6,0.6,1]) import("secondsight_logo.stl");
}

