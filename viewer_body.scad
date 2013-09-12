// Experiment with octogon shape

width=126;
height=67;
depth=65;
forehead_depth=37.5;
thick=3;

difference()
{
    shell();
    face();
    translate( [0,-height/2+0.75*thick,depth/2] )
        nose_slice( thick );
}

module shell()
{
    scale( [1,height/width,1] ) translate( [0,0,depth/2] ) rotate( [0,0,45/2] )
        difference()
        {
            cylinder( h=depth, r=width/2, center=true, $fn=8 );
            cylinder( h=depth+0.04, r=width/2-thick, center=true, $fn=8 );
        }
}

module face()
{
    radius=1.35*width/2-3;
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
        translate([spread,0,0] ) rotate( [0,theta,0] ) cube( [slice, thickness*2, 1.2*depth], center=true );
        translate([-spread,0,0] ) rotate( [0,-theta,0] ) cube( [slice, thickness*2, 1.2*depth], center=true );
    }
}
