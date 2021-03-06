use<Basics.scad>
use<Vector.scad>
use<Transforms.scad>
use<Thread.scad>
include<Constants.scad>

/*
* bernstein(k: index,
*           n: maximal index,
*           t: precision ([0, 1]))
*/
function bernstein(k, n, t) = choose(n, k)*pow(t, k)*pow((1 - t), (n - k));

/*
* pointBezier(pts: control points of the curve,
*             n: len(pts) - 1 (for the sum),
*             t: point of the curve ([0, 1])
*             k: recursion parameter)
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
*/
module bezierCurve(pts, fn= 10, ang= undef){

    n = len(pts) - 1;
    assertion(n > 0, "You should give at least two points in a vector");
    for(i= [0 : n]){

        assertion(len(pts[i]) == 3, "pts should be a vector of 3D vectors");
    }

    assertion(0 < fn, "fn should be greater than 0");
    assertion($children == 1, "You should give a single 'children()'");
    if(isDef(ang)){
        
        assertion(len(ang) == 3, "ang should correspond to the following vector [angX, angY, angZ]");
    }

    t = 1/fn;
    rot = (isDef(ang) ? ang*1/fn : [0, 0, 0]);
    
    if($preview){
        
        for(i= [0 : n]){
            
            color("green")
                mTranslate(pts[i])
                    children();
        }
    }

    for(i = [0 : fn - 1]){

        hull() {

            mTranslate(pointBezier(pts, n, i*t))
                mRotate(rot*i)
                    children();
            
            mTranslate(pointBezier(pts, n, (i + 1)*t))
                mRotate(rot*(i + 1))
                    children();
        }
    }
}

pts = [[0,-2,0], [-2,-5,10], [3,9,2], [6,3,1], [-3,-1,2], [3,-2,1.5]];

/*
bezierCurve(pts, fn= 20)
    sphere(0.1, $fn= 30);
*/

/*
for(i = [0 : len(pts) - 1]){
    
    color("green")
    mTranslate(2*pts[i])
        cube(1, $fn= 50,center= true);
}*/

pts2 = [[1, 0, 0], [1, 1.1, 0], [0, 1.1, 0], [-1, 1.5, 0], [-1, 2, 0]];
/*
for(i = [0 : len(pts2) - 1]){
    
    color("green")
    mTranslate(10*pts2[i])
        cube(1, $fn= 50,center= true);
}

bezierCurve(10*pts2, 50, ang= [90, 0, 0])
    cube(1, center= true);
*/

/*
* bezierArcPts(aplha: angle of arc ]0, 360[,
*              r: radius of the circle,
*              A: start Point)
*/
function bezierArcPts(alpha, r, A) =
    let(L = r*tan(alpha/4)*(4/3),
        alphaP = atan(r/L),
        h = sqrt(r*r + L*L),
        a = (A.x == 0 ? r : r*r/A.x),
        b = (A.x == 0 ? L : A.y/A.x),
        yP = (a*b + sqrt(abs(h*h*b*b - a*a + h*h)))/(b*b + 1),
        yM = (a*b - sqrt(abs(h*h*b*b - a*a + h*h)))/(b*b + 1))
    (A.x == 0 ? ((A.y == 0 ? (echoError(msg= "A.x and A.y should both be different than 0")       // A.x && A.y == 0 => centre du cercle
                         ) : (
                              (A.y > 0 ? ([[-L, A.y, A.z], [L, A.y, A.z]]                       // Tests pour placer P,P' si A.x == 0
                                     ) : (
                                          [[L, A.y, A.z], [-L, A.y, A.z]]))))

            ) : ((A.y == 0 ? ((A.x > 0 ? ([[A.x, L, A.z], [A.x, -L, A.z]]                       // Tests pour placer P,P' si A.y == 0
                                     ) : (
                                          [[A.x, -L, A.z], [A.x, L, A.z]]))
                         ) : (                                                                  // Tests pour placer P,P' suivant le signe de A.x
                              (A.x > 0 ? ([[a - b*yP, yP, A.z], [a - b*yM, yM, A.z]]
                                     ) : (
                                          [[a - b*yM, yM, A.z], [a - b*yP, yP, A.z]])))))
    );

