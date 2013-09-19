slot_width=10;
min_bfl=25;
max_bfl=45;

// Optics
lens_phone_distance=40;
eye_lens_distance=12;
lens_thickness=5;
lens_diameter=25;

// Other
gap=0.25;
inner_height=5;
inner_width=4;

function nominal_eye_phone_distance() = lens_phone_distance+eye_lens_distance+lens_thickness;

//lens_holder( 70, lens_diameter );
// angle calculated from visor.scad parameters.
angle=6.9497;
translate( [-15, 20, 0] ) slider_inside( 3, angle );
translate( [-15,-20, 0] ) slider_outside( 3, angle );

module lens_holder( half_width, lens )
{
    arm_len=half_width-lens;
    rim=1.5;
    rim_offset=1.25*rim;
    translate( [0,0,inner_width/2] ) union()
    {
        difference()
        {
            translate( [rim_offset,0,0] ) cylinder( h=inner_width, r=lens/2+rim, center=true );
            cylinder( h=inner_width+1, r=lens/2, center=true );
            translate( [-0.4*lens,0,0] ) cylinder( h=inner_width+1, r=lens/2, center=true );
        }
        translate( [(arm_len+lens)/2, 0, -gap/2 ] ) cube( [ arm_len, inner_height-gap, inner_width-gap ], center=true );
        translate( [arm_len+lens/2, 0, -gap/2 ] ) cylinder( h=inner_width-gap, r=(inner_height-gap)/2, center=true, $fn=8 );
    }
}

module slider_outside( wall, angle )
{
    b_thick=2;
    inset=b_thick + 0.9*wall;
    length=10;
    difference()
    {
        union()
        {
            translate( [0,0,b_thick/2] ) cube( [ length, slot_width+2*b_thick, b_thick ], center=true );
            rotate( [angle,0,0] ) translate( [0,0,(inset+b_thick)/2] ) cube( [ length, slot_width-gap/2, inset ], center=true );
        }
        rotate( [angle,0,0] ) translate( [0,0,2.5] ) cube( [ inner_width+3, inner_height+3, inset+2 ], center=true );
    }
}

module slider_inside( wall,angle )
{
    b_thick=2;
    inset=2*b_thick + 0.9*wall;
    length=10;
    difference()
    {
        union()
        {
            translate( [0,0,b_thick/2] ) cube( [ length, slot_width+2*b_thick, b_thick ], center=true );
            rotate( [angle,0,0] ) translate( [0,0,(inset+b_thick)/2] ) cube( [ inner_width+3-gap, inner_height+3-gap, inset ], center=true );
        }
        rotate( [angle,0,0] ) translate( [0,0,3.5] ) cube( [ inner_width, inner_height, inset+2 ], center=true );
    }
}

module optics_slots( fwidth, z_eyes, wall )
{
    translate( [ fwidth/2-wall, 0, 0] ) single_optics_mount_slot( z_eyes, wall );
    translate( [-fwidth/2+wall, 0, 0] ) single_optics_mount_slot( z_eyes, wall );
}

// Define one slot
module single_optics_mount_slot( z_eyes, wall )
{
    hull()
    {
        for( z = [ min_bfl, z_eyes-eye_lens_distance] )
        {
            translate( [0, 0, z] ) rotate( [0,90,0] ) scale( [0.5,1,1] ) cylinder( h=wall*4, r=slot_width/2, center=true );
        }
    }
}

