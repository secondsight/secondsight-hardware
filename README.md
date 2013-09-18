aetherAR-hardware
=================

3D Printable Head Mount Display for aetherAR &amp; associated peripherals

STL Files
---------

Each of these two files contains the complete visor. You only need to print
one to get a useable aetherAR visor.

### visor-A.stl

This variant of the visor has a smooth slope of body from the face all the way
to the edges of the phone. 

### visor-B.stl

In this variant, the main body slopes less. This results in a slight flaring
at the front of the visor.

Source Files
------------

Most of the source code for the hardware consists of OpenSCAD files.

### visor.scad

This is the main file that collects and assembles the parts the make up the
visor.  It has a number of parameters that control the final visor look.

#### Variants

Currently, we have two variants of the main structure of the visor: **A** and
**B**. The variant is chosen by setting the value of the *variant* variable to
one of those strings. In the Makefile, this is used to automatically generate
*visor-A.stl* or *visor-B.stl*.

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

Non-Source Files
----------------

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

