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