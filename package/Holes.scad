use<Transforms.scad>
use<Basics.scad>
include<Constants.scad>

/*
* hole(pos: position of each holes to be pierced,
*      rots: rotation to applied to the hole base)
*
* Result: 
*   Pierce a hole in the first "action()" with the subsequent "actions()" as a pattern
* 
* WARNINGS: 
*      1. The hole patterns must be positioned in the centre of the system axes. In addition, if you wish to pierce a hole along the Z axis, you will have to place and size your part (to be removed) so that : 
*
*           - the volume of the part is positioned entirely in Z-negative
*           - the part has an additional portion of at least 0.01mm in Z-positive
*
*      2. You must necessarily indicate the translation to be applied to each of the parts, [0, 0, 0] if not desired. Note that you must pass in parameter a vector containing the translation vectors (1 vector for each hole parts).
*/
module hole(pos= [[0, 0, 0]], rots= [ROT_Top]){
    
    assertion($children > 1, "this module requires a minimum of two sub-objects(/'action()')");
    
    assertion(len(pos) > 0, "pos must be contain a minimum of 1 vector [x, y, z]");
    assertion(len(rots) > 0, "rots must be contain a minimum of 1 ROT_ constant");

    assertion(len(pos) == ($children - 1), "pos must be contain the same number of vectors as the number of sub-objects(/'action()') to be pierced");
    assertion(len(rots) == ($children - 1), "rots must be contain the same number of vectors as the number of sub-objects(/'action()') to be pierced");

    difference(){
        
        children(0);
        
        for(i= (($children - 1 == 0) ? [1] : [1 : $children - 1])){
            
            mTranslate(pos[i - 1])
                mRotate(rots[i - 1])
                    children(i);
        }
    }
}
 
// Exemple:
/*
* Pierce at the top and the bottom of a cube(size= 2) with a cylinder(r= 1, h= 0.5)
*/
/*
hole([[0, 0, 1], [0, 0, -1]]){
    
    cube(2, center= true);
    
    mTranslate([0, 0, -0.5])
        cylinder(r= 1, h= 0.5 + 0.01, $fn= 50);
    
    mTranslate([0, 0, -0.01])
        cylinder(r= 1, h= 0.5 + 0.01, $fn= 50);
}
*/

    // CylinderHole

/*
* cylinderHole(pos: position to set the hole,
*              r: radius of the cylinder,
*              h: depth of the hole,
*              fn: precision for the cylinder,
*              chamfer: if true set a chamfer of 30°,
*              chamferSize: width of the chamfer,
*              rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as 
*                   [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction) 
*
* Result: 
*   A cylinder hole chamfered or not
* 
* Note:
*   You can modify the value of fn in order to create regular shapes (equilateral triangle, square, pentagon, ...)
*/
module cylinderHole(pos= [0, 0, 0], r= 1, h= 1, fn= 50, chamfer= false, chamferSize= 0.1, rot= ROT_Top){
    
    assertion(chamferSize < h*sqrt(3)/3, "chamferSize must be less than h*sqrt(3)/3");
    
    hole([pos], [rot]){
        
        children();

        if(chamfer){
                
            union(){
                
                hull(){
                    
                    cylinder(r= r + chamferSize, h= 0.01, $fn= fn);
                        
                    mTranslate([0, 0, -(0.01 + chamferSize*sqrt(3)/3)])
                        cylinder(r1= r - sqrt(3)/300, r2= r + chamferSize, h= 0.01 + chamferSize*sqrt(3)/3, $fn= fn);
                }
                
                mTranslate([0, 0, -h])
                    cylinder(r= r, h= (h - chamferSize*sqrt(3)/3), $fn= fn);
            }
        }
        else{
            
            mTranslate([0, 0, -h])
                cylinder(r= r, h= h + 0.01, $fn= fn);
        }
    }
}

