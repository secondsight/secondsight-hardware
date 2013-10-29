// secondsight Visor project
// Copyright 2013 by secondsight.io, Some Rights Reserved.
//
//  Optics-mounting parts for secondsight visor

include <lenses.scad>;
include <MCAD/regular_shapes.scad>;
include <polybody.scad>;
include <optic_plate_support.scad>;
include <tuning.scad>;

slot_width=10;
min_bfl=20;

// Optics
eye_lens_distance=12;

// Other
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

plate_thick=2;

// Calculate the positions of the small pins
function x_off_sp(wid,wall)=0.46*wid-wall;
function y_off_sp(h)=-0.3*h;
function y_off_lp(h)=h/4;

module support_test()
{
    pin_length=rim_thick+plate_thick+fit_gap+1;
    translate( [ 0, 20, plate_thick/2 ] ) union()
    {
        cube( [ 35, 35, plate_thick ], center=true );

        translate( [ 0, 0, plate_thick/2+rim_thick/2 ] ) rect_oval_tube( 3+1, 6, rim_thick+overlap, 1 );
        translate( [ 0, 10, 0] ) support_pin( pin_length, 3 );
        translate( [-10, -10, 0] ) support_pin( pin_length, 2 );
        translate( [ 10, -10, 0] ) support_pin( pin_length, 2 );
    }


    translate( [ 0, -20, plate_thick/2 ] ) difference()
    {
        cube( [ 35, 35, plate_thick ], center=true );
        translate( [  0, 10, -thick/2] ) support_hole( thick, 3 );
        translate( [-10,-10, -thick/2] ) support_hole( thick, 2 );
        translate( [ 10,-10, -thick/2] ) support_hole( thick, 2 );
    }
}

// Front plate of the lens support system.
//
//  lens   - lens descriptor
//  height - height of the plate
//  width  - width of the plate
//  thick  - optional thickness of the plate, defaults to 2
module front_lens_plate( lens, height, width, thick=plate_thick )
{
    diam=lens_diam(lens)+holder_wall;
    wall=3;
    face=make_poly_inside( wid=width, ht=height, horiz=63, vert=52, wall=wall );
    outer_rad=diam/2+holder_wall+cap_wall;
    offset=(IPD_max-IPD_min)/2;
    pin_length=rim_thick+thick+fit_gap+1;
    difference()
    {
        union()
        {
            polybody( face, face, thick );
            // rim around lens holes
            translate( [ 0, 0, thick+rim_thick/2 ] ) eye_positions( offset )
                rect_oval_tube( outer_rad+1+slide_gap, offset, rim_thick+overlap, 1 );

            // support pins
            translate( [ 0, y_off_lp(height), thick] ) support_pin( pin_length, 3 );
            translate( [-x_off_sp(width,wall), y_off_sp(height), thick] ) support_pin( pin_length, 2 );
            translate( [ x_off_sp(width,wall), y_off_sp(height), thick] ) support_pin( pin_length, 2 );

            // support tabs

            support_ledge_tabs( _width(face)/2, _height(face)/2, 0 );
        }

        // slots
        translate( [ 0, 0, thick/2 ] ) eye_positions( offset ) rect_oval( diam/2, offset, thick+overlap );
        // nose
        translate( [ 0, -2, (thick+rim_thick+overlap)/2 ] ) plate_nose_slice( height, thick+rim_thick+overlap );
    }
}

// Hole for the support pin to connect to other plate
//
// length - length of the hole
// rad    - radius of the hole
module support_hole( length, rad )
{
    $fn=16;
    lip=rad < 3 ? rad/5 : 0.5;
    union()
    {
        translate( [ 0, 0, length/2] )              cylinder( h=length+overlap, r=rad+slide_gap, center=true );
        translate( [ 0, 0,  (length+overlap-0.5)] ) cylinder( h=0.8*length+overlap, r1=rad+fit_gap, r2=rad+lip+fit_gap, center=true );
        translate( [ 0, 0, -(overlap-0.5)] )        cylinder( h=0.8*length+overlap, r1=rad+lip+fit_gap, r2=rad+fit_gap, center=true );
    }
}

// Pin to connect the two plates
//
// length - length of the pin
// rad    - radius of the pin
module support_pin( length, rad )
{
    $fn=16;
    lip=rad < 3 ? 0.25 : 0.5;
    gap=rad < 3 ? rad/3.5 : rad/4;
    translate( [ 0, 0, length/2 ] ) difference()
    {
        union()
        {
            cylinder( h=length+overlap, r=rad, center=true );
            translate( [ 0, 0, length/2+overlap-0.75] ) union()
            {
                if( rad < 3 )
                {
                    cylinder( h=0.5, r=rad+fit_gap, center=true );
                }
                else
                {
                    cylinder( h=0.5, r1=rad-overlap, r2=rad+lip, center=true );
                    translate( [ 0, 0, 0.5 ] ) cylinder( h=0.5, r1=rad+lip, r2=rad, center=true );
                }
            }
        }
        translate( [ 0, 0, (length-rad)/2 ] ) {
            rotate( [ 0, 90, 0 ] ) rect_oval( gap, rad+1, 2*(rad+1) );
            cylinder( h=1.25*rad+1, r=rad/2, center=true );
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
module lens_plate( lens, height, width, thick=plate_thick )
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
        // supports
        translate( [ 0, y_off_lp(height), 0 ] ) support_hole( thick, 3 );
        translate( [-x_off_sp(width,wall), y_off_sp(height), 0 ] ) support_hole( thick, 2 );
        translate( [ x_off_sp(width,wall), y_off_sp(height), 0 ] ) support_hole( thick, 2 );
    }
}

// Negative space to remove from the lens plate for the nose.
//
// height - height of inside of the visor
// thick  - thickness of the plate
module plate_nose_slice( height, thick )
{
    h_nose=0.5*height;
    top=11;
    bottom=30;
    // eyeballed from the visor_body code. I wonder how I can make this
    //  dependency explicit (without horribly convoluting the code).
    bottom2=51;
    linear_extrude( height=thick+overlap, center=true, convexity=10 )
        projection( cut=false ) rotate( [ -90, 0, 0] ) union()
    {
        // bridge of the nose.
        translate( [ 0, 0, -h_nose/2 ] ) cylinder( h=h_nose, r1=bottom/2, r2=top/2, center=true );
        // match with the lower opening in the body.
        translate( [ 0, 0, -0.65*h_nose ] ) cylinder( h=0.7*h_nose, r1=bottom2/2, r2=top/2, center=true );
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

// Combination of a rectangle and two circles extrude to height.
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

// Tube version of the combination of a rectangle and two circles extrude to
//   height.
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

