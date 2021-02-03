/*
  
  Bevels.scad
    Bevels, Chamfers and Connecting grooves
*/

use<Transforms.scad>
include<Constants.scad>

module chamferBase(lengts= 1, width= 1, height= 1, orient= CENTER){
    
    
}

module chamfer(){
    
    move(orient= UP+3*LEFT){cube(1);};
}

chamfer();