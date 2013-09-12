# Makefile for creating the aetherAR viewer

# This is system-specific
OPENSCAD=/usr/local/bin/openscad
SLIC3R=~/3rdparty_sandbox/MM/Slic3r/bin/slic3r

# Create STL files from OpenSCAD files
%.stl: %.scad
	$(OPENSCAD) -o $@ $<

# Create STL files from OpenSCAD files
%.gcode: %.stl config.ini
	$(SLIC3R) --load config.ini -o $@ $<
