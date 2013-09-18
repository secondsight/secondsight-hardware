# Makefile for creating the aetherAR viewer

STLS=\
	 visor-A.stl\
	 visor-B.stl

SOURCES=\
	visor.scad\
	visor_body.scad\
	visor_elastic_mount.scad\
	visor_optics_mount.scad

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

visor.stl: $(SOURCES) Makefile

visor-A.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'variant="A"' -o $@ $<

visor-B.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'variant="B"' -o $@ $<

test.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'variant="test"' -o $@ $<

.PHONY: clean
.SECONDARY:

clobber:
	rm *.stl *.gcode
