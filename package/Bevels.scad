/*
  Bevels.scad
    Bevels, Chamfers and Connecting grooves
*/

use<Transforms.scad>
use<Vector.scad>
include<Constants.scad>

module chamferBase(length= 1, width= 1, height= 1, orient= CENTER){

    size = [sqrt(2)*length + 0.2, sqrt(2)*width + 0.2, height + 0.2];

    rotate([0, 0, 45])
        translate([size[0]/16, size[1]/16, -0.2 + size[2]]*(1/2))
        cube(size, center= true);
}

module chamfer(size= [1, 1, 1], ){
    
//    difference(){
        
        cube(5);
        chamferBase(height= 5);
//    }
}

chamfer();