# Makefile for creating the aetherAR viewer

STLS=\
	 visor-C.stl\
	 visor-D.stl\
	 lens_holders.stl\
	 optics_support.stl\
	 visor-C-assembled.stl\
	 visor-D-assembled.stl

EXTRA_STLS=\
	 full_optics.stl

SOURCES=\
	visor.scad\
	visor_body.scad\
	visor_elastic_mount.scad\
	visor_optics_mount.scad\
	optic_plate_support.scad\
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
	$(OPENSCAD) -D 'plate="body"' -D 'variant="C"' -o $@ $<

visor-D.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'plate="body"' -D 'variant="D"' -o $@ $<

lens_holders.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'plate="lens_holders"' -o $@ $<

optics_support.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'plate="optics_support"' -o $@ $<

full_optics.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'plate="full_optics"' -o $@ $<

visor-C-assembled.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'plate="assembled"' -D 'variant="C"' -o $@ $<

visor-D-assembled.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'plate="assembled"' -D 'variant="D"' -o $@ $<

test.stl: $(SOURCES) Makefile
	$(OPENSCAD) -D 'plate="test"' -D 'variant="C"' -o $@ $<

.PHONY: clobber
.SECONDARY:

clobber:
	rm $(STLS) $(EXTRA_STLS) visor-*.stl *.gcode
