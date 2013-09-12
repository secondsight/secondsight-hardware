// Experiment with octogon shape

// Use dimensions for Galaxy S4
//    Dimensions are portrait mode.
phone_width=69.8;
phone_height=136.6;
phone_thickness=7.9;
view_width=65;
view_height=110;

face_width=126;
height=67;
depth=65;
forehead_depth=37.5;
thick=3;

union()
{
    main_body();
    body_front();
}

module body_front_outer()
{
    front_height=0.5*height;
    front_width=sqrt(2)*phone_height;
    scale( [1,phone_width/phone_height,1] ) translate( [0,0,front_height/2] ) rotate( [0,0,45] )
        cylinder( h=front_height, r1=front_width/2, r2=front_width/4, center=true, $fn=4 );
}

module body_front_inner()
{
    front_height=0.5*height;
    front_width=sqrt(2)*phone_height;
    scale( [1,phone_width/phone_height,1] ) translate( [0,0,front_height/2] ) rotate( [0,0,45] )
        cylinder( h=front_height+0.04, r1=front_width/2-3, r2=front_width/4-3, center=true, $fn=4 );
}

module main_body()
{
    difference()
    {
        union()
        {
            shell_outer();
            body_front_outer();
        }
        shell_inner();
        body_front_inner();
        face();
        translate( [0,-height/2+0.75*thick,depth/2] )
            nose_slice( thick );
    }
}

module shell_outer()
{
    scale( [1,height/face_width,1] ) translate( [0,0,depth/2] ) rotate( [0,0,45/2] )
        cylinder( h=depth, r=face_width/2, center=true, $fn=8 );
}

module shell_inner()
{
    scale( [1,height/face_width,1] ) translate( [0,0,depth/2] ) rotate( [0,0,45/2] )
        cylinder( h=depth+0.04, r=face_width/2-thick, center=true, $fn=8 );
}

module face()
{
    radius=1.35*face_width/2-3;
    translate([0,0,radius+forehead_depth]) rotate([90,0,0])
        cylinder( h=depth+10, r=radius, center=true, $fn=32 );
}

module nose_slice( thickness )
{
    theta=10;
    spread=5.8;
    slice=35;
    union()
    {
        translate([spread,0,0] ) rotate( [0,theta,0] ) cube( [slice, thickness*4, 1.2*depth], center=true );
        translate([-spread,0,0] ) rotate( [0,-theta,0] ) cube( [slice, thickness*4, 1.2*depth], center=true );
    }
}
