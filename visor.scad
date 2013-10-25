// secondsight Visor project
// Copyright 2013 by secondsight.io, Some Rights Reserved.
//
// Main definition of the secondsight visor

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

// Choose a variant, only uncomment one.

variant="C";
//variant="D";

// Choose a plate, only uncomment one.

//plate="body";
//plate="optics_support";
//plate="lens_holders";
//plate="full_optics";
plate="assembled";
//plate="test";

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

// Dispatch to appropriate plate-building code.
//
if( plate == "lens_holders" )
{
    optics_lens_holders( lens );
}
else if( plate == "optics_support" )
{
    optics_support_plate( height, lens );
}
else if( plate == "full_optics" )
{
    full_optics_plate( phone_height, phone_width, lens );
}
else if( plate == "body" )
{
    if( variant == "C" )
    {
        body_plate( phone_height, phone_width, thick )
            smooth_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth, lens_phone_offset(lens)-plate_thick );
    }
    else if( variant == "D" )
    {
        body_plate( phone_height, phone_width, thick )
            grooved_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth, lens_phone_offset(lens)-plate_thick );
    }
}
else if( plate == "assembled" )
{
    if( variant == "C" )
    {
        assembled_plate( width, height, thick, lens )
            smooth_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth, lens_phone_offset(lens)-plate_thick );
    }
    else if( variant == "D" )
    {
        assembled_plate( width, height, thick, lens )
            grooved_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth, lens_phone_offset(lens)-plate_thick );
    }
}
else if( plate == "test" )
{
//        optics_plate_test();
    difference()
    {
        translate( [0,0,-depth/2-10] ) smooth_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth, lens_phone_offset(lens)-plate_thick );
        translate( [0,0,-depth/2] ) cube( [phone_height, phone_height, depth], center=true );
    }
}
// end of plate dispatch

// Test plate for the optics support
module optics_plate_test()
{
    difference()
    {
        translate( [ 0, 0, -32 ] ) {
            smooth_body( phone_height, phone_width, depth, thick, temple_distance(lens), forehead_depth, lens_phone_offset(lens)-plate_thick );
            if( plate == "assembled" )
            {
                color( "tan" ) translate( [ 0, 0, lens_phone_offset( lens )-plate_thick] ) front_lens_plate( lens, height, temple_distance( lens ) );
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

// Put together the plate containing the visor body
//  width -   front width of the visor
//  height -  height of the visor
//  wall   -  thickness of the body wall
//  child(0) is the definition of the body
module body_plate( width, height, wall )
{
    difference()
    {
        child(0);
        translate( [0, height/2, 7] ) rotate( [ 90, 0, 180 ] ) logo();
    }

    phone_support_ridge( wall, 52, 32, 3 );
}

// Plate showing the assembled visor
//  width  -  front width of the visor
//  height -  height of the visor
//  wall   -  thickness of the body wall
//  lens   -  lens descriptor
//  child(0) is the definition of the body
module assembled_plate( width, height, wall, lens )
{
    difference()
    {
        child(0);
        // remove strap mount supports if assembled
        both_strap_mounts( temple_distance(lens), depth, wall ) remove_strap_support( wall );
        translate( [0, height/2, 7] ) rotate( [ 90, 0, 180 ] ) logo();
    }

    translate( [ 0, -height/2, 1.5*wall ] ) rotate( [ 180, 0, 0 ] )
        color( "goldenrod" ) phone_support_ridge( wall, 52, 32, 3 );

    optics_assembled( width, height, lens );
    echo( "If this doesn't render correctly, go to advanced preferences and change 'Turn off rendering' to 3000 or greater." );
}

// Plate for printing the lens whole support system
//  width  -   front width of visor
//  height -   front height of visor
//  lens   -   descriptor for the lenses to use
module full_optics_plate( width, height, lens )
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

// Build the logo to be diffed.
module logo()
{
    scale([0.6,0.6,1]) import("secondsight_logo.stl");
}

