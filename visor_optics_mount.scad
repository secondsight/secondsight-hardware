//  Optics-mounting parts for secondsight visor

include <lenses.scad>;
include <MCAD/regular_shapes.scad>;

slot_width=10;
min_bfl=20;

// Optics
eye_lens_distance=12;

// Other
gap=0.25;
inner_height=5;
inner_width=4;

IPD_max=78;
IPD_min=52;
IPD_avg=63;
lens_diam=37;
thick=3;

bl_lens=lens_descriptor( "b&l 35 5x" );
lens_plate( bl_lens, 67-2*3, 126-2*3 );
//% translate( [ IPD_avg/2, 0, 0 ] ) cylinder( h=1, r=lens_diam(bl_lens)/2, center=true );
//% translate( [-IPD_avg/2, 0, 0 ] ) cylinder( h=1, r=lens_diam(bl_lens)/2, center=true );

module lens_plate( lens, height, width )
{
    diam=lens_diam(lens)+1;
    t_off=3;
    translate( [ 0, 0, thick/2 ] ) difference() {
        intersection()
        {
            cube( [ width, height, thick ], center=true );
            rotate( [0,0,45] ) cube( 0.9*width, center=true );
        }
        translate( [ IPD_min/2, 0, 0 ] ) lens_slot( diam, thick );
        translate( [-IPD_max/2, 0, 0 ] ) lens_slot( diam, thick );
    }
}

module lens_slot( diam, thick )
{
    overlap=0.1;
    hull()
    {
        cylinder( h=thick+overlap, r=diam/2, center=true );
        translate( [(IPD_max-IPD_min)/2, 0, 0 ] ) cylinder( h=thick+overlap, r=diam/2, center=true );
    }
}

translate( [ 30, 2*lens_diam(bl_lens), 0] ) lensie( bl_lens );
translate( [-30, 2*lens_diam(bl_lens), 0] ) lensie_cap( bl_lens );

module lensie( lens )
{
    rad=lens_diam(lens)/2;
    difference()
    {
        cylinder_tube( height=eye_lens_distance, radius=rad+1, wall=1.5 );
        translate( [ 0, 0, eye_lens_distance-0.2 ] ) cylinder( h=2*rad, r2=2*rad, r1=0, center=true );
    }
}

module lensie_cap( lens )
{
    rad=lens_diam(lens)/2;

    union()
    {
        cylinder_tube( height=5, radius=rad+3+0.25, wall=2 );
        difference()
        {
            cylinder_tube( height=2, radius=rad+3+0.25, wall=3.75 );
            translate( [ 0, 0, 2-0.2 ] ) cylinder( h=2*rad, r2=2*rad, r1=0, center=true );
        }
    }
}

// Calculate the nominal distance between the wearer's eye and the phone
//   given a description of the lens.
function nominal_eye_phone_distance(lens) = lens_phone_offset(lens)+eye_lens_distance+lens_thickness(lens);

