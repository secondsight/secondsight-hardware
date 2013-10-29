/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// secondsight Visor project
// Copyright 2013 by secondsight.io, Some Rights Reserved.
//
// secondsight visor - main body shape.

include <polybody.scad>;
include <optic_plate_support.scad>;

// Factor out all of the logic that makes the adds everything except the
// core body shape. In addition to the supplied parameters, this module expects
// two children:
//  child 0: Outer shape of the body
//  child 1: what to remove to make the inner shape of body
//
//  fwidth         - the width of the front of this part of the body
//  fheight        - the height of the front of this part of the body
//  depth          - the measured from front of visor to the back
//  wall           - thickness of the walls of the visor
//  face           - width of the face
//  forehead_depth - distance from forehead touch to temples of viewer
module make_body( fwidth, fheight, depth, wall, face, forehead_depth )
{
    protrude=0.1;
    difference()
    {
        union()
        {
            difference()
            {
                // core shape
                child( 0 );
                // carve out back of viewer
                face( face, depth-forehead_depth, depth );
                nose_slice( fheight, depth, wall );
            }
            // add straps
            both_strap_mounts( face, depth, wall ) strap_mount( wall );
            phone_mount_wide( fwidth, fheight, wall );
        }
        // This must be subtracted last to deal with any added parts that might
        //  intrude on the middle volume.
        child( 1 );
    }
}

// A ledge for the optics support plate to rest on.
//
//  len  - length of this section of the ledge
module support_ledge( len )
{
    depth=3; 
    height=4;
    translate( [ 0, -depth/2, -height/2 ] ) difference()
    {
        cube( [ len, depth, height ], center=true );
        translate( [ 0, -(depth+height)/2-0.6, 0 ] ) rotate( [30,0,0] ) cube( [ len+overlap, depth+height, 3*height ], center=true );
    }
}

// Build body from pieces and the convex polygon
//  fwidth         - the width of the front of this part of the body
//  fheight        - the height of the front of this part of the body
//  depth          - the measured from front of visor to the back
//  wall           - thickness of the walls of the visor
//  face           - width of the face
//  forehead_depth - distance from forehead touch to temples of viewer
//  zoff           - distance from phone to support plate
module smooth_body( fwidth, fheight, depth, wall, face, forehead_depth, zoff )
{
    protrude=0.1;
    phone_top=116;   // TODO: should depend on fwidth
    phone_side=55.8; // TODO: should depend on fheight
    face_top=63;     // TODO: should depend on face
    face_side=52;    // TODO: should depend on height, but not smaller than 50
    
    make_body( fwidth, fheight, depth, wall, face, forehead_depth )
    {
        // core shape
        polybody(
            make_poly_face( fwidth, fheight, phone_top, phone_side ),
            make_poly_face( face, height, face_top, face_side ),
            depth
        );

        // hollow
        translate( [0,0,-protrude] ) difference()
        {
            union()
            {
                polybody(
                    make_poly_inside( fwidth, fheight, phone_top, phone_side, wall ),
                    make_poly_inside( face, height, face_top, face_side, wall ),
                    depth+2*protrude
                );
                support_ledge_slots( face/2-wall, height/2-wall, zoff+protrude );
            }
            support_ledge_diff( face/2-wall, height/2-wall, face_top, face_side, zoff+protrude );
        }
    }
}

// Define the four ledges that support the optics plate.
//
//  x_off  - offset to the sides of the plate.
//  y_off  - offset to the top/bottom of the plate
//  top    - width of the horizontal flat portion of the body
//  side   - height of the vertical flat portion of the body
module support_ledge_diff( x_off, y_off, top, side, z_off )
{
    gap=1.1;
    translate( [ 0,  y_off+gap, z_off ] ) support_ledge( top );
    translate( [ 0,-(y_off+gap), z_off ] ) rotate( [ 0, 0,180 ] ) support_ledge( top );
    translate( [  x_off+gap, 0, z_off ] )  rotate( [ 0, 0,-90 ] ) support_ledge( side+2 );
    translate( [-(x_off+gap), 0, z_off ] ) rotate( [ 0, 0, 90 ] ) support_ledge( side+2 );
}