/*
* bezierArcCurve(A: starting point (it should belong to the circle of center= [0, 0, A.z (+ p)] and radius= r, should be different from [0, 0, A.z]),
*                alpha: angle of the arc, ]0, 180],
*                r: radius of the arc,
*                fn: number of children()/points on the curve,
*                pos: position to set the center of the curve,
*                p: pitch between A.z and A'.z, if undef A and A' are on the XY plan
*                rot: rotations [rotX, rotY, rotZ], applied between the first children and the last one, if undef no rotation applied,
*                theta: if rot, apply theta angle for the rotations of children(), default to [0, 0, 0])
*/
module bezierArcCurve(A= [1, 0, 0], alpha= 45, r= 1, fn= 10, pos= [0, 0, 0], rot= false, theta= [0, 0, 0]){

    assertion(len(A) == 3, "A should be a point (3D vector)");
    assertion(A != TRANS_Null, "A should be different than the center of the cicle ([0,0,0])");
    assertion(abs(mod([A.x, A.y])) == r, "A should belong to the circle of radius r");
    assertion((-181 < alpha) && (alpha < 181), "alpha should be within ]0, 180]");
    assertion(0 < r, "r should be greater than 0");
    assertion(0 < fn, "fn should be greater than 0");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(theta) == 3, "theta should be a 3D vector");

    A_ = bezierArcPts(alpha, r, A);
    As = [A.x*cos(alpha) - A.y*sin(alpha), A.x*sin(alpha)+ A.y*cos(alpha), A.z];
    As_ = bezierArcPts(alpha, r, As);

    toDraw = [A, A_[0], As_[1], As];

    if($preview){
        
        for(i= [0 : len(toDraw) - 1]){
            
            color("green")
                mTranslate(toDraw[i] + pos)
                    children();
        }
    }

    mTranslate(pos)
        bezierCurve(toDraw, fn, ang= (rot ? theta : undef))
            children();
}
/*
bezierArcCurve(pos = [0, -1, 0],alpha= 90, fn = 10)
    sphere(0.1, $fn= 10);
*/

/*
bezierArcCurve(alpha= 180, fn = 50)
    sphere(0.1, $fn= 50);
*/

/*
color("blue")
    bezierArcCurve(alpha= 180, rot= true, theta= [0, 0, 0], fn = 50)
        mRotate([0, 45,0])
            cube(0.1, center= true);
*/

function sumParametricPoint(M, n, m, u, v, i, j= 0) =
    ((j < m) ? (bernstein(i, n, u)*bernstein(j, m, v)*M[i][j] + sumParametricPoint(M, n, m, u, v, i, j + 1)
           ) : (
                bernstein(i, n, u)*bernstein(j, m, v)*M[i][j])
    );

/*
* parametricPoint(M: matrix of control points,
*                 n: number of lines in the matrix,
*                 m: number of rows in the matrix,
*                 u: u coordinate,
*                 v: v coordinate,
*                 i: recursion parameter)
*/
function parametricPoint(M, n, m, u, v, i= 0) =
    ((i < n) ? (sumParametricPoint(M, n, m, u, v, i) + parametricPoint(M, n, m, u, v, i + 1)
           ) : (
                sumParametricPoint(M, n, m, u, v, i))
    );

/*
* bezierSurface(M: matrix of control points (should be at least a square matrix of order 2),
*               U: accuracy between two points in a row of the matrix M, should be within ]0, 1[,
*               V: accuracy between two points in a column of the matrix M, should be within ]0, 1[,
*               fn: number of children()/points on the curve)
*/
module bezierSurface(M, U= undef, V= undef, fn= 10){

    n = len(M) - 1;
    assertion(n > 0, "You should give at least two rows in the matrix M");

    m = len(M[0]) - 1;
    assertion(m > 0, "You should give at least two columns in the matrix M");
    for(i= [1 : n]){

        assertion((len(M[i]) - 1) == m, "The matrix passed as parameter isn't correct, please check that it is consistent");
    }

    if(isDef(U)){

        assertion((0 < U) && (U < 1), "U should be within ]0, 1[");
    }

