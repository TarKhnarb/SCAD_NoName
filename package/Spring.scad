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

    assertion(len(A) == 3, "A should be a 3D vector");
    assertion(A != TRANS_Null, "A should be different than the center of the cicle ([0,0,0])");
    assertion(abs(mod([A.x, A.y])) == r, "A should belong to the circle of radius r");
    assertion(0 < r, "r should be greater than 0");
    assertion(0 < nbTurn, "nbTurn should be greater than 0");
    assertion(0 < p, "p should be greater than 0");
    assertion(0 < fa, "fa should be greater than 0");
    assertion((360%fa) == 0, "The remainder of the Euclidean division of 360 per fa should be equal to 0");
    
    iMax = nbTurn*360/fa;
    union(){

        for(i= [0 : iMax - 1]){
            
            hull(){
                
                mTranslate(stepper(A, i*fa, p))
                    mRotate([0, 0, i*fa])
                        children();
                
                mTranslate(stepper(A, (i + 1)*fa, p))
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

    mRotate([-90, 0, 0])
        linear_extrude(length)
            circle(r= r, $fn= fn);
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

    assertion(len(A) == 3, "A should be a 3D vector");
    assertion(A != TRANS_Null, "A should be different than the center of the cicle ([0,0,0])");
    assertion(0 < R, "R should be strictly greater than 0");
    assertion(abs(mod([A.x, A.y])) == R, "A should belong to the circle of radius R");

    assertion(0 < r, "r should be greater than 0");
    assertion(0 < nbTurn, "nbTurn should be greater than 0");
    assertion(0 < nbTurnStart, "nbTurnStart should be greater than 0");
    assertion((isDef(nbTurnEnd) ? (nbTurnEnd > 0) : (true)), "nbTurnEnd should be greater than 0");
    assertion(2*r < p, "p should be strictly greater than 2*r");
    assertion(0 < fa, "fa should be greater than 0");
    assertion((360%fa) == 0, "The remainder of the Euclidean division of 360 per fa should be equal to 0");
    assertion(0 < fn, "fn should be greater than 0");

    length = (R - r)*tan(fa);
    startIncr = nbTurnStart*360/fa;
    middleIncr = nbTurn*360/fa;
    endIncr = (isDef(nbTurnEnd) ? (nbTurnEnd*360/fa) : startIncr);
    B = A + [0, 0, nbTurn*p];

    union(){
        //Bottom
        for(i= [0 : startIncr -1]){

            hull(){
                
                mTranslate(stepper(A, -i*fa, 2*r))
                    mRotate([0, 0, -i*fa])
                        circularCompressionSpringBase(r, fn, length);
                
                mTranslate(stepper(A, -(i + 1)*fa, 2*r))
                    mRotate([0, 0, -(i + 1)*fa])
                        circularCompressionSpringBase(r, fn, length);
            }
        }
        
        //Middle
        for(i= [0 : middleIncr - 1]){
            
            hull(){
                
                mTranslate(stepper(A, i*fa, p))
                    mRotate([0, 0, i*fa])
                        circularCompressionSpringBase(r, fn, length);
                
                mTranslate(stepper(A, (i + 1)*fa, p))
                    mRotate([0, 0, (i + 1)*fa])
                        circularCompressionSpringBase(r, fn, length);
            }
        }
        
        //Top
        for(i=[0 : endIncr - 1]){
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

module baseSpiral(A, nbTurn, r, fn){

    union(){

        union(){
            
            center = spiralCenters(A, r);

            pts = spiralPoints(A, r, 0);

            rotZ(-90)
                bezierArcCurve(A= pts[0], alpha= -asin(1/4) + 90, r= r, fn= fn, pos= center[0], rot= true, theta= [0, 0, -asin(1/4) + 90])
                    children();

            bezierArcCurve(A= pts[1], alpha= -90, r= 2*r, fn= fn, pos= center[1], rot= true, theta= [0, 0, -90])
                children();
            
            bezierArcCurve(A= pts[2], alpha= -90, r= 3*r, fn= fn, pos= center[2], rot= true, theta= [0, 0, -90])
                children();

            bezierArcCurve(A= pts[3], alpha= -90, r= 4*r, fn= fn, pos= center[3], rot= true, theta= [0, 0, -90])
                children();

            if(1 < nbTurn){

                for(i= [1 : nbTurn - 1]){

                    pts = spiralPoints(A, r, i);
                    
                    bezierArcCurve(A= pts[0], alpha= -90, r= (r + i*4*r), fn= fn, pos= center[0], rot= true, theta= [0, 0, -90])
                        children();

                    bezierArcCurve(A= pts[1], alpha = -90, r= (2*r + i*4*r), fn= fn, pos= center[1], rot= true, theta= [0, 0, -90])
                        children();

                    bezierArcCurve(A= pts[2], alpha= -90, r= (3*r + i*4*r), fn= fn, pos= center[2], rot= true, theta= [0, 0, -90])
                        children();

                    bezierArcCurve(A= pts[3], alpha= -90, r= (1 + i)*4*r, fn= fn, pos= center[3], rot= true, theta= [0, 0, -90])
                        children();
                }
            }
        }

        bezierArcCurve(A= [-r/4, 0, 0], alpha= 90, r= r/4, fn= fn, pos= [-r*(cos(asin(1/4)) - 1/4), r/4, 0], rot= true, theta= [0, 0, 90])
            children();
        
        hull(){

            mTranslate([-r*(cos(asin(1/4)) - 1/4), 0, 0])
                children();

            children();
        }

        hull(){
            mTranslate([-r -nbTurn*4*r, 0, 0])
                children();

            mTranslate([-r -nbTurn*4*r, r + (nbTurn - 1)*4*r, 0])
                children();
        }
    }
}

module spiral(A= [0,0,0], nbTurn= 1, r= undef, p= undef, direction= CLOCKWIRE, pos= [0,0,0], rot= ROT_Top, fn= 20){
    
    assertion((len(A) == 3), "A should be a 3D vector");
    assertion(0 < nbTurn, "nbTurn should be greater than 0");
    assertion(!(isDef(r) && isDef(p)) || !(isUndef(r) && isUndef(p)), "Only one of the parameters (r, p) should be defined");
    assertion((direction == CLOCKWIRE) || (direction == ANTICLOCKWIRE), "The direction should only be CLOCKWIRE or ANTICLOCKWIRE");
    assertion((len(pos) == 3), "pos should be a 3D vector");
    assertion((len(rot) == 3), "rot should be a 3D vector");
    assertion(0 < fn, "fn should be greater than 0");
    assertion($children == 1, "This module requires a minimum of one 'children()'");

    mTranslate(pos)
        mRotate(rot)
            rotX((1 + direction[0])*90){

                if(isDef(r)){

                    assertion(0 < r, "r should be greater than 0");

                    baseSpiral(A, nbTurn, r, fn)
                        children();
                }
                else{

                    assertion(0 < p, "p should be greater than 0");

                    baseSpiral(A, nbTurn, p/4, fn)
                        children();
                }
            }
}

spiral(nbTurn= 5, r= 0.2, direction= ANTICLOCKWIRE)
    cylinder(r= 0.05, h= 0.05, $fn= 30);
//    cube([0.01, 0.01, 0.05], center= true);
//    sphere(0.01, $fn= 20);