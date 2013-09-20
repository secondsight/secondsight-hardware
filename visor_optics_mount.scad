//  Optics-mounting parts for aetherAR visor

slot_width=10;
min_bfl=25;
max_bfl=45;

// Optics
lens_phone_distance=40;
eye_lens_distance=12;
lens_thickness=5;
//lens_diameter=25;

// Other
gap=0.25;
inner_height=5;
inner_width=4;

// Calculate the nominal distance between the wearer's eye and the phone
function nominal_eye_phone_distance() = lens_phone_distance+eye_lens_distance+lens_thickness;

// Crescent with a stick to hold the lens
// half_width  - Approximately half of the width of the visor
// lens        - lens diameter
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

// The part of the slider that sits outside the visor, connects with the inside
//  part to support the lens holder.
//   wall - thickness of the wall of the visor
//   angle - the angle that the side of the visor makes with the perpendicular
//           of the phone
module slider_outside( wall, angle )
{
    b_thick=2;
    inset=b_thick + wall;
    length=10;
    height=b_thick+1.1*wall;
    width=slot_width+2*b_thick;
    intersection()
    {
        difference()
        {
            union()
            {
                translate( [0,0,b_thick/2] ) cube( [ length, width, b_thick ], center=true );
                rotate( [0,angle,0] ) translate( [-0.25,0,(inset+b_thick)/2] ) cube( [ length, slot_width-gap/2, inset ], center=true );
            }
            rotate( [0,angle,0] ) translate( [-0.25,0,2.5] ) cube( [ inner_width+3, inner_height+3, inset+2 ], center=true );
            // mark top
            translate( [length/2-1, width/2-1, b_thick] ) cylinder( h=1, r=0.5, center=true, $fn=8 );
        }
        translate([0,0,height/2]) cube( [length, width, height], center=true );
    }
}

// The part of the slider that sits inside the visor, connects with the outside
//  part to support the lens holder.
//   wall - thickness of the wall of the visor
//   angle - the angle that the side of the visor makes with the perpendicular
//           of the phone
module slider_inside( wall,angle )
{
    b_thick=2;
    inset=2*b_thick + wall;
    length=10;
    height=2*b_thick+1.08*wall;
    width=slot_width+2*b_thick;
    intersection()
    {
        difference()
        {
            union()
            {
                translate( [0,0,b_thick/2] ) cube( [ length, slot_width+2*b_thick, b_thick ], center=true );
                rotate( [0,angle,0] ) translate( [-0.25,0,(inset+b_thick)/2] ) cube( [ inner_width+3-gap, inner_height+3-gap, inset ], center=true );
            }
            rotate( [0,angle,0] ) translate( [-0.25,0,3.5] ) cube( [ inner_width+gap, inner_height+gap, inset+2 ], center=true );
            // mark top
            translate( [-length/2+1, width/2-1, b_thick] ) cylinder( h=1, r=0.5, center=true, $fn=8 );
        }
        translate([0,0,height/2]) cube( [length, width, height], center=true );
    }
}

// Definition of the slots in the sides of the visor that support the optics.
//  fwidth - the front width of the visor
//  z_eyes - distance from the front of the visor to the user's eyes
//  wall   - thickness of the visor wall
module optics_slots( fwidth, z_eyes, wall )
{
    translate( [ fwidth/2-wall, 0, 0] ) single_optics_mount_slot( z_eyes, wall );
    translate( [-fwidth/2+wall, 0, 0] ) single_optics_mount_slot( z_eyes, wall );
}

// Define one slot
//  z_eyes - distance from the front of the visor to the user's eyes
//  wall   - thickness of the visor wall
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

