/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Setup Human Head Dimensions
module Human() {
	*cube(170, center=true); // 17cm average head breadth (?)
	*sphere(r=90, center=true);
	scale([130,130,130])
	color("White",0.1) rotate([90,0,0]) translate([0,-8.25,-0.25])
	import("./external/male.stl");
}


// Transparent Render order
#Human();