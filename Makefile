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

viewer_body.stl: viewer_body.scad

viewer_body-A.stl: viewer_body.scad
	$(OPENSCAD) -D 'variant="A"' -o $@ $<

viewer_body-B.stl: viewer_body.scad
	$(OPENSCAD) -D 'variant="B"' -o $@ $<

clobber:
	rm *.stl *.gcode
