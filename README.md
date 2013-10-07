aetherAR-hardware
=================

3D Printable Head Mount Display for aetherAR &amp; associated peripherals

## STL Files

Each of these two files contains the complete visor. You only need to print
one to get a usable aetherAR visor.

### visor-A.stl

This variant of the visor has a smooth slope of body from the face all the way
to the edges of the phone. The optics mounting hardware is printed inside the
visor.

### visor-B.stl

In this variant, the main body slopes less. This results in a slight flaring
at the front of the visor. The optics mounting hardware is printed inside the
visor.

### visor-C.stl

In this variant, the body slopes smoothly from the face to the phone with no
flaring at all. The optics mounting hardware is printed inside the visor.

### visor-D.stl

In this variant, the body slopes smoothly from the face to the phone with no
flaring at all. The corners are slightly grooved to give less of a round feel.
The optics mounting hardware is printed inside the visor.

## Example Assemblies

Some of the STLs are not meant to be printed. They are just documentation to
show how that variant fits together. The names are the same as the variant file
with *-assembled* inserted before the extension.

## Source Files

Most of the source code for the hardware consists of OpenSCAD files.

### visor.scad

This is the main file that collects and assembles the parts the make up the
visor.  It has a number of parameters that control the final visor look.

#### Variants

Currently, we have four variants of the main structure of the visor: **A**,
**B**, **C**, and **D**. In addition, you may want to print either the whole
visor or just parts of it. There are a pair of variables that allow you to
choose what variations you want to print.

   * variant - Choose the variant to print by setting this variable to the
     appropriate string
      - "A": See *visor-A.stl* above for a description. Used by the Makefile to
        generate *visor-A.stl*.
      - "B": See *visor-B.stl* above for a description. Used by the Makefile to
        generate *visor-B.stl*.
      - "C": See *visor-C.stl* above for a description. Used by the Makefile to
        generate *visor-C.stl*.
      - "D": See *visor-D.stl* above for a description. Used by the Makefile to
        generate *visor-D.stl*.
   * plate - Choose the subset of the visor to print.
      - "body": Print the main body of the visor.
      - "optics": Print the lens support hardware.
      - "both": Print all parts of the visor.
      - "assembled": Show the assembled visor. Not printable!

You can either change these parameters in the *visor.scad* file or supply them
on the OpenSCAD command line if you want to automatically generate the STLs.
See the Makefile for examples of the use of these parameters.

#### Experimenting with Assembled View

There are a few parameters that you can change in the *assembled* view to get
an idea of how the visor will work in reality. Supplying a different value for
*lens* gives an idea of how the visor would look with that lens. Obviously,
this is easy for one of the defined lenses, and harder if you just want to try
out a lens. See the file *lenses.scad* to define a new lens to try.

Inside the optics\_assembled module, there are two potentially tweakable
parameters. The *xoff* value is half the IPD (Inter-Pupilary Distance). You can
either supply this directly or use one of the constants defined at the top of
*visor.scad*.

   * IPD\_min - minumum value for adults
   * IPD\_max - maximum value for adults
   * IPD\_avg - average value for adults
   * IPD\_avg\_male - average value for adult males
   * IPD\_avg\_female - average value for adult females

The other tweakable parameter is *lens_z*, which specifies the distance between
the phone and the lens. Normally, we use the defined value for the lens, but
you can change this value to see how the visor would look with the lens closer
to the phone or farther away.

#### User-Specific Parameters

Although we don't expect these to change, a particular user might be able to
get a better fit by changing the user-specific parameters.

   * *face_width* - distance from temple to temple in mm.
   * *forehead_depth* - distance from temple to front of forehead in mm.
   * *eye_forehead_offset* - inset distance of eyes from forehead

We will try to get these parameters reasonable for most adults, but tweaking
them may generate a more comfortable fit.

#### Phone-Specific Parameters

The visor is designed to work with the Galaxy S4. There should be little
difference from phone to phone. These parameters will only be changed to target
a different phone as the primary design.

These parameters should not be changed in most cases.

### visor\_body.scad

This file defines the main shape of the body of the visor. This is purely a
library file and generates no object if loaded directly. The *visor.scad* file
loads this *visor_body.scad* and calls the *main_body()* module to instantiate
the body.

### visor\_elastic\_mount.scad

This file defines the elastic band mounting system for the phone. Although not
the *coolest* design, this is functional and allows testing of the hardware.
It's main advantage is that it is simple and works with all phones.

### lenses.scad

This file contains functions to define and use descriptions of particular
lenses. We want designs to be able to depend on both the physical and optical
characteristics of a lens, without having a bunch of random constants to deal
with (and pass around). This file defines a vector structure and accessors to
keep those parameters in check.

#### lens\_descriptor(name)

