use<Basics.scad>
use<Vector.scad>
use<Transforms.scad>
include<Constants.scad>

/*
* bernstein(k: index,
*           n: maximal index,
*           t: precision ([0, 1]))
*
* Return:
*   The Bernstein polynomial evaluated at k.
*/
function bernstein(k, n, t) = choose(n, k)*pow(t, k)*pow((1 - t), (n - k));

/*
* pointBezier(pts: control points of the curve,
*             n: len(pts) - 1 (for the sum),
*             t: point of the curve ([0, 1])
*             k: recursion parameter)
*
* Return:
*   Coordinate of the point at t.
*/
function pointBezier(pts, n, t, k= 0) =
    (k < n ? (bernstein(k, n, t)*pts[k] + pointBezier(pts, n, t, k + 1)
         ) : (
              bernstein(k, n, t)*pts[k])
    );

/*
* bezierCurve(pts: control points of the curve
*             fn: number of children()/points on the curve,
*             ang: angle of the rotations [rotX, rotY, rotZ] to apply between the first children and the last one, if undef no rotation applied)
*
* Result:
*   Bezier curve of a children().
*/
module bezierCurve(pts, fn= 10, ang= undef){

    n = len(pts) - 1;

    assertion(1 < fn, "nbSegment must be greater than 1");
    assertion(n > 0, "You must give at least two points");
    if(isDef(ang)){
        
        assertion(len(ang) == 3, "ang must correspond to the following vector [angX, angY, angZ]");
    }

    t = 1/fn;
    
    theta = angleVectors(pts[n], pts[0]);
    
    rot = (isDef(ang) ? ang*1/fn : [0, 0, 0]);

    for(i = [0 : fn - 1]){

//        color([1,0,0])
        hull() {


            mTranslate(pointBezier(pts, n, i * t))
            mRotate(rot * i)
            children();
            
            mTranslate(pointBezier(pts, n, (i + 1) * t))
            mRotate(rot * (i + 1))
            children();
        }
    }
}


/*
pts = [[0,-2,0], [-2,-5,10], [3,9,2], [6,3,1], [-3,-1,2], [3,-2,1.5]];


for(i = [0 : len(pts) - 1]){
    
    color("green")
    mTranslate(2*pts[i])
        cube(1, $fn= 50,center= true);
}


bezierCurve(2*pts, 50)
    sphere(0.5, $fn= 50);
*/

/*
pts2 = [[1, 0, 0], [2, 1.1, 0], [0, 1.1, -1], [-1, 1.5, 0], [-1, 2, 0]];

for(i = [0 : len(pts2) - 1]){
    
    color("green")
    mTranslate(10*pts2[i])
        cube(1, $fn= 50,center= true);
}

bezierCurve(10*pts2, 50, ang= [180, 0, 0])
    cube(1, center= true);
*/

/*
* bezierArcPts(aplha: angle of arc ]0, 360[,
*              r: radius of the circle,
*              A: start Point)
*
* Return:
*   Points to generate an arc with a Bezier curve.
*/
function bezierArcPts(alpha, r, A, helicoide= false, H= 0.01) =
    let(L= tan(alpha/4)*4/3,
        alphaP= atan(r/L),
        h= sqrt(r*r + L*L),
        a= (A.x == 0 ? r : r*r/A.x),
        b= (A.x == 0 ? L : A.y/A.x),
        yP= (a*b + sqrt(abs(h*h*b*b - a*a + h*h)))/(b*b + 1),
        yM= (a*b - sqrt(abs(h*h*b*b - a*a + h*h)))/(b*b + 1),
        t= (helicoide ? H : 0))
    (A.x == 0 ? ((A.y == 0 ? (echoError(msg= "A.x and A.y must both be differnet than 0")       // A.x && A.y == 0 => centre du cercle
                         ) : (
                              (A.y > 0 ? ([[-L, A.y, A.z + t], [L, A.y, A.z - t]]                       // Tests pour placer P,P' si A.x == 0
                                     ) : (
                                          [[L, A.y, A.z + t], [-L, A.y, A.z - t]]))))

            ) : ((A.y == 0 ? ((A.x > 0 ? ([[A.x, L, A.z + t], [A.x, -L, A.z - t]]                       // Tests pour placer P,P' si A.y == 0
                                     ) : (
                                          [[A.x, -L, A.z + t], [A.x, L, A.z - t]]))
                         ) : (                                                                  // Tests pour placer P,P' suivant le signe de A.x
                              (A.x > 0 ? ([[a - b * yP, yP, A.z + t], [a - b * yM, yM, A.z - t]]
                                     ) : (
                                          [[a - b * yM, yM, A.z + t], [a - b * yP, yP, A.z - t]])))))
    );

/*
* bezierArcCurve(A: starting point (it must belong to the circle of center= [0, 0, A.z (+ p)] and radius= r, must be different from [0, 0, A.z]),
*                alpha: angle of the arc, ]0, 180],
*                r: radius of the arc,
*                fn: number of children()/points on the curve,
*                p: pitch between A.z and A'.z, if undef A and A' are on the XY plan
*                rot: rotations [rotX, rotY, rotZ], applied between the first children and the last one, if undef no rotation applied,
*                theta: if rot, apply theta angle for the rotations of children(), default to [0, 0, 0])
*
* Result:
*   Arc from radius r and angle ang of children().
*/
module bezierArcCurve(A= [1, 0, 0], alpha= 45, r= 1, fn= 10, p= undef, rot= false, theta= [0, 0, 0], helicoide= false){