// Exemple:
/*
* Pierce at the Left of a cube(size= 5) with a cylinder(r= 1, h= 2) and chamfer it with an angle of 30° and a width of 0.5
*/
/*
cylinderHole(pos= [-2.5, 0, 0], r= 1, h= 2, fn= 50, chamfer= true, chamferSize= 0.5, rot= ROT_Lft)
    cube(5, center= true);
*/

    // CubeHole

/*
* cubeHole(pos: position to set the hole,
*          c: size of the cube,
*          h: depth of the hole,
*          chamfer: if true set a chamfer of 30°,
*          chamferSize: width of the chamfer,
*          rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as 
*               [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction) 
*
* Result: 
*   A cube hole chamfered or not
*/
module cubeHole(pos= [0, 0, 0], c= 1, h= 1, chamfer= false, chamferSize= 0.1, rot= ROT_Top){
    
    assertion(chamferSize < h*sqrt(3)/3, "chamferSize must be less than h*sqrt(3)/3");
    
    r = c*sqrt(2)/2;
    chamfSize = chamferSize*sqrt(2);
    
    hole([pos], [rot + [0, 0, 45]]){
        
        children();

        if(chamfer){
            union(){
                
                hull(){
                    
                    cylinder(r= r + chamfSize, h= 0.01, $fn= 4);
                        
                    mTranslate([0, 0, -(0.01 + chamferSize*sqrt(3)/3)])
                    cylinder(r1= r - sqrt(3)/300, r2= r + chamfSize, h= 0.01 + chamferSize*sqrt(3)/3, $fn= 4);
                }
                
                mTranslate([0, 0, -h])
                    cylinder(r= r, h= (h - chamferSize*sqrt(3)/3), $fn= 4);
            }
        }
        else{
            
            mTranslate([0, 0, -h])
                cylinder(r= r, h= h + 0.01, $fn= 4);
        }
    }
}

// Exemple:
/*
* Pierce at the Bottom of a cube(size= 5) with a square(width= 1, height= 2) and chamfer it with an angle of 30° and a width of 0.5
*/
/*
cubeHole(pos= [0, 0, -2.5], c= 1, h= 2, chamfer= true, chamferSize= 0.5, rot= ROT_Bot)
    cube(5, center= true);
*/

    // squareHole

/*
* squareHole(pos: position to set the hole,
*            size: size of the square according to the vector [width X, width Y],
*            h: depth of the hole,
*            chamfer: if true set a chamfer of 30°,
*            chamferSize: width of the chamfer,
*            rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as
*                 [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction)
*
* Result:
*   A square hole chamfered or not
*/
module squareHole(pos= [0, 0, 0], size= [1, 1], h= 1, chamfer= false, chamferSize= 0.01, rot= ROT_Top){
    
    assertion(chamferSize < h*sqrt(3)/3, "chamferSize must be less than h*sqrt(3)/3");

    hole([pos], [rot]){
        
        children();

        if(chamfer){

            union(){
                
                mTranslate([-size.x/2, -size.y/2, -h])
                    cube(size= [size.x, size.y, h + 0.01 - chamferSize*sqrt(3)/3]);

                polyhedron(points= [[-size.x/2,                 -size.y/2,                  -chamferSize*sqrt(3)/3],    // Bottom of the chamfer
                                    [-size.x/2,                 size.y/2,                   -chamferSize*sqrt(3)/3],
                                    [size.x/2,                  size.y/2,                   -chamferSize*sqrt(3)/3],
                                    [size.x/2,                  -size.y/2,                  -chamferSize*sqrt(3)/3],
                                    [-chamferSize - size.x/2,   -chamferSize - size.y/2,    0],                         // Top of the chamfer
                                    [-chamferSize - size.x/2,   chamferSize + size.y/2,     0],
                                    [chamferSize + size.x/2,    chamferSize + size.y/2,     0],
                                    [chamferSize + size.x/2,    -chamferSize - size.y/2,    0],
                                    [-chamferSize - size.x/2,   -chamferSize - size.y/2,    0.02],                      // Top addition of the chamfer
                                    [-chamferSize - size.x/2,   chamferSize + size.y/2,     0.02],
                                    [chamferSize + size.x/2,    chamferSize + size.y/2,     0.02],
                                    [chamferSize + size.x/2,    -chamferSize - size.y/2,    0.02]],

                           faces= [[0, 3, 2, 1],                                  // Bottom face

                                   [0, 1, 5, 4],   [1, 2, 6, 5],      // Slide bottom to top
                                   [2, 3, 7, 6],   [0, 4, 7, 3],

                                   [4, 5, 6, 7],                      // Top face

                                   [4, 5, 9, 8],   [5, 6, 10, 9],     // Slide top to top addition
                                   [6, 7, 11, 10], [4, 7, 11, 8],

                                   [8, 9, 10, 11]]                                // Top addition face
                        );
                }
        }
        else{
            
            mTranslate([-size.x/2, -size.y/2, -h])
                cube(size= [size.x, size.y, h + 0.01]);
        }
      }
}

