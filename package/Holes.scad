use<Transforms.scad>
use<Basics.scad>
include<Constants.scad>

/*
* hole(pos: position of each holes to be pierced,
*      rots: rotation to applied to the hole base)
*
* WARNINGS: 
*      1. The hole patterns should be positioned in the centre of the system axes. In addition, if you wish to pierce a hole along the Z axis, you will have to place and size your part (to be removed) so that :
*
*           - the volume of the part is positioned entirely in Z-negative
*           - the part has an additional portion of at least 0.01mm in Z-positive
*
*      2. You should necessarily indicate the translation to be applied to each of the parts, [0, 0, 0] if not desired. Note that you should pass in parameter a vector containing the translation vectors (1 vector for each hole parts).
*/
module hole(pos= [[0, 0, 0]], rots= [ROT_Top]){
    
    assertion($children > 1, "this module requires a minimum of two 'children()'");
    
    assertion(len(pos) > 0, "pos should be contain a minimum of 1 vector [x, y, z]");
    assertion(len(rots) > 0, "rots should be contain a minimum of 1 ROT_ constant");

    assertion(len(pos) == ($children - 1), "pos should be contain the same number of vectors as the number of 'children()' to be pierced");
    assertion(len(rots) == ($children - 1), "rots should be contain the same number of vectors as the number of 'children()' to be pierced");

    difference(){
        
        children(0);
        
        for(i= [1 : $children - 1]){
            
            mTranslate(pos[i - 1])
                mRotate(rots[i - 1])
                    children(i);
        }
    }
}

/*
hole([[0, 0, 0.5], [0, 0, -0.5]], [ROT_Top, ROT_Bot]){
    
    cube(2, center= true);
    
    cylinder(r= 0.5, h= 0.5 + 0.01, $fn= 50);
    
    cylinder(r= 0.5, h= 0.5 + 0.01, $fn= 50);
}
*/

    // CylinderHole

/*
* cylinderHole(pos: position to set the hole,
*              r: radius of the cylinder,
*              h: depth of the hole,
*              fn: precision for the cylinder,
*              chamfer: if true set a chamfer,
*              chamferSize: width of the chamfer,
*              chamferAng: angle of the chamfer should be ranged in ]0, 90[,
*              rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as 
*                   [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction
*              H: Height of the hole cylinder above the chamfer (if a height greater than 0.01 is required, only with the chamfer))
*
* Note:
*   You can modify the value of fn in order to create regular shapes (equilateral triangle, square, pentagon, ...)
*/
module cylinderHole(pos= [0, 0, 0], r= 1, h= 1, fn= 50, chamfer= false, chamferSize= 0.1, chamferAng= 30, rot= ROT_Top, H= 0){

    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(0 < r, "r should be greater than 0");
    assertion(0 < h, "h should be greater than 0");
    assertion(0 < fn, "fn should be greater than 0");
    assertion(0 < chamferSize, "chamferSize should be greater than 0");
    assertion((0 < chamferAng) && (chamferAng < 90), "chamferAng should be ranged in ]0, 90[ °");
    assertion(len(rot) == 3, "rot should be a 3D vector");
    assertion(0 <= H, "H should be greater than or equal to 0");

    lgth = tan(chamferAng);
    assertion(chamferSize*lgth < h, "h should be greater than tan(chamferAng)*chamferSize");
    
    hole([pos], [rot]){
        
        children();

        if(chamfer){
                
            union(){
                
                hull(){

                    mTranslate([0, 0, H])
                        cylinder(r= r + chamferSize, h= 0.01, $fn= fn);
                        
                    mTranslate([0, 0, -(0.01 + chamferSize*lgth)])
                        cylinder(r1= r - lgth*0.01, r2= r + chamferSize, h= 0.01 + chamferSize*lgth, $fn= fn);
                }
                
                mTranslate([0, 0, -h])
                    cylinder(r= r, h= (h - chamferSize*lgth), $fn= fn);
            }
        }
        else{
            
            mTranslate([0, 0, -h])
                cylinder(r= r, h= h + 0.01, $fn= fn);
        }
    }
}

/*
cylinderHole(pos= [2.5, 0, 0], r= 1, h= 2, fn= 50, chamfer= true, chamferSize= 0.5, rot= ROT_Rgt)
    cube(5, center= true);
*/

    // CubeHole