// Build body from pieces and the concave polygon
//  fwidth         - the width of the front of this part of the body
//  fheight        - the height of the front of this part of the body
//  depth          - the measured from front of visor to the back
//  wall           - thickness of the walls of the visor
//  face           - width of the face
//  forehead_depth - distance from forehead touch to temples of viewer
module grooved_body( fwidth, fheight, depth, wall, face, forehead_depth, zoff )
{
    protrude=0.1;
    phone_top=116;   // TODO: should depend on fwidth
    phone_side=55.8; // TODO: should depend on fheight
    face_top=63;     // TODO: should depend on face
    face_side=52;    // TODO: should depend on height, but not smaller than 50
    
    make_body( fwidth, fheight, depth, wall, face, forehead_depth )
    {
        // core shape
        polybody_concave(
            make_poly_face( fwidth, fheight, phone_top, phone_side ),
            make_poly_face( face, height, face_top, face_side ),
            depth
        );

        // hollow
        translate( [0,0,-protrude] ) difference()
        {
            union()
            {
                polybody_concave(
                    make_poly_inside( fwidth, fheight, phone_top, phone_side, wall ),
                    make_poly_inside( face, height, face_top, face_side, wall ),
                    depth+2*protrude
                );
                support_ledge_slots( face/2-wall, height/2-wall, zoff+protrude );
            }
            support_ledge_diff( face/2-wall, height/2-wall, face_top, face_side, zoff+protrude );
        }
    }
}

strap_fudge=1;
mount_length=40;
overlap=0.1;
function mount_width(wall,strap)=strap+3.5*wall+strap_fudge;
function mount_thickness(wall)=2*wall;
function support_length(thick)=2.5*thick+overlap;

// Take a strap mount as a child and translate/rotate/duplicate as needed to
//  attach to both sides of the visor.
//
//  face  - face width temple-to-temple
//  depth - the measured from front of visor to the back
//  wall  - thickness of the walls of the visor
module both_strap_mounts( face, depth, wall )
{
    d_angle=5;
    z_offset=depth-8;
    x_offset=(face+mount_thickness(wall))/2-0.5;
    translate([ x_offset, 0, z_offset]) rotate([180,-90+d_angle,0]) child( 0 );
    translate([-x_offset, 0, z_offset]) rotate([0,-90-d_angle,0]) child( 0 );
}

// Mount point for the strap.
//   lying flat, must be rotated up to mount.
//  wall    - thickness of the walls of the visor
module strap_mount( wall )
{
    length=mount_length;
    width=mount_width( wall, strap_width );
    thickness=mount_thickness( wall );
    difference()
    {
        union()
        {
            difference()
            {
                cube( [length, width, thickness], center=true );
                // gap for strap
                translate( [length/2 - 2.5*wall,0,0] ) cube( [4*wall, strap_width+strap_fudge, 1.5*thickness], center=true );
            }
            // rod to support strap
            for( x=[length/2 - 2.6*wall, length/2] )
            {
                translate( [x,width/2,0] ) rotate( [90,0,0] ) difference()
                {
                    polyprism( len=width, top=thickness/2, bottom=thickness/2, sides=8 );
                    // holes to increase horizontal rod strength
                    for( pos=[ [-0.2, -0.2], [-0.2,0.2], [0.2,-0.2], [0.2,0.2] ] )
                    {
                        translate( [ pos[0]*thickness, pos[1]*thickness, width/2 ] ) cylinder( h=width+overlap, r=0.2, center=true );
                    }
                }
            }
            // support
            for( y = [ strap_width/4, 0, -strap_width/4 ] )
            {
                translate( [ 2*thickness, y, 0] ) strap_support( thickness );
            }
        }
        translate( [-length/2-wall,0,0] ) rotate([0,-12,0]) cube( [1.5*width,1.5*width,thickness], center=true );
        // holes to increase vertical support strength
        for( pos=[  [0,0], [-0.25, -0.25], [-0.25,0.25], [0.25,-0.25], [0.25,0.25] ] )
        {
            for( y=[ width/2-thickness/2, -width/2+thickness/2 ] )
            {
                translate( [ 0, y, 0 ] ) rotate( [ 0, 90, 0 ] ) translate( [ pos[0]*thickness, pos[1]*thickness, length/4 ] )
                    cylinder( h=length+overlap, r=0.2, center=true );
            }
        }
    }
}

