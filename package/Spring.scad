use <Bezier.scad>
use <Transforms.scad>
use <Basics.scad>
use <Vector.scad>
include <Constants.scad>

function stepper(P, ang, p) = [P.x * cos(ang) - P.y * sin(ang),
                               P.x * sin(ang) + P.y * cos(ang),
                               P.z + ang*p/360];

/*
* helicoid(A: point in the helicoid
*          r: The radius of the helicoid
*          nbTurn: The number of turn of the helicoid
*          p: The pitch between two step of the helicoid
*          fa: angular accuracy between each sub-module
*
* Result:
*   Create an helicoid of the form passed in children.
*/

module helicoid(A= [1,0,0], r= 1, nbTurn= 1, p= 1, fa= 1){
    
    assertion(r > 0, "r must be strictly greater than 0");
    assertion(A != TRANS_Null, "'A' must be different than the center of the cicle ([0,0,0])");
    assertion(abs(mod([A.x, A.y])) == r, "A must belong to the circle of radius r");
    assertion((360%fa)==0, "The remainder of the Euclidean division of 360 per fa must be equal to 0");
    
    iMax= nbTurn*360/fa;
    union(){
        for(i=[0 : iMax - 1]){
            
            hull(){
                
                mTranslate(stepper(A, i*fa, p))
                    mRotate([0, 0, i*fa])
                        children();
                
                mTranslate(stepper(A, (i + 1) * fa, p))
                    mRotate([0, 0, (i + 1)*fa])
                        children();
            }
        }
    }
}

/*
    helicoid(r= 1, nbTurn= 3, p= 1)
        sphere(0.1);
*/

module circularCompressionSpringBase(r, fn, length){
    mRotate([-90,0,0])
        linear_extrude(length)
            circle(r=r, $fn=fn);
}

/*
* circularCompressionSpring(A: point in the helicoid
*                           r: The radius of the base circle
*                           R: The radius of the helicoid
*                           nbTurn: The number of turn of the helicoid
*                           nbTurnStart: The number of turn for start the helicoid
*                           nbTurnEnd: The number of turn for end the helicoid
*                           p: The pitch between two step of the helicoid
*                           fa: angular accuracy between each sub-module
*                           fn: precision of the base circle
*
* Result:
*   Create a circular compression spring.
*/

module circularCompressionSpring(A= [1,0,0], r= 0.1, R= 1, nbTurn= 1, nbTurnStart= 1, nbTurnEnd= undef, p= 1, fa= 1, fn= 20){
    
    assertion(R > 0, "R must be strictly greater than 0");
    assertion(r > 0, "r must be strictly greater than 0");
    assertion(A != TRANS_Null, "'A' must be different than the center of the cicle ([0,0,0])");
    assertion(abs(mod([A.x, A.y])) == R, "A must belong to the circle of radius R");
    assertion((360%fa)==0, "The remainder of the Euclidean division of 360 per fa must be equal to 0");
    assertion((p > 2*r), "p must be strictly greater than 2*r");
    assertion(nbTurn > 0, "nbTurn must be stricly greater than 0"); 
    assertion(nbTurnStart > 0, "nbTurnStart must be stricly greater than 0");
    assertion((isDef(nbTurnEnd) ? (nbTurnEnd > 0) : (true)), "nbTurnEnd must be stricly greater than 0"); 
    
    length= (R-r)*tan(fa);
    startIncr = nbTurnStart*360/fa;
    middleIncr = nbTurn*360/fa;
    endIncr = (isDef(nbTurnEnd) ? (nbTurnEnd*360/fa) : (nbTurnStart*360/fa));
    B=A + [0, 0, nbTurn*p];

    union(){
        //Bottom
        for(i=[0 : startIncr -1]){
            hull(){
                
                mTranslate(stepper(A, -i*fa, 2*r))
                    mRotate([0, 0, -i*fa])
                        circularCompressionSpringBase(r, fn, length);
                
                mTranslate(stepper(A, -(i + 1) * fa, 2*r))
                    mRotate([0, 0, -(i + 1)*fa])
                        circularCompressionSpringBase(r, fn, length);
            }
        }
        
