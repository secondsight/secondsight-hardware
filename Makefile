# Makefile for creating the aetherAR viewer

STLS=\
	 visor-C.stl\
	 visor-D.stl\
	 visor-C-assembled.stl\
	 visor-D-assembled.stl

SOURCES=\
	visor.scad\
	visor_body.scad\
	visor_elastic_mount.scad\
	visor_optics_mount.scad \
	lenses.scad

# This is system-specific
OPENSCAD=/usr/local/bin/openscad
SLIC3R=~/3rdparty_sandbox/MM/Slic3r/bin/slic3r

all: $(STLS)

# Create STL files from OpenSCAD files
%.stl: %.scad
	$(OPENSCAD) -o $@ $<

# Create gcode files from STL files
%.gcode: %.stl config.ini
	$(SLIC3R) --load config.ini -o $@ $<

visor.stl: $(SOURCES) Makefile

visor-C.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'variant="C"' -D 'plate="both"' -o $@ $<

visor-D.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'variant="D"' -D 'plate="both"' -o $@ $<

visor-C-assembled.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'variant="C"' -D 'plate="assembled"' -o $@ $<

visor-D-assembled.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'variant="D"' -D 'plate="assembled"' -o $@ $<

test.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'variant="test"' -o $@ $<

.PHONY: clobber
.SECONDARY:

clobber:
	rm *.stl *.gcode