/*
* cubeHole(pos: position to set the hole,
*          c: size of the cube,
*          h: depth of the hole,
*          chamfer: if true set a chamfer,
*          chamferSize: width of the chamfer,
*          chamferAng: angle of the chamfer should be ranged in ]0, 90[,
*          rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as 
*               [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction
*          H: Height of the hole cylinder above the chamfer (if a height greater than 0.01 is required, only with the chamfer))
*/
module cubeHole(pos= [0, 0, 0], c= 1, h= 1, chamfer= false, chamferSize= 0.1, chamferAng= 30, rot= ROT_Top, H= 0){

    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(0 < c, "c should be greater than 0");
    assertion(0 < h, "h should be greater than 0");
    assertion(0 < chamferSize, "chamferSize should be greater than 0");
    assertion((0 < chamferAng) && (chamferAng < 90), "chamferAng should be ranged in ]0, 90[ °");
    assertion(len(rot) == 3, "rot should be a 3D vector");
    assertion(0 <= H, "H should be greater than or equal to 0");

    lgth = tan(chamferAng);
    assertion(chamferSize*lgth < h, "h should be greater than tan(chamferAng)*chamferSize");
    
    r = c*sqrt(2)/2;
    chamfSize = chamferSize*sqrt(2);
    
    hole([pos], [rot + [0, 0, 45]]){
        
        children();

        if(chamfer){
            union(){
                
                hull(){

                    mTranslate([0, 0, H])
                        cylinder(r= r + chamfSize, h= 0.01, $fn= 4);
                        
                    mTranslate([0, 0, -(0.01 + chamferSize*lgth)])
                    cylinder(r1= r - lgth*0.01, r2= r + chamfSize, h= 0.01 + chamferSize*lgth, $fn= 4);
                }
                
                mTranslate([0, 0, -h])
                    cylinder(r= r, h= (h - chamferSize*lgth), $fn= 4);
            }
        }
        else{
            
            mTranslate([0, 0, -h])
                cylinder(r= r, h= h + 0.01, $fn= 4);
        }
    }
}

/*
cubeHole(pos= [0, 0, -2.5], c= 1, h= 2, chamfer= true, chamferSize= 0.5, rot= ROT_Bot)
    cube(5, center= true);
*/

    // squareHole

/*
* squareHole(pos: position to set the hole,
*            size: size of the square according to the vector [width X, width Y],
*            h: depth of the hole,
*            chamfer: if true set a chamfer,
*            chamferSize: width of the chamfer,
*            chamferAng: angle of the chamfer should be ranged in ]0, 90[,
*            rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as
*                 [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction
*            H: Height of the hole cylinder above the chamfer (if a height greater than 0.01 is required, only with the chamfer))
*/
module squareHole(pos= [0, 0, 0], size= [1, 1], h= 1, chamfer= false, chamferSize= 0.01, chamferAng= 30, rot= ROT_Top, H= 0){

    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(size) == 2, "size should be a 2D vector");
    assertion((0 < size[0]) || (0 < size[1]),"The size of the square should be greater than 0");
    assertion(0 < h, "h should be greater than 0");
    assertion(0 < chamferSize, "chamferSize should be greater than 0");
    assertion((0 < chamferAng) && (chamferAng < 90), "chamferAng should be ranged in ]0, 90[ °");
    assertion(len(rot) == 3, "rot should be a 3D vector");
    assertion(0 <= H, "H should be greater than or equal to 0");

    lgth = tan(chamferAng);

    assertion(chamferSize*lgth < h, "h should be greater than tan(chamferAng)*chamferSize");

    hole([pos], [rot]){
        
        children();

        if(chamfer){

            union(){
                
                mTranslate([-size.x/2, -size.y/2, -h])
                    cube(size= [size.x, size.y, h + 0.01 - chamferSize*lgth]);

                polyhedron(points= [[-size.x/2,                 -size.y/2,                  -chamferSize*lgth],    // Bottom of the chamfer
                                    [-size.x/2,                 size.y/2,                   -chamferSize*lgth],
                                    [size.x/2,                  size.y/2,                   -chamferSize*lgth],
                                    [size.x/2,                  -size.y/2,                  -chamferSize*lgth],
                                    [-chamferSize - size.x/2,   -chamferSize - size.y/2,    0],                    // Top of the chamfer
                                    [-chamferSize - size.x/2,   chamferSize + size.y/2,     0],
                                    [chamferSize + size.x/2,    chamferSize + size.y/2,     0],
                                    [chamferSize + size.x/2,    -chamferSize - size.y/2,    0],
                                    [-chamferSize - size.x/2,   -chamferSize - size.y/2,    H + 0.02],             // Top addition of the chamfer
                                    [-chamferSize - size.x/2,   chamferSize + size.y/2,     H + 0.02],
                                    [chamferSize + size.x/2,    chamferSize + size.y/2,     H + 0.02],
                                    [chamferSize + size.x/2,    -chamferSize - size.y/2,    H + 0.02]],

                           faces= [[0, 3, 2, 1],                      // Bottom face
                                   [0, 1, 5, 4],   [1, 2, 6, 5],      // Slide bottom to top
                                   [2, 3, 7, 6],   [0, 4, 7, 3],
                                   [4, 5, 6, 7],                      // Top face
                                   [4, 5, 9, 8],   [5, 6, 10, 9],     // Slide top to top addition
                                   [6, 7, 11, 10], [4, 7, 11, 8],
                                   [8, 9, 10, 11]]                    // Top addition face
                        );
                }
        }
        else{
            
            mTranslate([-size.x/2, -size.y/2, -h])
                cube(size= [size.x, size.y, h + 0.01]);
        }
      }
}