    if(isDef(V)){

        assertion((0 < V) && (V < 1), "V should be within ]0, 1[");
    }

    assertion(0 < fn, "fn should be greater than 0");
    assertion($children == 1, "You should give a single 'children()'");

    u = (isDef(U) ? U : 1/fn);
    v = (isDef(V) ? V : 1/fn);

    fu = (isDef(U) ? 1/U : undef);
    fv = (isDef(V) ? 1/V : undef);

    if($preview){

        for(i= [0 : n]){

            for(j = [0 : m]){

                color("green")
                    mTranslate(M[i][j])
                        children();
            }
        }
    }

    for(i= (isDef(fu) ? [0 : fu - 1] : [0 : fn - 1])){

        for(j= (isDef(fv) ? [0 : fv - 1] : [0 : fn - 1])) {

            hull(){

                mTranslate(parametricPoint(M, n, m, i*u, j*v))
                    children();


                mTranslate(parametricPoint(M, n, m, i*u, (j + 1)*v))
                    children();


                mTranslate(parametricPoint(M, n, m, (i + 1)*u, j*v))
                    children();


                mTranslate(parametricPoint(M, n, m, (i + 1)*u, (j + 1)*v))
                    children();
            }
        }
    }
}

matrix= [[[-1,   1,  1],     [0, 1,  0.5],   [1, 1,  -1]],
        [[-1,   0,  0],     [0, 0,  1],     [1, 0,  0.5]],
        [[-1,   -1, -1],    [0, -1, -1.5],  [1, -1, -0.5]]];

m= [[[-1,   1,  -3],     [0, 1,  -1],   [1, 1,  -3]],
        [[-1,   0,  -1],     [0, 0,  4],     [1, 0,  -1]],
        [[-1,   -1, -3],    [0, -1, -1],  [1, -1, -3]]];
/*
bezierSurface(M= 50*m,fn= 100)
    sphere(1, $fn= 20);
*/

/*
bezierSurface(M= m, U= 0.2, V= 0.5)
    sphere(0.1, $fn= 20);
*/

    // TODO à finir
module bezierTriangleSurface(M, path= undef, fn= 10){

    assertion(len(M) == 3, "You should give at least 3 vectors of control points");
    assertion(len(M.x) == len(M.y) == len(M.z), "You should give the same number of control sub-points in each of the vectors of M");
    assertion(1 <= fn, "fn should be greater than equal to 1");

    p = 1/fn;
}

module bezierSurfaceTriangle(M, U= undef, V= undef, fn= 10){

    n = len(M) - 1;
    assertion(n > 0, "You should give at least two rows in the matrix M");

    m = len(M[0]) - 1;
    assertion(m > 0, "You should give at least two columns in the matrix M");
    for(i= [1 : n]){

        assertion((len(M[i]) - 1) == m, "The matrix passed as parameter isn't correct, please check that it is consistent");
    }

    if(isDef(U)){

        assertion((0 < U) && (U < 1), "U should be within ]0, 1[");
    }

    if(isDef(V)){

        assertion((0 < V) && (V < 1), "V should be within ]0, 1[");
    }

    assertion(1 < fn, "fn should be greater than 1");
    assertion($children == 1, "You should give a single 'children()'");

    u = (isDef(U) ? U : 1/fn);
    v = (isDef(V) ? V : 1/fn);

    fu = (isDef(U) ? 1/U : undef);
    fv = (isDef(V) ? 1/V : undef);

    if($preview){

        for(i= [0 : n]){

            for(j = [0 : m]){

                color("green")
                    mTranslate(M[i][j])
                    children();
            }
        }
    }

    for(i= (isDef(fu) ? [0 : fu - 1] : [0 : fn - 1])){

        for(j= (isDef(fv) ? [0 : fv - 1] : [0 : fn - 1])) {

            hull(){

                mTranslate(parametricPoint(M, n, m, i*u, j*v))
                children();


                mTranslate(parametricPoint(M, n, m, i*u, (j + 1)*v))
                children();


                mTranslate(parametricPoint(M, n, m, (i + 1)*u, j*v))
                children();


                mTranslate(parametricPoint(M, n, m, (i + 1)*u, (j + 1)*v))
                children();
            }
        }
    }
}