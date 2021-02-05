/*
  Bevels.scad
    Bevels, Chamfers and Connecting grooves
*/

use<Transforms.scad>
use<Vector.scad>
use<Basics.scad>
use<Matrix.scad>
include<Constants.scad>

module chamferBase(length= 1, width= 1, heigth= 1, orient= CENTER){

    size = [sqrt(2)*(length + 0.2), sqrt(2)*(width + 0.2), heigth + 0.2];


    multmatrix(m= matTrans(v= [-0.1, -0.1, heigth/2])*matRotZ(ang= 45)){
            cube(size, center= true);
	}
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


module chamfer(size= 1, heigth= 1, pos= [0,0,0]){
    
	difference(){
        translate([1, 1, 1])
        colorCube(2);
        chamferBase(length= size, width= size, heigth= heigth, orient= CENTER);
	}
}

chamfer(heigth=2);