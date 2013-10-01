aetherAR-hardware
=================

3D Printable Head Mount Display for aetherAR &amp; associated peripherals

## STL Files

Each of these two files contains the complete visor. You only need to print
one to get a useable aetherAR visor.

### visor-A.stl

This variant of the visor has a smooth slope of body from the face all the way
to the edges of the phone. The optics mounting hardware is printed inside the
visor.

### visor-B.stl

In this variant, the main body slopes less. This results in a slight flaring
at the front of the visor. The optics mounting hardware is printed inside the
visor.

### visor-assembled.stl

This is an STL that is not meant to be printed. This STL only serves as
documentation of how the parts of the visor should fit together.

## Source Files

Most of the source code for the hardware consists of OpenSCAD files.

### visor.scad

This is the main file that collects and assembles the parts the make up the
visor.  It has a number of parameters that control the final visor look.

#### Variants

Currently, we have two variants of the main structure of the visor: **A** and
**B**. In addition, you may want to print either the whole visor or just parts
of it. There are a pair of variables that allow you to choose what variations
you want to print.

   * variant - Choose the variant to print by setting this variable to the
     appropriate string
      - "A": See *visor-A.stl* above for a description. Used by the Makefile to
        generate *visor-A.stl*.
      - "B": See *visor-B.stl* above for a description. Used by the Makefile to
        generate *visor-B.stl*.
   * plate - Choose the subset of the visor to print.
      - "body": Print the main body of the visor.
      - "optics": Print the lens support hardware.
      - "assembled": Show the assembled visor. Not printable!
      - "both": Print all parts of the visor.

You can either change these parameters in the *visor.scad* file or supply them
on the openscad command line if you want to automatically generate the STLs.
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

   * *OPENSCAD* - full path to the openscad program on your system
   * *SLIC3R* - (optional) full path to the slic3r program on your system

You do not need to use slic3r to generate your gcode files. If you do, the
Makefile contains targets to help.

### config.ini

This is a *slic3r* configuration that has been used to create gcode files for
the visor STLs.