// Define the thin walls used for supports in the gaps in the strap mount.
//
//  thickness - the thickness of the mount hardware.
module strap_support( thickness )
{
    cube( [ support_length( thickness )-2, 0.5, thickness ], center=true );
}

// Define a model that can be differenced from the visor body in the right
// places to remove the supports. Used in the assembled display model.
//
//   wall - thickness of the side wall of the visor
module remove_strap_support( wall )
{
    length=mount_length;
    width=mount_width( wall, strap_width );
    thickness=mount_thickness( wall );
    difference()
    {
        union()
        {
            for( y = [ strap_width/4, 0, -strap_width/4 ] )
            {
                translate( [ 2*thickness+0.5, y, 0] )
                    scale( [0.915,2,1.1] ) strap_support( thickness );
            }
        }
        translate( [length/2 - 2.6*wall,width/2,0] ) rotate( [90,0,0] )
            polyprism( len=width, top=thickness/2, bottom=thickness/2, sides=8 );
        translate( [length/2,width/2,0] ) rotate( [90,0,0] )
            polyprism( len=width, top=thickness/2, bottom=thickness/2, sides=8 );
    }
}

// Define the portions to remove to fit a forehead.
// face_width - across forehead
// depth      - distance from forehead touch to front of visor
// height     - distance from front to back of viewer
module face( face_width, depth, height )
{
    radius=0.75*face_width;
    translate([0,0,radius+depth]) rotate([90,0,0])
        cylinder( h=1.25*height, r=radius, center=true, $fn=32 );
}

// Define the portion that is open around the nose.
//  height - nominal height of the front of the visor
//  depth   - the measured from front of visor to the back
//  wall   - wall thickness
module nose_slice( height, depth, wall )
{
    theta=8;
    slice=32;
    translate( [0,-height/2+0.75*wall,0] )
    intersection()
    {
        union()
        {
            rotate( [0,theta,0] ) translate( [0,0,depth/2] ) cube( [slice, wall*4, 1.2*depth], center=true );
            rotate( [0,-theta,0] ) translate( [0,0,depth/2] ) cube( [slice, wall*4, 1.2*depth], center=true );
        }
        // cut it off slightly above the base
        translate([0,0,wall+depth/2]) cube( depth, center=true );
    }
}

// Convert polygon opposite face distance to radius
function radius_from_side(dist,sides) = dist/cos(180/sides);

//
//  Polygonal prism centered in x-y, with sitting on z-origin.
//  len - length of prism
//  bottom - bottom radius
//  top - top radius
//  sides - number of sides of the polygon
module polyprism( len, bottom, top, sides )
{
    translate( [0,0,len/2] ) rotate( [0,0,180/sides] )
        cylinder( h=len,
                  r1=radius_from_side( bottom, sides ), r2=radius_from_side( top, sides ),
                  center=true, $fn=sides
        );
}

//
//  Polygonal prism hole, expected to be subtracted from a polyprism
//  len    - length of prism
//  bottom - bottom face-distance
//  top    - top face-distance
//  wall   - thickness of remaining wall
//  sides  - number of sides of the polygon
module polyprism_hole( len, bottom, top, wall, sides )
{
    fudge=0.04;
    translate( [0,0,(len-fudge)/2] ) rotate( [0,0,180/sides] )
        cylinder( h=len+fudge,
                  r1=radius_from_side( bottom, sides )-wall, r2=radius_from_side( top, sides )-wall,
                  center=true, $fn=sides
        );
}