/*
squareHole(pos= [0, -2.50, 0], size= [1, 3], h= 2, rot= ROT_Frt)
    squareHole(pos= [0, 0, 2.50], size= [1, 3], h= 2, chamfer= true, chamferSize= 0.5)
        cube(5, center= true);
*/

    // Counterbore

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
* counterbore(pos: position to set the hole,
*             D: cylinder diameter,
*             h: full depth of the hole,
*             D1: diameter ofthe counterbore,
*             h1: depth of the counterbore,
*             fn: precision for the cylinder,
*             chamfer: if true set a chamfer,
*             chamferSize: width of the chamfer,
*             chamferAng: angle of the chamfer should be ranged in ]0, 90[,
*             rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as
*                  [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction
*             H: Height of the hole cylinder above the chamfer (if a height greater than 0.01 is required, only with the chamfer))
*
* Note:
*   You can modify the value of fn in order to create regular shapes (equilateral triangle, square, pentagon, ...)
*/
module counterbore(pos= [0, 0, 0], D= 0.5, h= 1, D1= 1, h1= 0.5, fn= 50, chamfer= false, chamferSize= 0.1, chamferAng= 30, rot= ROT_Top, H= 0){

    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(0 < D, "D should be greater than 0");
    assertion(0 < h, "h should be greater than 0");
    assertion(0 < D1, "D1 should be greater than 0");
    assertion(0 < h1, "h1 should be greater than 0");
    assertion(0 < fn, "fn should be greater than 0");
    assertion(0 < chamferSize, "chamferSize should be greater than 0");
    assertion((0 < chamferAng) && (chamferAng < 90), "chamferAng should be ranged in ]0, 90[ °");
    assertion(len(rot) == 3, "rotshould be a 3D vector");
    assertion(0 <= H, "H should be greater than or equal to 0");

    lgth = tan(chamferAng);

    assertion(chamferSize*lgth < h, "h should be greater than tan(chamferAng)*chamferSize");
    assertion(D < D1, "D should be less than D1");
    assertion(h1 < h, "h1 should be less than h");

    r = D/2;
    r1 = D1/2;

    hole([pos], [rot]){

        children();

        if(chamfer){

            union(){

                hull(){

                    mTranslate([0, 0, H])
                        cylinder(r= r1 + chamferSize, h= 0.01, $fn= fn);

                    mTranslate([0, 0, -(0.01 + chamferSize*lgth)])
                        cylinder(r1= r1 - lgth*0.01, r2= r1 + chamferSize, h= 0.01 + chamferSize*lgth, $fn= fn);
                }

                mTranslate([0, 0, -h1])
                    cylinder(r= r1, h= (h1 - chamferSize*lgth), $fn= fn);

                mTranslate([0, 0, -h])
                    cylinder(r= r, h= h - h1 + 0.01, $fn= fn);
            }
        }
        else{

            union(){

                mTranslate([0, 0, -h1])
                    cylinder(r= r1, h= h1 + 0.01, $fn= fn);

                mTranslate([0, 0, -h])
                    cylinder(r= r, h= h - h1 + 0.01, $fn= fn);
            }

        }
    }
}

/*
counterbore(pos= [0, 0, 1], chamfer= true)
    cube(2, center= true);
*/

    // Cylindrical axle hole

/*
* cylindricalAxleHole(pos: position to set the axle hole,
*                     Daxe: Axle diameter,
*                     deltaD: gap length between the diameter of the axle and the hole diameter,
*                     h: full depth of the hole,
*                     fn: precision for the cylinder,
*                     rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as
*                          [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*                     chamfer: if true set a chamfer,
*                     chamferSize: width of the chamfer,
*                     chamferAng: angle of the chamfer should be ranged in ]0, 90[,
*                     edges: if(chamfer) place the chamfer to the correspnding face (Top or Bot only)
*                     H: Height of the hole cylinder above the chamfer (if a height greater than 0.01 is required, only with the chamfer))
*
* Note:
*   You can modify the value of fn in order to create regular shapes (equilateral triangle, square, pentagon, ...)
*/
module cylindricalAxleHole(pos= [0, 0, 0], Daxe = 1, deltaD = 0, h= 1, fn= 50, rot= ROT_Top, chamfer= false, chamferSize= 0.1, chamferAng= 30, edges= [EDGE_Top, EDGE_Bot], H= 0){

    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(0 < Daxe, "Daxe should be greater than 0");
    assertion(0 <= deltaD, "deltaD should be greater than equal to 0");
    assertion(0 < h, "h should be greater than 0");
    assertion(0 < fn, "fn should be greater than 0");
    assertion(len(rot) == 3, "rot should be a 3D vector");
    assertion(0 < chamferSize, "chamferSize should be greater than 0");
    assertion((chamferAng > 0) && (chamferAng < 90), "chamferAng should be ranged in ]0, 90[ °");
    assertion(0 <= H, "H should be greater than or equal to 0");

    lgth = tan(chamferAng);

    assertion(chamferSize*lgth < h, "h should be greater than tan(chamferAng)*chamferSize");
    assertion((len(edges) <= 2), "edges should only be [EDGE_Top], [EDGE_Bot] or both.");

    r = (Daxe + deltaD)/2;

    hole([pos], [rot]){

        children();

        if(chamfer){

            union(){

                if((edges[0] == EDGE_Top) || (edges[1] == EDGE_Top)){ // Top chamfer
                    
                    hull(){

                        mTranslate([0, 0, H])
                            cylinder(r= r + chamferSize, h= 0.01, $fn= fn);

                        mTranslate([0, 0, -(0.01 + chamferSize*lgth)])
                            cylinder(r1= r - lgth*0.01, r2= r + chamferSize, h= 0.01 + chamferSize*lgth, $fn= fn);
                    }     
                }           

                mTranslate([0, 0, -(h + 0.01)])             // Cylinder
                    cylinder(r= r, h= h + 0.02 , $fn= fn);
                
                if((edges[0] == EDGE_Bot) || (edges[1] == EDGE_Bot)){ // Bottom chamfer
                    
                    hull(){
                    
                        mTranslate([0, 0, -(h + H + 0.01)])
                            cylinder(r= r + chamferSize, h= 0.01, $fn= fn);
                    
                        mTranslate([0, 0, -h])
                            cylinder(r2= r - lgth*0.01, r1= r + chamferSize, h= 0.01 + chamferSize*lgth, $fn= fn);
                    }
                }
            }
        }
        else{

            mTranslate([0, 0, -(h + 0.01)])
                cylinder(r= r, h= h + 0.02, $fn= fn);
        }
    }
}
// Exemples:
/*
* 1. Pierce at the Right of a cube(size= [1, 2, 2]) an axle hole(Daxe= 1, deltaD= 0.02) chanfered at 30° at the top of the hole,
*    (<=> top edge with a right orientation gives a chamfered hole at the right)
*/
/*
cylindricalAxleHole(pos= [0.5, 0, 0], Daxe= 1, deltaD= 0.02, chamfer= true, rot= ROT_Rgt, edges= [EDGE_Top])
    cube(size= [1, 2, 2], center= true);
*/

/*
* 2. Pierce at the Right of a cube(size= [1, 2, 2]) an square axle hole(Daxe= 1, deltaD= 0.02) chanfered at 60° at the top of the hole
*/
/*
cylindricalAxleHole(pos= [0.5, 0, 0], Daxe= 1, deltaD= 0.02, fn= 4, chamfer= true, chamferAng= 60, rot= ROT_Rgt + [0, 0, 45], edges= [EDGE_Top])
    cube(size= [1, 2, 2], center= true);
*/

/*
* 3. Pierce at the Right of a cube(size= [1, 2, 2]) an hexagon axle hole(Daxe= 1, deltaD= 0.02) chanfered at 30° at the bottom of the hole
*/
/*
cylindricalAxleHole(pos= [0.5, 0, 0], Daxe= 1, deltaD= 0.02, fn= 6, chamfer= true, rot= ROT_Rgt + [0, 0, 30], edges= [EDGE_Bot])
    cube(size= [1, 2, 2], center= true);
*/