include<../package/BasicForms.scad>
include<../package/Spring.scad>

//difference(){

//    chamferCylinder(h= 20, r= 30, chamfer= 2, chamferAng= 45, fn= 50, edges= [EDGE_Bot], pos= [0, 0, 10], center= true);
    //for(i= [0 : 20 : 360]){

        helicoid(A= [30,0,0], r= 30, nbTurn= 1, p= 20, fa= 1)
            mRotate([0, 45, 0])
            cube([2, 0.01, 2],center= true);
    //}
//}
