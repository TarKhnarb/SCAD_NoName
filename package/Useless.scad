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


function getGearDim(alpha, m, Z) = [m*PI,              // Pas
        m*Z,               // Diamètre primitif
        m*(Z + 2),         // Diamètre de tête
        m*(Z-2.5),         // Diamètre depied
    m,                 // Saillie
        1.25*m,            // Creux
            m*Z*cos(alpha),    // Rayon de placement de la développante de cercle pour les dents
                m*Z*cos(alpha)/2];   // Rayon de la réveloppante de cercle

function invulteCircle(r, t) = [r*(cos(t*180/PI) + t*sin(t*180/PI)),
        r*(sin(t*180/PI) - t*cos(t*180/PI)),
    0];

function toothPts(r, t, n, k= 0) =
(k < n ? (concat([invulteCircle(r, k*t)], toothPts(r, t, n, k + 1))
) : (
    [invulteCircle(r, k*t)])
);

module tooth(m, d, fn= 10){

    t = 1/fn;
    pts = toothPts(d[7], t, fn - 1);
    echo(d[7]);
    pts2 = let(v = [])toothPts(d[7], -t, fn - 1);


    for(i= [0 : len(pts)-2]){

        hull(){

            mTranslate(pts[i])
            sphere(0.1, $fn= 50);

            mTranslate(pts[i + 1])
            sphere(0.1, $fn= 50);
        }
        /*   color("blue")
               mTranslate(pts2[i])
                   sphere(0.1, $fn= 50);*/
    }

    mTranslate([d[2]/2, -5, 0])
    cube(5, 5);
}

function invulteCircle2(r, t) = [r*(cos(t) + t*sin(t)),
        r*(sin(t) - t*cos(t)),
    0];

function toothPts2(r, t, n, k= 0) =
(k < n ? (concat([invulteCircle2(r, k*t)], toothPts2(r, t, n, k + 1))
) : (
    [invulteCircle2(r, k*t)])
);

module tooth2(m, Z, d, fn){

    fa = 360/Z;
    t = 1/fn;

    pts = toothPts(d[7], t, fn);
    pts2 = toothPts(d[7], -t, fn);

    for(i= [0 : len(pts) - 2]){

        hull(){

            mTranslate(pts[i])
            sphere(0.1, $fn= 20);

            rotZ(20)
            mTranslate(pts2[i])
            sphere(0.1, $fn= 20);

            mTranslate(pts[i + 1])
            sphere(0.1, $fn= 20);

            rotZ(20)
            mTranslate(pts2[i + 1])
            sphere(0.1, $fn= 20);
        }

        /*// Ancienne version
        hull(){

            mTranslate(pts[i])
                sphere(0.1, $fn= 20);

            mTranslate(pts[i + 1])
                sphere(0.1, $fn= 20);
        }

        rotZ(fa)
        hull(){

            mTranslate(pts2[i])
                sphere(0.1, $fn= 20);

            mTranslate(pts2[i + 1])
                sphere(0.1, $fn= 20);
        }

        */
        /*   color("blue")
               mTranslate(pts2[i])
                   sphere(0.1, $fn= 50);*/
    }
}

//alpha= 20 ou 14.5
module gear2(m= 1, Z= 13, alpha= 20, fn= 20){

    d= getGearDim(alpha, m, Z);

    mTranslate([0, 0, -0.05])
    cylinder(d= d[1], h= 0.1, $fn= fn);

    color("blue")
        mTranslate([0, 0, 0.1])
        cylinder(d= d[3], h= 0.1, $fn=fn);
    /*
    color("red")
        mTranslate([0, 0, -0.1])
            cylinder(d= d[2], h= 0.1, $fn= fn);
    */
    fa = 360/Z;

    difference(){

        union(){
            for(i= [0 /*: Z - 1*/]){

                rotZ(i*fa)
                tooth2(m, Z, d, fn);
            }
        }

        difference(){

            cylinder(d= d[2]*6/5, h= 1, $fn= 10+fn, center= true);
            cylinder(d= d[2], h= 1, $fn= 10+fn, center= true);
        }
    }
}

//    gear2(fn= 50);