This function returns the vector that describes a lens we already know. You
can think of it as a factory object for known lenses. It currently has values
for the lenses we used in prototyping.

#### Accessor methods

Each accessor takes the lens description as a parameter and returns the
requested data from the vector. This is a lot more readable than just dealing
with random vector indices. All lengths are in mm.

   * lens\_diam(lens) - lens diameter
   * lens\_focal\_length(lens) - focal length
   * lens\_phone\_offset(lens) - measured nominal distance from lens to phone
   * lens\_fov(lens) - measured minimum field of view at the phone\_offset
   * lens\_rim\_thickness(lens) - thickness of the rim of the lens
   * lens\_front\_height(lens) - distance from rim to the front of the lens
   * lens\_thickness(lens) - overall thickness of the lens
   * lens\_back\_height(lens) - distance from the rim to the back of the lens

## Non-Source Files

### Makefile

To simplify the creation of STL files from the OpenSCAD source, the project
also includes a *Makefile*. You can use most variants of the *make* development
tool to generate the STLs from the command line. The Makefile contains two
variables that probably require changing to use in your environment.

   * *OPENSCAD* - full path to the OpenSCAD program on your system
   * *SLIC3R* - (optional) full path to the slic3r program on your system

You do not need to use slic3r to generate your gcode files. If you do, the
Makefile contains targets to help.

### config.ini

This is a *slic3r* configuration that has been used to create gcode files for
the visor STLs.

## Preparing to Build a Headset

There a few pre-requisites that you need to build the aetherAR headset from
this project.

   1. Lenses
   2. Head strap
   3. 3D printer
   4. Android phone
   5. Open cell foam or neoprene

### Lenses

We have had reasonable luck with lenses in the 25mm to 37mm diameter range,
with a focal length of 50mm. The field of view is directly related to the
diameter of the lens. A 35-37mm diameter lens seems to give a view that covers
the whole phone at this focal length. A 25mm lens doesn't quite cover the whole
phone.

We have tried as high as 50mm diameter. That lens had a field of view larger
than the phone and required a larger visor design.

### Head strap

While you could use the headset by holding it to your face with your hands,
this would get old really quick. The headset is designed to use a 40mm wide
elastic strap to hold the headset. This gives good support without requiring an
extremely tight fit to avoid slipping.

### 3D Printer

You should be able to use any 3D printer with a large enough build volume. The
visor has been successfully printed in both ABS and PLA.

### Android Phone

The current visor design is optimized for the Galaxy S4 phone. The design does
not require exactly that phone, but it the front of the visor was designed around
the dimensions of the S4. It has been used with different phones that are close
to the same dimensions (e.g. Galaxy Nexus).

### Open Cell Foam or Neoprene

The hard plastic is mildly uncomfortable fitting directly against your face.
It's not painful, but it is hard plastic supporting a phone. A small amount of
foam applied to the back side of the visor makes the fit much more comfortable.

A cheap source of reasonable material is a cheap mousepad. You can easily cut
pieces to fit the visor.

## Building the Headset

Choose the STL file for the variant you want to print. The base STLs contain
all of the parts that make up a particular variant of the visor. If you want
to modify the design in any way, the OpenSCAD files are the sources you can use
to make new STLs.

Use your favorite 3D printer to print the STL chosen above.

When the printing is finished, there should be very little post-processing
needed. Part of the design goal was to reduce needed post-processing. But, some
is still necessary. The one part of design that needs cleanup is the supports
in the strap mounts. The 40mm bridge can prove difficult to print without
sagging. The design incorporates a pair of small vertical pieces intended to
reduce sagging. These pieces can be easily remove from the top and bottom holes
on each side with a sharp knife (like an xacto).

The assembly is not overly difficult. This is where the assembled views become
most useful. Compare the assembled view for your variant to the pieces that
were printed and snap things together.

The sliders snap together inside each of the slots on the sides of the visor.
Each piece has a tiny mark on the side that should be on top.  The lens
supports slide into the rectangular hole in the middle. This should be a
relatively tight fit. If you find that the fit is too tight, you can use
sandpaper to gently sand the straight part of the arms until they fit.

The lenses should be easy to pop into the lens holders.

The little phone support should be pushed onto the lower portion of the visor
such that the little shelf protrudes under the bottom of the visor. If you put
the little shelf inside the visor, it will hold the phone too high.

When mounting the strap, putting the ends of the straps on the inside (against
the head) makes adjusting a bit more difficult, but it keeps the strap from
loosening while you are wearing it.

## Logo

The font used in the logo uses the OpenSans Regular font, which has been ported
for use with OpenSCAD by the Brad Pitcher. His implementation is available at
http://www.thingiverse.com/thing:13677 and is released under a CC by-sa
license.
