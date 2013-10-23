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
plate="unassembled";

overlap=0.1;
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
function is_print_body( p ) = p == "body" || p == "assembled";
function is_print_optics( p ) = p == "optics";

if( plate == "lens_holders" )
{
    optics_lens_holders( lens );
}
else if( plate == "optics_support" )
{
    optics_support_plate( height, lens );
}
else
{
    if( variant == "C" )
    {
        // Single smooth body
        visor_plate( phone_height, phone_width, plate, lens )
            smooth_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth, lens_phone_offset(lens)-plate_thick );
    }
    if( variant == "D" )
    {
        // Single smooth body, with corner grooves
        visor_plate( phone_height, phone_width, plate, lens )
            grooved_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth, lens_phone_offset(lens)-plate_thick );
    }
    if( variant == "test" )
    {
        difference()
        {
            translate( [ 0, 0, -32 ] ) {
                smooth_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth, lens_phone_offset(lens)-plate_thick );
                if( plate == "assembled" )
                {
                    translate( [ 0, 0, lens_phone_offset( lens )-plate_thick] ) front_lens_plate( lens, height, temple_distance( lens ) );
                }
            }
            translate( [ 0, 0,-0.75*phone_height ] ) cube( 1.5*phone_height, center=true );
            translate( [ 0, 0, 0.75*phone_height+18 ] ) cube( 1.5*phone_height, center=true );
        }
        if( plate != "assembled" )
        {
            translate( [ 0, height+5, 0]  ) front_lens_plate( lens, height, temple_distance( lens ) );
        }
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
            if( plate == "assembled" )
            {
                // remove strap mount supports if assembled
                both_strap_mounts( temple_distance(lens), depth, thick ) remove_strap_support( thick );
            }
            translate( [0, height/2, 7] ) rotate( [ 90, 0, 180 ] ) logo();
        }

        if( plate == "assembled" )
        {
            translate( [ 0, -height/2+thick/2, 1.5*thick ] ) rotate( [ 180, 0, 0 ] ) phone_support_ridge( thick, 52, 32, 3 );
        }
        else
        {
            phone_support_ridge( thick, 52, 32, 3 );
        }
    }
    if( is_print_optics( plate ) )
    {
        optics_plate( front_width, height, lens );
    }
    if( plate == "assembled" )
    {
        optics_assembled( width, height, lens );
        echo( "If this doesn't render correctly, got to advanced preferences and change 'Turn off rendering' to 3000 or greater." );
    }
}

// Plate for printing the lens whole support system
//  width  -   front width of visor
//  height -   front height of visor
//  lens   -   descriptor for the lenses to use
module optics_plate( width, height, lens )
{
    translate( [ 0, height, 0 ] ) front_lens_plate( lens, height, temple_distance( lens ) );
    translate( [ 0,-height, 0 ] ) lens_plate( lens, height, temple_distance( lens ) );
    translate( [ 58, 12, 0] ) holder( lens );
    translate( [ 20, -12, 0] ) holder_cap( lens );
    translate( [-20, 12, 0] ) holder( lens );
    translate( [-58, -12, 0] ) holder_cap( lens );
}

// Plate for printing the lens support plates
//  height -   front height of visor
//  lens   -   descriptor for the lenses to use
module optics_support_plate( height, lens )
{
    translate( [ 0, height/2+5, 0 ] ) front_lens_plate( lens, height, temple_distance( lens ) );
    translate( [ 0,-height/2-5, 0 ] ) lens_plate( lens, height, temple_distance( lens ) );
}

// Plate for printing the lens holders
//  lens   -   descriptor for the lenses to use
module optics_lens_holders( lens )
{
    translate( [ 35, 35, 0] ) holder( lens );
    translate( [ 35,-35, 0] ) holder_cap( lens );
    translate( [-35, 35, 0] ) holder( lens );
    translate( [-35,-35, 0] ) holder_cap( lens );
}

// Display the optics in it's assembled form
//  width -    front width of visor
//  lens  -    descriptor for the lenses to use
module optics_assembled( width, height, lens )
{
    // tweakable
    xoff=IPD_avg/2;
    lens_z=lens_phone_offset( lens );

    translate( [ 0, 0, lens_z-plate_thick] ) front_lens_plate( lens, height, temple_distance( lens ) );
    translate( [ 0, 0, lens_z+rim_thick] ) color( "tan" ) lens_plate( lens, height, temple_distance(lens) );
    translate( [xoff, 0, lens_z] ) union()
    {
        color( "orange" ) translate( [0,0,holder_len+cap_top+fit_gap] ) rotate( [180,0,0] ) holder( lens );
        color( "yellowgreen" ) holder_cap( lens );

 %      translate( [ 0, 0, plate_thick ] ) lens_model( lens );
    }
    translate( [-xoff, 0, lens_z] ) union()
    {
        color( "orange" ) translate( [0,0,holder_len+cap_top+fit_gap] ) rotate( [180,0,0] ) holder( lens );
        color( "yellowgreen" ) holder_cap( lens );

 %      translate( [ 0, 0, plate_thick ] ) lens_model( lens );
    }
}

module logo()
{
    scale([0.6,0.6,1]) import("secondsight_logo.stl");
}

