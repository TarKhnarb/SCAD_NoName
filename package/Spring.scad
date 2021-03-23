use <Bezier.scad>
use <Transforms.scad>
use <Basics.scad>
use <Vector.scad>
include <Constants.scad>

function stepper(P, ang, p) = [P.x * cos(ang) - P.y * sin(ang),
                               P.x * sin(ang) + P.y * cos(ang),
                               P.z + ang*p/360];

module spring(A= [1,0,0], r= 1, nbTurn= 1, p= 1, fa= 1){
    
    assertion(r > 0, "r must be strictly greater than 0");
    assertion(A != TRANS_Null, "'A' must be different than the center of the cicle ([0,0,0])");
    assertion(abs(mod([A.x, A.y])) == r, "A must belong to the circle of radius r");
    assertion((360%fa)==0, "The remainder of the Euclidean division of 360 per fa must be equal to 0");
    
    iMax= nbTurn*360/fa;
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

/*
spring(r= 1, nbTurn= 3, p= 1)
    sphere(0.1);
*/

module circularCompressionSpringBase(r, fn, length){
    mRotate([-90,0,0])
        linear_extrude(length)
            circle(r=r, $fn=fn);
}

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
    
    //Dessus
    startIncr = nbTurnStart*360/fa;
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
    
    middleIncr = nbTurn*360/fa;
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
    
    //Dessous
    endIncr = (isDef(nbTurnEnd) ? (nbTurnEnd*360/fa) : (nbTurnStart*360/fa));
    B=A + [0, 0, nbTurn*p];
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

//circularCompressionSpring(A= [1, 0, 0], r= 0.1, nbTurn= 3, nbTurnStart= 2, p= 1, fa= 1);

//circularCompressionSpring(A= [3, 0, 0], r= 0.3, R= 3, nbTurn= 4, nbTurnStart= 1, nbTurnEnd= 3, p= 2, fa= 1);