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

clip_width=5;
clip_thick=2;
plate_thick=2;

module plate_clip()
{
    clip_arm=5;
    width=clip_width-fit_gap;
    translate( [ 0, 0, clip_width/2 ] ) difference()
    {
        cube( [ rim_thick+2*(clip_thick+plate_thick)+fit_gap, clip_arm, width ], center=true ); 
        translate( [ 0, -clip_thick, 0 ] ) cube( [ rim_thick+2*plate_thick+fit_gap, clip_arm, width+overlap ], center=true ); 
    }
}

module front_lens_plate( lens, height, width, thick=2 )
{
    diam=lens_diam(lens)+holder_wall;
    wall=3;
    face=make_poly_inside( wid=width, ht=height, horiz=63, vert=52, wall=wall );
    outer_rad=diam/2+holder_wall+cap_wall;
    offset=(IPD_max-IPD_min)/2;
    difference()
    {
        union()
        {
            polybody( face, face, thick );
            translate( [ 0, 0, thick+rim_thick/2 ] ) eye_positions( offset )
                rect_oval_tube( outer_rad+1, offset, rim_thick+overlap, 1-slide_gap );
        }

        // slots
        translate( [ 0, 0, thick/2 ] ) eye_positions( offset ) rect_oval( diam/2, offset, thick+overlap );
        // nose
        translate( [ 0, -2, thick/2 ] ) plate_nose_slice( height, p_thick );
        // clips
        translate( [ 0, 0, thick/2 ] ) union()
        {
            translate( [ 0, height/2-wall-1+overlap, 0 ] ) cube( [ clip_width, clip_thick, thick+overlap ], center=true );
            translate( [ width/2-wall-1+overlap, 0, 0 ] )  cube( [ clip_thick, clip_width, thick+overlap ], center=true );
            translate( [-width/2+wall+1-overlap, 0, 0 ] )  cube( [ clip_thick, clip_width, thick+overlap ], center=true );
        }
    }
}

// Position the child shape in two places, one for each eye
module eye_positions( offset )
{
    translate( [ IPD_min/2+offset/2, 0, 0 ] ) child(0);
    translate( [-IPD_min/2-offset/2, 0, 0 ] ) mirror( [ 1, 0, 0 ] ) child(0);
}

// Plate supporting lens holders
//
// lens   - lens descriptor
// height - height of plate
// width  - width of plate
// thick  - thickness of the plate
module lens_plate( lens, height, width, thick=2 )
{
    wall=3;
    face=make_poly_inside( wid=width, ht=height, horiz=63, vert=52, wall=wall );
    offset=(IPD_max-IPD_min)/2;
    diam=lens_diam(lens)+holder_wall;
    radius=(diam+thin_wall)/2+slide_gap;
    difference()
    {
        polybody( face, face, thick );

        // lens slots
        translate( [ 0, 0, thick/2 ] ) eye_positions( offset ) rect_oval( radius, offset, thick+overlap );
        // nose
        translate( [ 0, 2.8, thick/2 ] ) plate_nose_slice( height, thick );
        // clips
        translate( [ 0, 0, thick/2 ] ) union()
        {
            translate( [ 0, height/2-wall-1+overlap, 0 ] ) cube( [ 5, 2, thick+overlap ], center=true );
            translate( [ width/2-wall-1+overlap, 0, 0 ] ) cube( [ 2, 5, thick+overlap ], center=true );
            translate( [-width/2+wall+1-overlap, 0, 0 ] ) cube( [ 2, 5, thick+overlap ], center=true );
        }
    }
}

// Negative space to remove from the lens plate for the nose.
//
// height - height of inside of the visor
// thick  - thickness of the plate
module plate_nose_slice( height, thick )
{
    h_nose=0.5*height;
    top=8;
    bottom=30;
    linear_extrude( height=thick+overlap, center=true, convexity=10 )
        projection( cut=false ) rotate( [ -90, 0, 0] ) union()
    {
        translate( [ 0, 0, -h_nose/2 ] ) cylinder( h=h_nose, r1=bottom/2, r2=top/2, center=true );
        sphere( r=top/2, center=true );
    }
}

// Definition of the slot where the lens holder mounts
//
// diam  - lens diameter
// thick - thickness of plate
// wall  - thickness extra wall for holder cap
module lens_slot( diam, thick, wall=1 )
{
    offset = (IPD_max-IPD_min)/2+wall;
    translate( [ offset/2, 0, 0 ] ) rect_oval( diam/2, offset, thick );
}

//
// radius - radius of the circles at each end
// offset - distance between the centers of the circles
// height - height of the structure
module rect_oval( radius, offset, height )
{
    hull()
    {
        translate( [-offset/2, 0, 0 ] ) cylinder( h=height, r=radius, center=true );
        translate( [ offset/2, 0, 0 ] ) cylinder( h=height, r=radius, center=true );
    }
}

//
// radius - radius of the circles at each end
// offset - distance between the centers of the circles
// height - height of the structure
// wall   - thickness of tube wall
module rect_oval_tube( radius, offset, height, wall )
{
    difference()
    {
        rect_oval( radius, offset, height, wall );
        rect_oval( radius-wall, offset, height+overlap, wall );
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

