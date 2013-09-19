slot_width=10;
min_bfl=25;
max_bfl=45;

// Optics
lens_phone_distance=40;
eye_lens_distance=12;
lens_thickness=5;
lens_diameter=25;

// Other
gap=0.5;
inner_height=slot_width-5;
inner_width=4;

lens_holder( 70, lens_diameter );
//translate( [-15, 20, 0] ) slider_inside( 3 );
//translate( [-15,-20, 0] ) slider_outside( 3 );

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
        }
        translate( [(arm_len+lens)/2, 0, -gap/2 ] ) cube( [ arm_len, inner_height-gap, inner_width-gap ], center=true );
        translate( [arm_len+lens/2, 0, -gap/2 ] ) cylinder( h=inner_width-gap, r=(inner_height-gap)/2, center=true, $fn=8 );
    }
}

module slider_outside( wall )
{
    thick=2;
    inset=thick + 0.9*wall;
    length=10;
    difference()
    {
        union()
        {
            translate( [0,0,thick/2] ) cube( [ length, slot_width+2*thick, thick ], center=true );
            translate( [0,0,inset/2] ) cube( [ length, slot_width-gap/2, inset ], center=true );
            translate( [-length/2,0,0] ) tab( wall, thick );
            translate( [ length/2,0,0] ) tab( wall, thick );
        }
        translate( [0,0,2.5] ) cube( [ inner_width+3, inner_height+3, inset+2 ], center=true );
    }
}

module slider_inside( wall )
{
    thick=2;
    inset=2*thick + 0.9*wall;
    length=10;
    difference()
    {
        union()
        {
            translate( [0,0,thick/2] ) cube( [ length, slot_width+2*thick, thick ], center=true );
            translate( [0,0,inset/2] ) cube( [ inner_width+3-gap, inner_height+3-gap, inset ], center=true );
        }
        translate( [0,0,2.5] ) cube( [ inner_width, inner_height, inset+2 ], center=true );
        translate( [-length/2,0,-1] ) slot( wall, thick );
        translate( [ length/2,0,-1] ) slot( wall, thick );
    }
}

module tab( wall, thick )
{
    pin_ht=wall+thick+2;
    translate( [ 0,0,pin_ht/2] ) cube( [ 1, 2, pin_ht ], center=true );
}

module slot( wall, thick )
{
    pin_ht=wall+thick+1;
    translate( [ 0,0,pin_ht/2] ) cube( [ 1.25, 2.25, pin_ht ], center=true );
}

function nominal_eye_phone_distance() = lens_phone_distance+eye_lens_distance+lens_thickness;

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

