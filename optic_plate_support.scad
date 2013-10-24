// secondsight Visor project
// Copyright 2013 by secondsight.io, Some Rights Reserved.
//
//  Define the tab/slot system for attaching the optics plate to the body.

// Fit factors
slide_gap=0.25;
fit_gap=0.15;

// Tab sizing
tab_length=3;
tab_height=1;

module support_slot( depth )
{
    long=tab_length+2*slide_gap;
    height=tab_height+2*fit_gap;
    translate( [ 0, 0, height/2 ] ) cube( [ long, depth, height ], center=true );
}


module support_tab( depth )
{
    long=tab_length;
    height=tab_height;
    translate( [ 0, 0, height/2 ] ) cube( [ long, depth, height ], center=true );
}

module support_ledge_slots( x_off, y_off, z_off )
{
    gap=1.1;
    depth=2;
    spread=10;
    drop=15+gap;
    translate( [-spread, y_off+gap, z_off+0.1] ) support_slot( depth );
    translate( [ spread, y_off+gap, z_off+0.1] ) support_slot( depth );
    translate( [ x_off+gap, -drop, z_off+0.1] ) rotate( [ 0, 0, 90 ] ) support_slot( depth );
    translate( [-(x_off+gap), -drop, z_off+0.1] ) rotate( [ 0, 0, 90 ] ) support_slot( depth );
}

module support_ledge_tabs( x_off, y_off, z_off )
{
    gap=1.1;
    fudge=0.1;
    depth=gap+1-fit_gap;
    spread=10;
    drop=15;
    gap_off=depth/2-fudge;
    translate( [-spread, y_off+gap_off, z_off+fudge] ) support_tab( depth );
    translate( [ spread, y_off+gap_off, z_off+fudge] ) support_tab( depth );
    translate( [ x_off+gap_off, -drop, z_off+fudge] )  rotate( [ 0, 0, 90 ] ) support_tab( depth );
    translate( [-(x_off+gap_off), -drop, z_off+fudge] ) rotate( [ 0, 0, 90 ] ) support_tab( depth );
}
