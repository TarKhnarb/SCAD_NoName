include<../package/Constants.scad>
use<../package/BasicForms.scad>
use<../package/Basics.scad>
use<../package/Bevel_Chamfer.scad>
use<../package/Bezier.scad>
use<../package/Gears.scad>
use<../package/Holes.scad>
use<../package/Matrix.scad>
use<../package/Spring.scad>
use<../package/Thread.scad>
use<../package/Transforms.scad>
use<../package/Vector.scad>

    // BasicForms
/*
writeOnFace(pos= [0, 0, 5], text= "Top", color= "grey", size= 3, valign= "center", halign= "center")
writeOnFace(pos= [0, 5, 0], text= "Back", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Back + [0, 0, 180])
writeOnFace(pos= [0, -5, 0], text= "Front", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Frt)
writeOnFace(pos= [5, 0, 0], text= "Right", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Rgt + [0, 0, 90])
writeOnFace(pos= [-5, 0, 0], text= "Left", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Lft + [0, 0, -90])
writeOnFace(pos= [0, 0, -5], text= "Bottom", color= "grey", size= 2, valign= "center", halign= "center", rot= ROT_Bot)
    colorCube(10);
*/

//chamferCube(chamfer= 0.2, size= [1, 2, 1], pos= [0, 0, 0], rot= ROT_Frt, edges= EDGE_All, center= false);

//chamferCylinder(h= 1, r= 1, chamfer= 0.1, chamferAng= 45, fn= 6, pos= [0, 0, 0], rot= ROT_Top, edges= [EDGE_Top, EDGE_Bot], center= false);

//bevelCube(size= [1, 1, 1], bevel= 0.1, fn= 20, pos= [0, 0, 0], rot= ROT_Top, edges= EDGE_All, center= false);

//bevelCylinder(h= 1, r= 1, bevel= 0.1, fn= 20, fnB= 20, pos= [0, 0, 0], rot= ROT_Top, edges= [EDGE_Top, EDGE_Bot], center= false);

//linearPipe(r= 1, thick= 0.1, r1= undef, r2= undef, h= 1, fn= 50, pos=[0, 0, 0], rot= ROT_Top, center= false);

//regularIcosahedron(t= 1, pos= [0, 0, 0], rot= ROT_Top);

    // Bevel_Chamfer
//bevel(r= 1, length= 1, fn= 20, pos= [0, 0, 0], rot= ROT_Top, orient= ORIENT_1, center= false);

//cylindricalBevel(r= 1, R= 1, fn= 20, fnB= 20, pos= [0, 0, 0], rot= ROT_Top, center= false);

//chamfer(chamfer= 1, length= 1, chamferAng= 45, pos= [0, 0, 0], rot= ROT_Top, orient= ORIENT_1, center= false);

//cylindricalChamfer(chamfer= 1, chamferAng= 45, R= 1, fn= 20, pos= [0, 0, 0], rot= ROT_Top, center= false);

    // Bezier
pts = [[0,-2,0], [-2,-5,10], [3,9,2], [6,3,1], [-3,-1,2], [3,-2,1.5]];
/*
bezierCurve(pts, fn= 10)
    sphere(0.1, $fn= 20);
*/

pts2 = [[1, 0, 0], [1, 1.1, 0], [0, 1.1, 0], [-1, 1.5, 0], [-1, 2, 0]];
/*
bezierCurve(5*pts2, 50, ang= [0, 180, 0])
    cube(1, center= true);
*/

/*
bezierArcCurve(A= [1, 0, 0], alpha= 45, r= 1, fn= 10, pos= [0, 0, 0], rot= false, theta= [0, 0, 0])
    sphere(0.1, $fn= 30);
*/

/*
bezierArcCurve(alpha= 110, rot= true, theta= [0, 0, 110], fn = 50)
    cube(0.1, center= true);
*/

matrix= [[[-1,   1,  1],  [0, 1,  0.5],   [1, 1,  -1]],
         [[-1,   0,  0],  [0, 0,  1],     [1, 0,  0.5]],
         [[-1,   -1, -1], [0, -1, -1.5],  [1, -1, -0.5]]];
/*
bezierSurface(M= 5*matrix, fn= 30)
    sphere(0.5, $fn= 20);
*/

m= [[[-1, 1,  -3], [0, 1,  -1], [1, 1,  -3]],
    [[-1, 0,  -1], [0, 0,  4],  [1, 0,  -1]],
    [[-1, -1, -3], [0, -1, -1], [1, -1, -3]]];
/*
bezierSurface(M= m, U= 0.2, V= 0.5)
    sphere(0.1, $fn= 20);
*/

/*
bezierSurface(M= m, fn= 50)
    sphere(0.1, $fn= 20);
*/

    // Gears
//rackTooth(m= 1, toothNb= 1, width= 1, ang= 20, pos= [0, 0, 0], rot= ROT_Top, center= true);

