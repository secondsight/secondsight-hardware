# Makefile for creating the aetherAR viewer

STLS=\
	 visor-A.stl\
	 visor-B.stl

# This is system-specific
OPENSCAD=/usr/local/bin/openscad
SLIC3R=~/3rdparty_sandbox/MM/Slic3r/bin/slic3r

all: $(STLS)

# Create STL files from OpenSCAD files
%.stl: %.scad
	$(OPENSCAD) -o $@ $<

# Create STL files from OpenSCAD files
%.gcode: %.stl config.ini
	$(SLIC3R) --load config.ini -o $@ $<

visor.stl: visor.scad visor_body.scad visor_elastic_mount.scad

visor-A.stl: visor.scad visor_body.scad visor_elastic_mount.scad
	$(OPENSCAD) -D 'variant="A"' -o $@ $<

visor-B.stl: visor.scad visor_body.scad visor_elastic_mount.scad
	$(OPENSCAD) -D 'variant="B"' -o $@ $<

test.stl: visor.scad visor_body.scad visor_elastic_mount.scad
	$(OPENSCAD) -D 'variant="test"' -o $@ $<

.PHONY: clean
.SECONDARY:

clobber:
	rm *.stl *.gcode