        //Middle
        for(i=[0 : middleIncr - 1]){
            
            hull(){
                
                mTranslate(stepper(A, i*fa, p))
                    mRotate([0, 0, i*fa])
                        circularCompressionSpringBase(r, fn, length);
                
                mTranslate(stepper(A, (i + 1) * fa, p))
                    mRotate([0, 0, (i + 1)*fa])
                        circularCompressionSpringBase(r, fn, length);
            }
        }
        
        //Top
        for(i=[0 : endIncr -1]){
            hull(){
                
                mTranslate(stepper(B, i*fa, 2*r))
                    mRotate([0, 0, i*fa])
                        circularCompressionSpringBase(r, fn, length);
                
                mTranslate(stepper(B, (i + 1) * fa, 2*r))
                    mRotate([0, 0, (i + 1)*fa])
                        circularCompressionSpringBase(r, fn, length);
            }
        }
    }
}
/*
    circularCompressionSpring(A= [1, 0, 0], r= 0.1, nbTurn= 3, nbTurnStart= 2, p= 1, fa= 1);
*/
/*
    circularCompressionSpring(A= [3, 0, 0], r= 0.3, R= 3, nbTurn= 4, nbTurnStart= 1, nbTurnEnd= 3, p= 2, fa= 1);
*/

function spiralPoints(A, r, i)= [[A.x - r - i*4*r,      A.y,                A.z],
                                 [A.x,                  A.y + 2*r + i*4*r,  A.z],
                                 [A.x + 3*r + i*4*r,    A.y,                A.z],
                                 [A.x,                  A.y + (-4)*r*(1+i), A.z]];

function spiralCenters(A, r)= [[A.x,     A.y,     A.z],
                                    [A.x,     A.y - r, A.z],
                                    [A.x - r, A.y - r, A.z],
                                    [A.x - r, A.y,     A.z]];

module baseSpiral(A, nbTurn, r, fn, dir){

    union(){

        union(){

            center= spiralCenters(A, r);
            for(i= [0 : nbTurn - 1]){

                pts = spiralPoints(A, r, i);
                bezierArcCurve(A= pts[0], alpha= dir*90, r= (r + i*4*r), fn= fn, pos= center[0], rot= true, theta= [0, 0, dir*90])
                    children();

                bezierArcCurve(A= pts[1], alpha= dir*90, r= (2*r + i*4*r), fn= fn, pos= center[1], rot= true, theta= [0, 0, dir*90])
                    children();

                bezierArcCurve(A= pts[2], alpha= dir*90, r= (3*r + i*4*r), fn= fn, pos= center[2], rot= true, theta= [0, 0, dir*90])
                    children();

                bezierArcCurve(A= pts[3], alpha= dir*90, r= (1 + i)*4*r, fn= fn, pos= center[3], rot= true, theta= [0, 0, dir*90])
                    children();
            }
        }
    }
}

module spiral(A= [0,0,0], nbTurn= 1, r= undef, p= undef, direction= CLOCKWIRE, pos= [0,0,0], rot= ROT_Top, fn= 20){
    
    assertion($children == 1, "this module requires a minimum of one sub-objects(/'children()')");
    assertion((len(A) == 3), "The lenght of A should be equal to 3");
    assertion(nbTurn > 0, "nbTurn should be greater than 0");
    assertion(!(isDef(r) && isDef(p)) || !(isUndef(r) && isUndef(p)), "Only one of the parameters (r, p) should be defined");
    assertion((len(pos) == 3), "The lenght of pos should be equal to 3");
    assertion((len(rot) == 3), "The lenght of rot should be equal to 3");
    assertion((direction == CLOCKWIRE) || (direction == ANTICLOCKWIRE), "The direction shoulb only be CLOCKWIRE or ANTICLOCKWIRE");
    
    mTranslate(pos)
        mRotate(rot){
            
            if(isDef(r)){
                
                assertion(r > 0, "r should be greater than 0");
            
                baseSpiral(A, nbTurn, r, fn, direction[0])
                    children();
            }
            else{
                
                assertion(p > 0, "p should be greater than 0");

                baseSpiral(A, nbTurn, p/4, fn, direction[0])
                    children();
            }
        }
}

spiral(nbTurn= 5, r= 0.04)
    cube(0.01, center= true);
//    sphere(0.01, $fn= 20);