//gear(m= 1, Z= 13, width= 1, ang= 20, fn= 50, pos= [0, 0, 0], rot= ROT_Top);

    // Holes
/*
hole([[0, 0, 0.5], [0, 0, -0.5]], [ROT_Top, ROT_Bot]){

    cube(2, center= true);

    cylinder(r= 0.5, h= 0.5 + 0.01, $fn= 50);

    cylinder(r= 0.5, h= 0.5 + 0.01, $fn= 50);
}
*/

/*
cylinderHole(pos= [2.5, 0, 0], r= 1, h= 2, fn= 50, chamfer= false, chamferSize= 0.5, chamferAng= 30, rot= ROT_Rgt, H= 0)
    cube(5, center= true);
*/

/*
cubeHole(pos= [0, 0, -2.5], c= 1, h= 1, chamfer= false, chamferSize= 0.5, chamferAng= 30, rot= ROT_Bot, H= 0)
    cube(5, center= true);
*/

/*
squareHole(pos= [0, -2.5, 0], size= [1, 3], h= 2, chamfer= false, chamferSize= 0.01, chamferAng= 30, rot= ROT_Frt, H= 0)
    squareHole(pos= [0, 0, 2.50], size= [1, 3], h= 2, chamfer= true, chamferSize= 0.5)
        cube(5, center= true);
*/

/*
*                      |  |                  |
*                      |  | H                |
*       _______________| _v_ _ _ _ _ _ _ _ _ |_______________
*      |               |<------------------->|  A     A      |
*      |               |         D1          |  |     |  h1  |
*      |               |                     |  |     |      |
*      |               |____             ____|  |     V      |
*      |                    |     D     |       |            |
*      |                    |<--------->|       | h          |
*      |                    |           |       |            |
*/
/*
counterbore(pos= [0, 0, 0.8], D= 0.5, h= 1, D1= 1, h1= 0.5, fn= 50, chamfer= true, chamferSize= 0.1, chamferAng= 45, rot= ROT_Top, H= 0.3)
    cube(2, center= true);
*/

/*
cylindricalAxleHole(pos= [-0.5, 0, 0], Daxe = 1, deltaD = 0, h= 1, fn= 50, rot= ROT_Lft, chamfer= true, chamferSize= 0.1, chamferAng= 30, edges= [EDGE_Top, EDGE_Bot], H= 0)
    cube([1, 2, 2], center= true);
*/

    // Spring
/*
helicoid(A= [1, 0, 0], r= 1, nbTurn= 3, p= 1, fa= 10, pos= [0, 0, 0], rot= ROT_Top)
    sphere(0.1, $fn= 20);
*/

//circularCompressionSpring(A= [1, 0, 0], r= 0.1, R= 1, nbTurn= 1, nbTurnStart= 1, nbTurnEnd= undef, p= 1, fa= 1, fn= 20, pos= [0, 0, 0], rot= ROT_Top);

/*
spiralSpring(A= [0, 0, 0], nbTurn= 5, r= 0.2, p= undef, fn= 20, startEnd= false, direction= CLOCKWIRE, pos= [0,0,0], rot= ROT_Top)
    cylinder(r= 0.05, h= 0.05, $fn= 30);
//    cube([0.01, 0.01, 0.05], center= true);
//    sphere(0.01, $fn= 20);
*/

    // Thread
//ISOTriangularThread(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], rot= ROT_Top, gap= 0, center= false);

//ISOTriangularThreadTap(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], rot= ROT_Top, gap= 0, center= false);

//trapezoidalThread(D= 10, p= 2, h= 15, fa= 6, pos= [0, 0, 0], rot= ROT_Top, gap= -0.3, center= false);

//trapezoidalThreadTap(D= 2, p= 0.5, h= 1, fa= 1, pos= [0, 0, 0], rot= ROT_Top, gap= 0, center= false);

/*
knurling(h= 1.2, ang= 45, moduleNb= 10, p = 0.4, fa= 5){

    mTranslate([0, 0, 0.05])
        cylinder(r= 1, h=1, $fn= 360/10);

    mTranslate([0.01, 0, 0])
        rotZ(90)
            rotX(45)
                cube([0.001, 0.1, 0.1], center= true);
}
*/

/*
knurling(r= 1, h= 1 - 0.05, p= 0.2, orient= VERTICAL, moduleNb= 19, fa= 10){

    cylinder(r= 1, $fn= 30);
    mTranslate([-0.025, -0.025, 0]) cube(0.05);
}
*/

/*
knurling(r= 1, h= 1, p= 0.5, moduleNb= 6, ang= undef, orient= HORIZONTAL, fa= 10, pos= [0, 0, 0], rot= ROT_Top){

    cylinder(r= 1, $fn= 30);
    mTranslate([-0.025, -0.025, 0]) cube(0.05);
}
*/
