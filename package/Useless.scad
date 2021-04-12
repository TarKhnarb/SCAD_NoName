module bevelBase(bevel, size, fn){

    mTranslate([bevel/2, bevel/2, 0])
    difference(){

        cube([bevel + 0.01, bevel + 0.01, size + 0.01], center= true);

        mTranslate([bevel/2, bevel/2, 0])
        cylinder(r= bevel, h= size + 0.02, center= true, $fn= fn);
    }
}

module bevelCylinder(h= 1, r= 1, bevel= 0.1, fn= 50, edges= [EDGE_Top, EDGE_Bot]){

    assertion(bevel < r/2, "chamfer must be less than half the smallest size of the cube ");
    assertion(len(edges) != 0, "chamfer must be less than half the smallest size of the cube ");
    assertion(fn > 1, "nb of chamfer must be greater than 1");

    step = 360/fn;
    length= 2*PI*r/fn;

    difference(){

        cylinder(r= r, h= h, $fn= fn, center= true);

        for(i= ((len(edges) - 1) == 0 ? [0] : [0 : len(edges) - 1])){

            if(edges[i] == EDGE_Top){

                for(j= [0 : fn - 1]){

                    transform(m= matRotZ((j + 1)*step)*scaleEdge(k= h/2, e= EDGE_Top)*scaleEdge(k= r, e= EDGE_Rgt)*matRot([-90, 0, 90]))
                    bevelBase(bevel, length, fn);
                }
            }
            if(edges[i] == EDGE_Bot){

                for(j= [0 : fn - 1]){

                    transform(m= matRotZ((j + 1)*step)*scaleEdge(k= h/2, e= EDGE_Bot)*scaleEdge(k= r, e= EDGE_Rgt)*matRot([90, 0, 90]))
                    bevelBase(bevel, length, fn);
                }
            }
        }
    }
}


//______________ TEST algo Casteljau ______________
function linearCombination(A, B, u, v) = A*u + B*v;

function linearInterpolation(A, B, t) = linearCombination(A, B, t, 1 - t);

function reduction(pts, t) = [for(i= [0 : len(pts) - 2])
                                linearInterpolation(pts[i], pts[i + 1], 1 - t)];

function recPointBezierAtI(pts, t, n) =
    (n > 1 ? (recPointBezierAtI(reduction(pts, t), t, n-1)
         ) : (
              pts[0])
    );

function pointBezierAtI(pts, t) = let(n = len(pts)/*, echo(t)*/) [recPointBezierAtI(pts, t, n)];

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

            echo(mod(makeVector(finalPts[i],finalPts[i+1])));
            color([1,0,0])
                mTranslate(finalPts[i])
                children();
        }
    }
}


module chamferAngBase(chamfer, fs, ang= 45){

    side = chamfer/cos(ang) + 0.06;

    x = [chamfer, 0, 0];
    y = [0.03*cos(ang), -0.03*sin(ang), 0];
    z = [side*cos(135-ang)*sqrt(2)/2, side*sin(135-ang)*sqrt(2)/2, 0];



    h = chamfer*tan(ang) + (-y.y);

    union(){

        difference(){

            mTranslate([-0.01, -0.01, -(fs + 0.02)/2])
            cube([chamfer + 0.015, h, fs + 0.02]);

            mTranslate(x + y + z)
            mRotate([0, 0, -ang])
            cube([side, side, fs + 0.03], center= true);
        }
    }
}