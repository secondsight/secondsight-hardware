// secondsight Visor project
// Copyright 2013 by secondsight.io, Some Rights Reserved.
//
// Parameters to tune the model to your printer and filament
//
// With the current generation of printers, there can be slight variations from
// one printer to the next. Moreover, some filament expands more than others.
// This can result in changes in tolerances in parts that must fit together.
//
// These parameters are used in various places where tolerances may need to be
// adjusted. Changing them here should result in appropriate tuning throughout
// the model.

// This parameter defines the distance between two parts that should fit tightly
fit_gap=0.15;

// This parameter defines the distance between two parts that should slide together.
slide_gap=0.25;

// This parameter specifies the overlap between two objects when unioning or
//  differencing, so that we don't end up with co-incident faces.
// It is an OpenSCAD implementation detail, and probably doesn't need to change.
overlap=0.1;
