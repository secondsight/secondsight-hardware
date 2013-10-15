//  Optics-mounting parts for secondsight visor

include <lenses.scad>;

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
lens_diam=37;
thick=3;

lens_plate();

module lens_plate()
{
    rim=3;
    support_diam=lens_diam+2*rim;
    height=support_diam+10;
    width=IPD_max+support_diam+10;
    t_off=3;
    translate( [ 0, 0, thick/2 ] ) difference() {
        intersection()
        {
            cube( [ width, height, thick ], center=true );
            rotate( [0,0,45] ) cube( 0.9*width, center=true );
        }
        translate( [ IPD_min/2, 0, 0 ] ) lens_slot( support_diam, thick );
        translate( [-IPD_max/2, 0, 0 ] ) lens_slot( support_diam, thick );
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

//translate( [-lens_diam, 0, 0] ) lensie( lens_diam, rim );
//translate( [ lens_diam, 0, 0] ) lensie_cap( lens_diam, rim );

module lensie( lens_diam, rim )
{
    support_diam=lens_diam+2*rim;
    support_rad=support_diam/2;
    length=12;
    difference()
    {
        screw( length, support_rad, lens_diam/2, rim );
        translate( [ 0, 0, length/2 ] ) cylinder( h=length+1, r=lens_diam/2, center=true );
        translate( [ 0, 0, length ] ) cylinder( h=2, r=lens_diam/2+1, center=true );
    }
}

module screw( length, t_rad, s_rad, rim )
{
    circ_frac=0.9;
    union()
    {
        linear_extrude( height=length, center=false, convexity=10, twist=-3*360 )
            translate( [(1-circ_frac)*t_rad, 0, 0] ) circle( r=circ_frac*t_rad, $fs=4 );
        translate( [ 0, 0, length/2 ] ) cylinder( h=length, r=s_rad+rim/2, center=true );
    }
}

module lensie_cap( lens_diam, rim )
{
    support_diam=lens_diam+2*rim+0.5;
    support_rad=support_diam/2;
    length=12;
    difference()
    {
        translate( [ 0, 0, 3 ] ) cylinder( h=6, r=(lens_diam+2.5*rim)/2, center=true );    
        translate( [ 0, 0, 1 ] ) screw( length, support_rad, lens_diam/2, rim );
        translate( [ 0, 0, length/2-1 ] ) cylinder( h=length+1, r=lens_diam/2, center=true );
    }
}

// Calculate the nominal distance between the wearer's eye and the phone
//   given a description of the lens.
function nominal_eye_phone_distance(lens) = lens_phone_offset(lens)+eye_lens_distance+lens_thickness(lens);

