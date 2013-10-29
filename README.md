secondsight
===========

3D Printable Head Mount Display for secondsight &amp; associated peripherals licensed under [Mozilla Public License, v. 2.0.](https://github.com/secondsight/secondsight-hardware/blob/master/LICENSE)


## Contents

- Example Assemblies
- Preparing to Build a Headset
- Building the Headset
- 3D Printing Plates & STL File Descriptions
- Source Files & Customisation
- Non-Source Files
- Logo

## Example Assemblies

Some of the STLs are not meant to be printed. They are just documentation to
show how that variant fits together. The names are the same as the variant file
with *-assembled* inserted before the extension - these are meant for assembly reference and 3D viewing.

You can view the final product here;

[Visor-C Assembled](https://github.com/secondsight/secondsight-hardware/blob/master/visor-C-assembled.stl) and [Visor-D Assembled](https://github.com/secondsight/secondsight-hardware/blob/master/visor-D-assembled.stl)


## Preparing to Build a Headset

There a few pre-requisites that you need to build the secondsight headset from
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

The current design is currently set for the 36mm Lens from [B&L 5X Aspheric Pocket Magnifier](http://www.amazon.com/Bausch-Lomb-Aspeheric-Packette-5x/dp/B000M755GK). We will be releasing our own pcx lens designs soon.

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

## 3D Printing Plates & STL File Descriptions

To get a full visor, you will need to print one of the body variants
(*visor-C.stl* or *visor-D.stl*), the *lens_holders.stl* and the
*optics_support.stl*.

### visor-C.stl

In this variant, the body slopes smoothly from the face to the phone with no
flaring at all. The optics mounting hardware is printed inside the visor.

### visor-D.stl

In this variant, the body slopes smoothly from the face to the phone with no
flaring at all. The corners are slightly grooved to give less of a round feel.
The optics mounting hardware is printed inside the visor.

### lens\_holders.stl

This file contains the parts that support the lenses themeslves. The lens is
held between the longer barrel and the cap. This file contains parts for a pair
of lens holders.

### optics\_support.stl

This file contains the two support plates that connect the lens holders to the
visor body.

## Source Files & Customisation

Most of the source code for the hardware consists of OpenSCAD files.

### visor.scad

This is the main file that collects and assembles the parts the make up the
visor.  It has a number of parameters that control the final visor look.

#### Variants

Currently, we have two variants of the main structure of the visor: **C**
and **D**. Earlier prototypes were listed as variants A and B, but they are
no longer supported. In addition, you may want to print either the whole
visor or just parts of it. There are a pair of variables that allow you to
choose what variations you want to print.

   * variant - Choose the variant to print by setting this variable to the
     appropriate string
      - "C": See *visor-C.stl* above for a description. Used by the Makefile to
        generate *visor-C.stl*.
      - "D": See *visor-D.stl* above for a description. Used by the Makefile to
        generate *visor-D.stl*.
   * plate - Choose the subset of the visor to print.
      - "body": Print the main body of the visor.
      - "optics\_support": Print the lens support plates.
      - "lens\_holders": Print the lens holders.
      - "full\_optics": Print the lens holders and support plates all at once.
        Requires a fairly large build area. Not recommended.
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

   * IPD\_min - minimum value for adults
   * IPD\_max - maximum value for adults
   * IPD\_avg - average value for adults
   * IPD\_avg\_male - average value for adult males
   * IPD\_avg\_female - average value for adult females

The other tweakable parameter is *lens_z*, which specifies the distance between
the phone and the lens. Normally, we use the defined value for the lens, but
you can change this value to see how the visor would look with the lens closer
to the phone or farther away.

#### User-Specific Parameters

The visor is currently configured to fit most adults relatively well. However,
there is a possibility that the visor could be more comfortable for a given
user by changing the fit slightly. The file *user_params.scad* contains a set
of user-specific changes for this purpose.

See the documentation below for a description of these parameters.

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

### visor\_optics\_mount.scad

This file defines the hardware to support the lenses in the visor body. The
design has a few constraints that make the problem of mounting interesting.  We
want the lens to be held firmly, but weight is a consideration. Also not all
users are the same. Also, the *Interpupillary Distance* (IPD) is different from
person to person. We would like this to be easily adjustable for the user.

The optics mounting hardware takes these issues into account.

### optic\_plate\_support.scad

Defines the pieces of the model that supports the optics lens front plate in
the body of the visor. Defines the ledges, the tabs and the slots.

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

### polybody.scad

The visor body is designed around a ten-sided polyhedron. Some of the
parameters and code for this polyhedron are needed in multiple files.
Separating the code into this file makes it easier to reuse.

### user\_params.scad

This file contains only constants that describe some user-specific sizes.

Although we don't expect these to change, a particular user might be able to
get a better fit by changing the user-specific parameters.

   * *user_temple_distance* - distance from temple to temple in mm.
   * *forehead_depth* - distance from temple to front of forehead in mm.
   * *eye_forehead_offset* - inset distance of eyes from forehead

We will try to get these parameters reasonable for most adults, but tweaking
them may generate a more comfortable fit.

The only one that is likely to change much would be *user_temple_distance*.
People with wider or narrower faces may want to change this parameter.

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

## Logo

The font used in the logo uses the OpenSans Regular font, which has been ported
for use with OpenSCAD by the Brad Pitcher. His implementation is available at
http://www.thingiverse.com/thing:13677 and is released under a CC by-sa
license.
