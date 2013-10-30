// secondsight Visor project
// Copyright 2013 by secondsight.io, Some Rights Reserved.
//
// Model of the Galaxy S4

galaxy_s4=[136.6,69.8,7.9,14];

function phone_height(p)=p[0];
function phone_width(p)=p[1];
function phone_thick(p)=p[2];
function phone_radius(p)=p[3];

module galaxy_s4()
{
    difference()
    {
        union()
        {
            _galaxy_s4_main( galaxy_s4 );
            _galaxy_s4_power_button( galaxy_s4 );
            _galaxy_s4_volume_button( galaxy_s4 );
            _galaxy_s4_camera( galaxy_s4 );
            _galaxy_s4_flash( galaxy_s4 );
        }
        // -
        _galaxy_s4_speaker_neg( galaxy_s4 );
        _galaxy_s4_usb_neg( galaxy_s4 );
        _galaxy_s4_jack_neg( galaxy_s4 );
        _galaxy_s4_mic_neg( galaxy_s4 );
        _galaxy_s4_front_speaker_neg( galaxy_s4 );
    }
}

module _galaxy_s4_main( ph )
{
    thick_main=5;
    x_off=phone_width(ph)/2-phone_radius(ph);
    y_off=phone_height(ph)/2-phone_radius(ph);
    hull()
    {
        for( pos=[ [x_off, y_off], [x_off,-y_off], [-x_off,-y_off], [-x_off, y_off] ] )
        {
            translate( [ pos[0], pos[1], 0 ] ) union()
            {
                cylinder( h=thick_main, r=phone_radius(ph) );
                translate( [ 0, 0, thick_main ] )
                    scale( [1, 1, (phone_thick(ph)-thick_main)/phone_radius(ph)] ) intersection()
                {
                    sphere( r=phone_radius(ph), center=true, $fn=32 );
                    cube( 2*phone_radius(ph), center=true );
                }
            }
        }
    }
}

module _galaxy_s4_speaker_neg( ph )
{
     translate( [-0.2*phone_width(ph),-0.795*phone_height(ph)/2,phone_thick(ph)] )
     {
        for( y=[1,-1] )
        {
            translate( [ 0, y, 0 ] ) _bar( 1, 6.6, 2 );
        }
     }
}

module _galaxy_s4_usb_neg( ph )
{
    translate( [ 0,-phone_height(ph)/2+2, 4.5 ] ) rotate( [ 90, 0, 0 ] ) _bar( 2.5, 8, 3 );
}

module _galaxy_s4_power_button( ph )
{
    translate( [-phone_width(ph)/2,0.227*phone_height(ph),0.4*phone_thick(ph) ] )
        rotate( [-90, 0, 90 ] ) _bar( 1.2, 11.5, 0.5 );
}

module _galaxy_s4_volume_button( ph )
{
    translate( [ phone_width(ph)/2,0.265*phone_height(ph),0.4*phone_thick(ph) ] )
        rotate( [ 90, 0, 90 ] ) _bar( 1.2, 23, 0.5 );
}

module _galaxy_s4_jack_neg( ph )
{
    translate( [ 0.255*phone_width(ph), phone_height(ph)/2, 4.4 ] )
        rotate( [90, 0, 0] ) cylinder( h=4, r=3.5/2, center=true, $fn=16 );
}

module _galaxy_s4_mic_neg( ph )
{
    translate( [ 0, -0.45*phone_height(ph), 0 ] )
        _round_plate( 4, 16, 0.25, 1.5 );
}

module _galaxy_s4_front_speaker_neg( ph )
{
    translate( [ 0, 0.469*phone_height(ph), 0 ] )
        _bar( 1, 16, 0.25 );
}

module _galaxy_s4_camera( ph )
{
    x_off=1.75;
    y_off=1.75;
    translate( [ 0, 0.388*phone_height(ph), phone_thick(ph) ] ) hull()
    {
        for( pos=[ [x_off, y_off], [x_off,-y_off], [-x_off,-y_off], [-x_off, y_off] ] )
        {
            translate( [ pos[0], pos[1], 0 ] ) cylinder( h=1, r1=7, r2=5, $fn=32 );
        }
    }
}

module _galaxy_s4_flash( ph )
{
    translate( [ 0, 0.3*phone_height(ph), phone_thick(ph) ] )
        _round_plate( 5, 5, 0.1, 1 );
}

module _round_plate( height, width, depth, rad )
{
    x_off=width/2-rad;
    y_off=height/2-rad;
    hull()
    {
        for( pos=[ [x_off, y_off], [x_off,-y_off], [-x_off,-y_off], [-x_off, y_off] ] )
        {
            translate( [ pos[0], pos[1], 0 ] ) cylinder( h=depth, r=rad, $fn=32 );
        }
    }
}

module _bar( height, width, depth )
{
    off=(width-height)/2;
    hull()
    {
        for(x=[-off,off])
        {
            translate( [ x, 0, 0 ] ) cylinder( h=depth, r=height/2, $fn=32 );
        }
    }
}