    assertion((0 < alpha) && (alpha < 181), "alpha must belong to ]0, 180]");
    assertion(r > 0, "r must be strictly greater than 0");
    assertion(A != TRANS_Null, "'A' must be different than the center of the cicle ([0,0,0])");

    // TODO voir comment fix
//    assertion(abs(mod([A.x, A.y, 0])) == r, "A must belong to the circle of radius r");
    
    h = p/(2*fn);

    A_ = bezierArcPts(alpha, r, A, helicoide= helicoide, H= h);
    As = [A.x*cos(alpha) - A.y*sin(alpha), A.x*sin(alpha)+ A.y*cos(alpha), (isDef(p) ? A.z + p : A.z)];
    As_ = bezierArcPts(alpha, r, As);

    toDraw = [A, A_[0], As_[1], As];
    
    /*for(i= [0 : len(toDraw) - 1]){
        
        color("green")
            mTranslate(toDraw[i])
                children();
    }*/

    bezierCurve(toDraw, fn, ang= (rot ? theta : undef))
        children();
}
/*
bezierArcCurve(alpha= 105, fn = 50)
    sphere(0.1, $fn= 50);
*/
/*
color("blue")
bezierArcCurve(alpha= 180, rot= true, p= 1, theta= [0, 90, 45], fn = 50)
    sphere(0.1, $fn= 50);
*/

/*
* placeCircularPts(A: starting point,
*                p: pitch report between A^A'= (180),
*                n: number of circle turns (/top control points),
*                k: recursion parameter)
*
* Return:
*   Top control points for the circular curve. A circle is decomposed into half circles (bezierArcCurve(alpha=180))
*/
function placeCircularPts(A, p, n, k= 0) =
    (k < 2*n-1 ? (concat([[A.x, A.y, p*k]*matVectRotZ(-180*k)], placeCircularPts(A, p, n, k + 1))
         ) : (
              [[A.x, A.y, p*k]*matVectRotZ(180*k)])
    );
/*
* bezierCircularCurve(A: starting point,
*                     r: radius of the circle,
*                     rotNb: number of rotations,
*                     p: pitch of a turn,
*                     fn: number of children()/points on the curve)
*
* Result:
*
 */
module bezierCircularCurve(A= [1, 0, 0], r= 1, rotNb= 1, p= 0.5, fn= 10, helicoide= false){
    
    assertion(r > 0, "r must be strictly greater than 0");
    assertion(A != TRANS_Null, "'A' must be different than the center of the cicle ([0,0,0])");
    assertion(rotNb > 0, "rotNb must be greater than 0");

    // TODO voir comment fix
//    assertion(abs(mod([A.x, A.y, 0])) == r, "A must belong to the circle of radius r");

    pR = p/2;
    
    T = placeCircularPts(A, pR, rotNb);
    
    t = len(T) - 1;
 
 /*   
    for(i= [0 : t]){
        
        mTranslate(T[i])  
            children();
    }*/

    union(){

        for(i= [0 : t]){
            
            bezierArcCurve(A= T[i], alpha= 180, r= r, fn= fn, p= pR, rot= true, theta=[0,0,180], helicoide= helicoide)
                children();
        }
    }
}

/*
bezierCircularCurve(p= -0.5,r= 5, rotNb= 2, fn= 100)
    sphere(0.1, $fn= 30);
*/
/*
color("red")
bezierCircularCurve(r= 5, rotNb= 3, fn= 100, helicoide= true)
    sphere(0.1, $fn= 30);
*/

//______________ TEST algo Casteljau ______________
function linearCombination(A, B, u, v) = A*u + B*v;

function linearInterpolation(A, B, t) = linearCombination(A, B, t, 1 - t);

function reduction(pts, t) = 
    [for(i= [0 : len(pts) - 2]) 
        linearInterpolation(pts[i], pts[i + 1], 1 - t)];

function recPointBezierAtI(pts, t, n) =
    (n > 1 ? (recPointBezierAtI(reduction(pts, t), t, n-1)
         ) : (
              pts[0])
    );

function pointBezierAtI(pts, t) = let(n = len(pts)) [recPointBezierAtI(pts, t, n)];

function concatBezier(pts, t, fn, k= 1) = 
    (k < fn - 1 ? (concat(pointBezierAtI(pts, k*t), concatBezier(pts, t, fn, k + 1))
           ) : (
                pointBezierAtI(pts, k*t))
);

module bezierCurve2(pts, fn= 10){

    assertion(1 < fn, "nbSegment must be greater than 1");
    assertion(len(pts) > 1, "You must give at least two points");

    n = len(pts);
    t = 1/fn;
    
    finalPts = concat([pts[0]], concatBezier(pts, t, fn, n), [pts[n-1]]);
    
    union(){
    for(i = [0 : len(finalPts) - 1]){
        
        color([1,0,0])
        mTranslate(finalPts[i])
            children();
    }
      }
}

/*
color("blue")
bezierCurve2(10*pts, 50)
    sphere(0.5, $fn= 50);
*/