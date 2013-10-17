//  Optics-mounting parts for secondsight visor

include <lenses.scad>;
include <MCAD/regular_shapes.scad>;
include <polybody.scad>;

slot_width=10;
min_bfl=20;

// Optics
eye_lens_distance=12;

// Other
slide_gap=0.25;
fit_gap=0.15;
overlap=0.1;
holder_wall=1;
holder_len=eye_lens_distance+1;
cap_len=7;
cap_wall=2;
cap_top=1.5;
rim_thick=3;
thin_wall=1;

IPD_max=78;
IPD_min=52;
IPD_avg=63;
thick=3;
assembled=false;

bl_lens=lens_descriptor( "b&l 35 5x" );
if( assembled )
{
    color( "lightgreen" ) lens_plate( bl_lens, 67, 133 );
    translate( [IPD_avg/2, 0, -rim_thick] )
        color( "orange" ) union()
    {
        translate( [0,0,holder_len+cap_top+fit_gap] ) rotate( [180,0,0] ) holder( bl_lens );
        holder_cap( bl_lens );
    }
    translate( [-IPD_avg/2, 0, -rim_thick] )
        color( "orange" ) union()
    {
        translate( [0,0,holder_len+cap_top+fit_gap] ) rotate( [180,0,0] ) holder( bl_lens );
        holder_cap( bl_lens );
    }
}
else
{
    lens_plate( bl_lens, 67, 133 );
//    translate( [ 30, 60, 0] ) holder( bl_lens );
//    translate( [-30, 60, 0] ) holder_cap( bl_lens );
//    translate( [ 30,-60, 0] ) holder( bl_lens );
//    translate( [-30,-60, 0] ) holder_cap( bl_lens );
}

// Plate supporting lens holders
//
// lens   - lens descriptor
// height - height of plate
// width  - width of plate
module lens_plate( lens, height, width )
{
    diam=lens_diam(lens)+holder_wall;
    face=make_poly_inside( wid=width, ht=height, horiz=63, vert=52, wall=3 );
    p_thick=1.5; // thick
    difference()
    {
        polybody( face, face, p_thick );

        translate( [ IPD_min/2, 0, p_thick/2 ] ) lens_slot( diam+thin_wall+2*fit_gap, thick );
        translate( [-IPD_min/2, 0, p_thick/2 ] ) rotate( [ 0, 0, 180 ] ) lens_slot( diam+thin_wall+2*fit_gap, thick );
        // nose
        translate( [ 0, -0.4*height, p_thick/2 ] ) plate_nose_slice( height, p_thick );
    }
}

module plate_nose_slice( height, thick )
{
    linear_extrude( height=thick+0.2, center=true, convexity=10 )
        projection( cut=false ) rotate( [ -90, 0, 0] ) union()
    {
        cylinder( h=0.45*height, r1=15, r2=3, center=true );
        translate( [0,0,0.45*height/2] ) sphere( r=3, center=true );
    }
}

// Definition of the slot where the lens holder mounts
//
// diam  - lens diameter
// thick - thickness of plate
// wall  - thickness extra wall for holder cap
module lens_slot( diam, thick, wall=1 )
{
    height=thick+overlap;
    hull()
    {
        translate( [-wall/2, 0, 0 ] ) cylinder( h=height, r=diam/2, center=true );
        translate( [(IPD_max-IPD_min)/2+wall, 0, 0 ] ) cylinder( h=height, r=diam/2, center=true );
    }
}

// Lens holder (eye side)
//
// lens - descriptor for the lens we're using
module holder( lens )
{
    rad=lens_rad(lens);
    eye_rim=2;
    eye_thick=1;
    difference()
    {
        union()
        {
            cylinder_tube( height=holder_len, radius=rad+holder_wall, wall=holder_wall+slide_gap );
            cylinder_tube( height=eye_thick, radius=rad+holder_wall+eye_rim, wall=holder_wall+eye_rim );
        }
        translate( [ 0, 0, holder_len] ) rotate( [180,0,0] ) lens_model( lens );
        translate( [ 0, 0, holder_len-lens_rim_thickness(lens)/2] )
            cylinder( h=lens_rim_thickness(lens)+slide_gap, r=lens_rad(lens)+slide_gap );
    }
}

// Cap for lens holder
//
// lens - descriptor for the lens we're using
module holder_cap( lens )
{
    rad=lens_rad(lens);
    outer_rad=rad+holder_wall+cap_wall;

    intersection()
    {
        union()
        {
            cylinder_tube( height=cap_len, radius=rad+holder_wall+thin_wall+fit_gap, wall=thin_wall );
            difference()
            {
                cylinder_tube( height=rim_thick, radius=outer_rad, wall=holder_wall+cap_wall+thin_wall );
                translate( [ 0, 0, cap_top] ) lens_model( lens );
                translate( [ 0, 0, lens_rim_thickness(lens)/2] )
                    cylinder( h=lens_rim_thickness(lens)+slide_gap, r=rad+slide_gap );
            }
        }
        union()
        {
            translate( [ 0, 0, cap_len/2+rim_thick ] )
                cube( [ 2*outer_rad, 2*rad+thin_wall, cap_len ], center=true );
            cube( [ 2*outer_rad, 2*outer_rad, 2*rim_thick ], center=true );
        }
    }
}

// Calculate the nominal distance between the wearer's eye and the phone
//   given a description of the lens.
function nominal_eye_phone_distance(lens) = lens_phone_offset(lens)+eye_lens_distance+lens_thickness(lens);