// Exemple:
/*
* Pierce at the Top and the Front of a cube(size= 5) with a square(width [x, y]= [1, 3], height= 2),
* only the Top is chamfered with an angle of 30° and a width of 0.5
*/
/*
squareHole(pos= [0, -2.50, 0], size= [1, 3], h= 2, chamfer= false, chamferSize= 0.5, rot= ROT_Frt)
    squareHole(pos= [0, 0, 2.50], size= [1, 3], h= 2, chamfer= true, chamferSize= 0.5)
        cube(5, center= true);
*/

    // Counterbore

/*
*       _______________          D1           _______________
*      |               |<------------------->|  A     A      |
*      |               |                     |  |     |  h1  |
*      |               |                     |  |     |      |
*      |               |____             ____|  |     V      |
*      |                    |     D     |       |            |
*      |                    |<--------->|       | h          |
*      |                    |           |       |            |
*
*
 */
/*
* counterbore(pos: position to set the hole,
*             D: cylinder diameter,
*             h: full depth of the hole,
*             D1: diameter ofthe counterbore,
*             h1: depth of the counterbore,
*             fn: precision for the cylinder,
*             chamfer: if true set a chamfer of 30°,
*             chamferSize: width of the chamfer,
*             rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as
*                  [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction)
*
* Result:
*   A counterbore chamfered or not
*
* Note:
*   You can modify the value of fn in order to create regular shapes (equilateral triangle, square, pentagon, ...)
*/
module counterbore(pos= [0, 0, 0], D= 0.5, h= 1, D1= 1, h1= 0.5, fn= 50, chamfer= false, chamferSize= 0.1, rot= ROT_Top){

    assertion(chamferSize < h1*sqrt(3)/3, "chamferSize must be less than h*sqrt(3)/3");
    assertion(D < D1, "D must be less than D1");
    assertion(h1 < h, "h1 must be less than h");

    r = D/2;
    r1 = D1/2;

    hole([pos], [rot]){

        children();

        if(chamfer){

            union(){

                hull(){

                    cylinder(r= r1 + chamferSize, h= 0.01, $fn= fn);

                    mTranslate([0, 0, -(0.01 + chamferSize*sqrt(3)/3)])
                        cylinder(r1= r1 - sqrt(3)/300, r2= r1 + chamferSize, h= 0.01 + chamferSize*sqrt(3)/3, $fn= fn);
                }

                mTranslate([0, 0, -h1])
                    cylinder(r= r1, h= (h1 - chamferSize*sqrt(3)/3), $fn= fn);

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

// Exemple:
/*
* Pierce at the Top ofa cube(size= 2) a counterbore(D= 0.5, h= 1, D1= 1, h1= 0.5) chamfered with an angle of 30°and a width of 0.1
*/
/*
counterbore(pos= [0, 0, 1], chamfer= true)
    cube(2, center= true);
*/

