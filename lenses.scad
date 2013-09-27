// Standardize a lens description.
//  Creating a pseudo-object using a vector and a set of functions to access
//  the defined attributes.

function lens_descriptor(name) = (name == "ebay 50x50") ? [ 50, 50, 42, 75, 2, 7.35, 12.45 ]
    : name == "edmund 25x50" ? [ 25, 50, 44, 50, 1.25, 3, 4.25 ]
    : name == "edmund 25x25" ? [ 25, 25, 23, 30, 1.25, 6.15, 7.4 ]
    : name == "b&l 35 5x"    ? [ 35, 50, 44, 60, 1.25, 3, 4.25 ] // guesses
    : [];

function lens_diam( lens ) = lens[0];
function lens_focal_length( lens ) = lens[1];
function lens_phone_offset( lens ) = lens[2];
function lens_fov( lens ) = lens[3];
function lens_rim_thickness( lens ) = lens[4];
function lens_front_height( lens ) = lens[5];
function lens_thickness( lens ) = lens[6];
function lens_back_height( lens ) = lens[6]-lens[5]-lens[4];
