/*
  Bevels.scad
    Bevels, Chamfers and Connecting grooves
*/

use<Transforms.scad>
use<Vector.scad>
use<Basics.scad>
include<Constants.scad>

module chamferBase(length= 1, width= 1, height= 1, orient= CENTER){

    size = [sqrt(2)*(length + 0.2), sqrt(2)*(width + 0.2), height + 0.2];

	translate([-0.1,-0.1,0])
		rotate([0, 0, 45])
            cube(size, center= true);
}

module colorCube(size= 1){
    
    s = size/2;

    union(){

        color([0, 0, 0])
            cube([s, s, s]);

        color([1, 0, 0])
            translate([-s, 0, 0])
                cube([s, s, s]);

        color([0, 1, 0])
            translate([0, -s, 0])
                cube([s, s, s]);

        color([0, 0, 1])
            translate([0, 0, -s])
                cube([s, s, s]);

        color([1, 1, 0])
            translate([-s, -s, 0])
                cube([s, s, s]);

        color([1, 0, 1])
            translate([-s, 0, -s])
                cube([s, s, s]);

        color([0, 1, 1])
            translate([0, - s, - s])
                cube([s, s, s]);

        color([1, 1, 1])
            translate([- s, - s, - s])
                cube([s, s, s]);
    }
}


module chamfer(){
    
//    difference(){
        
    multmatrix(m= matrix(0,0,-1)){

        colorCube(1);
    }
        //chamferBase(height= 5);
//    }
}

difference(){
    
    cube([10, 10, 10]);
    chamferBase(length=3, width=3);
}