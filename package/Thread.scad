use<Transforms.scad>
use<Basics.scad>
use<Matrix.scad>
use<Vector.scad>
include<Constants.scad>

    // Runtime function
function stepper(P, ang, p) = [P.x * cos(ang) - P.y * sin(ang),
                               P.x * sin(ang) + P.y * cos(ang),
                               P.z + ang*p/360];

function polyhedronAtI(ang, Pts, p, k= 0) =
    (k == (len(Pts) - 1) ? ([stepper(Pts[k], ang, p)]
                       ) : (
                            concat([stepper(Pts[k], ang, p)], polyhedronAtI(ang, Pts, p, k + 1)))
    );

    // ISO triangular
function getISOTriangularDim(D, p) = [p*sqrt(3)/2,             // H:  Hauteur théorique du filet
                                      p*15*sqrt(3)/32,         // H1: Hauteur réele du filet
                                      p*3*sqrt(3)/8,           // H2: Hauteur de filet en contact
                                      D - p*15*sqrt(3)/16,     // D1:  Diamètre du noyau de la vis
                                      D + p*sqrt(3)/16,        // D2 Diamètre à fond de filet de l'écrou
                                      D - p*3*sqrt(3)/4,       // D3: Diamètre intérieur de l'écrou
                                      p*sqrt(3)/32];           // r: Rayon de l'arrondi

    // Thread tap

/*
* z A
*   |           3 ___ 2
*   |            |   |\
*   |            |   | \
*   |            |   |  \
*   |            |   |   \  1
*   |            |   |    |
*   |            |   |    |
*   |            |   |   / 0
*   |            |   |  /
*   |            |   | /
*   |____________|___|/__________>
*               4     5          x
*/
module ISOTriangularThreadMod(D= 1, p= 0.1, h= 1, fa= 1, gap= 0){

    assertion((-180 < fa) && (fa != 0) && (fa < 180), "fa must be within the following interval : [-180, 0[ U ]0, 180[");
    assertion((p > 0) && (p <= h), "p must be within the following interval : ]0, h]");
    
    assertion((360 % fa) == 0, "The remainder of the Euclidean division of 360 per fa must be equal to 0");

    d = getISOTriangularDim(D, p);
    nbTurns = 2 + h/p;
    iMax = nbTurns*(360/fa);

    sides = [[0, 5, 2, 1],  [5, 4, 3, 2],                    // Face 1
             [0, 1, 7, 6],  [1, 2, 8, 7],   [2, 3, 9, 8],   // Side
             [3, 4, 10, 9], [4, 5, 11, 10], [0, 6, 11, 5],
             [6, 7, 8, 11], [8, 9, 10, 11]];                // Face 2
    
    basePts = [[D/2 + gap,                    0,  -d[6] + p/2],
               [D/2 + gap,                    0,  d[6] + p/2],
               [-d[6] + d[3]/2 + gap,         0,  p],
               [-d[6] - 0.01 + d[3]/2 + gap,  0,  p],
               [-d[6] - 0.01 + d[3]/2 + gap,  0,  0],
               [-d[6] + d[3]/2 + gap,         0,  0]];
    
    mTranslate([0, 0, -p])
        difference(){
            
            union(){

                for(i= [0 : iMax]){
                   
                    pts = concat(polyhedronAtI(ang= i*fa, Pts= basePts, p= p), polyhedronAtI(ang= (i + 1)*fa, Pts= basePts, p= p));
                    
                    polyhedron(points= pts, faces= sides);
                }

                cylinder(r= -d[6] + d[3]/2 + gap, h= h + 3*p, $fn= 360/fa);
            }
            
            mTranslate([0, 0, h + 5*p/2])
                cube([D + 0.2 + 2*gap, D + 0.2 + 2*gap, 3*p], center= true);
            
            mTranslate([0, 0, -p/2])
                cube([D + 0.2 + 2*gap, D + 0.2 + 2*gap, 3*p], center= true);
        }
}

/*
* module ISOTriangularThread(D: thread diameter,
*                            p: thread pitch,
*                            h: thread height,
*                            fa: angular accuracy between each sub-module,
*                            pos: position to place the thread,
*                            rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as
*                                 [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*                            gap: gap to be applied to the initial position of the thread on the X axis,
*                            center: if true center the thread)
*/
module ISOTriangularThread(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], rot= ROT_Top, gap= 0, center= false){
   
    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
        mRotate(rot)
            ISOTriangularThreadMod(D, p, h, fa, gap);
}

//ISOTriangularThread(D= 4, p= 0.7, h= 5, fa= 4);
/*
D = 20;
fa = 10;
d= 6;

union(){
    
    difference(){
        
        union(){
        
            ISOTriangularThread(D= D, p= 2.5, h= 20, fa= fa, gap= -1);
                mTranslate([0, 0, -5]) cylinder(d= D, h= 5, $fn= 360/fa);
        }
        
        cylinder(d= d, h= 20.1, $fn= 360/fa);
    }
    
    ISOTriangularThreadTap(D= d, p= 1, h= 20, fa= fa);
}
*/

    // Thread

/*
* z A
*   |                2 ___ 3
*   |                /|   |
*   |               / |   |
*   |              /  |   |
*   |           1 /   |   |
*   |            |    |   |
*   |            |    |   |
*   |           0 \   |   |
*   |              \  |   |
*   |               \ |   |
*   |________________\|___|___________>
*                    5     4          x
*/
module ISOTriangularThreadTapMod(D= 1, p= 0.1, h= 1, fa= 1, gap= 0){

    assertion((-180 < fa) && (fa != 0) && (fa < 180), "fa must be within the following interval : [-180, 0[ U ]0, 180[");
    assertion((p > 0) && (p <= h), "p must be within the following interval : ]0, h]");

    d = getISOTriangularDim(D, p);
    nbTurns = 2 + h/p;
    iMax = nbTurns*(360/fa);

    sides = [[0, 1, 2, 5],  [2, 3, 4, 5],
             [0, 6, 7, 1],  [1, 7, 8, 2],   [2, 8, 9, 3],
             [3, 9, 10, 4], [5, 4, 10, 11], [0, 5, 11, 6],
             [6, 11, 8, 7], [8, 11, 10, 9]];

    basePts = [[d[5]/2 + gap,                0,  -d[6] + p/2],
               [d[5]/2 + gap,                0,  d[6] + p/2],
               [d[6] + d[4]/2 + gap,         0,  p],
               [d[6] + 0.01 + d[4]/2 + gap,  0,  p],
               [d[6] + 0.01 + d[4]/2 + gap,  0,  0],
               [d[6] + d[4]/2 + gap,         0,  0]];

    mTranslate([0, 0, -p])
        difference(){
            
            union(){
                
                for(i= [0 : iMax-1]){

                    pts = concat(polyhedronAtI(i*fa, basePts, p), polyhedronAtI((i + 1)*fa, basePts, p));

                    polyhedron(points= pts, faces= sides);
                }                
            }
            
            mTranslate([0, 0, h + 5*p/2])
                cube([d[6] + d[4] + 0.2 + 2*gap, d[6] + d[4] + 0.2 + 2*gap, 3*p], center= true);
            
            mTranslate([0, 0, -p/2])
                cube([d[6] + d[4] + 0.2 + 2*gap, d[6] + d[4] + 0.2 + 2*gap, 3*p], center= true);
        }
}

/*
* module ISOTriangularThreadTap(D: thread tap diameter,
*                               p: thread tap Pitch,
*                               h: thread tap height,
*                               fa: angular accuracy between each sub-module,
*                               pos: position to place the thread tap,
*                               rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as
*                                 [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*                               gap: gap to be applied to the initial position of the thread tap on the X axis,
*                               center: if true center the thread)
*/
module ISOTriangularThreadTap(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], rot= ROT_Top, gap= 0, center= false){

    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
        mRotate(rot)
            ISOTriangularThreadTapMod(D, p, h, fa, gap);
}

//ISOTriangularThreadTap(D= 4, p= 0.7, h= 5, fa= 4, gap= 0.5);
/*
D= 6;
fa= 20;

ISOTriangularThreadTapMod(D= D, h= 10, p= 1, fa= fa);
*/
/*
union(){
    
    ISOTriangularThreadTap(D= D, p= 2.5, h= 10, fa= fa, gap= 1);
    
    difference(){
        
        cylinder(d= D + 10, h= 10, $fn= 6);
        
        mTranslate([0,0,-1])
            cylinder(d= D, h= 12, $fn= 360/fa);
    }
}
*/

    // Trapezoidal
function getTrapezoidalThreadGap(p) =
    ((p < 2) ? (
                 0.15
           ) : (
                ((p <= 5) ? (
                              0.25
                        ) : (
                             ((p <= 12) ? (
                                            0.5
                                      ) : (
                                            1
                                          ))
                            ))
               )
    );

function getTrapezoidalDim(D, p, a) =
                                    [a + p/2,                               // h: hauteur du trapèze
                                     D - (a + p/2),                         // d1: diamètre interne du filetage
                                     (p - (p + 2*a)*(2 - sqrt(3)))/2,   // t:  longueur du sommet du trapèze
                                     (p + (p + 2*a)*(2 - sqrt(3)))/2];  // b:  longueur de la base du trapèze

    // Thread

/*
* z A
*   |           4 ___ 3
*   |            |   |
*   |            |   | 2
*   |            |   |\
*   |            |   | \
*   |            |   |  \
*   |            |   |   \  1
*   |            |   |    |
*   |            |   |    |
*   |            |   |   / 0
*   |            |   |  /
*   |            |   | /
*   |            |   |/
*   |            |   | 7
*   |____________|___|___________>
*               5     6          x
*/
module trapezoidalThreadmod(D= 1, p= 0.2, h= 1, fa= 1, gap= 0){

    assertion((-180 < fa) && (fa != 0) && (fa < 180), "fa must be within the following interval : [-180, 0[ U ]0, 180[");
    assertion((p > 0) && (p <= h), "p must be within the following interval : ]0, h]");

    a = getTrapezoidalThreadGap(p);
    d = getTrapezoidalDim(D, p, a);
    
    assertion((p + 2*a)*(2 - sqrt(3)) < p, "The choosen pitch is too small");
    
    nbTurns = 2 + h/p;
    iMax = nbTurns*(360/fa);
    echo(iMax);

    path = [[0, 7, 2, 1], [2, 5, 4, 3], [2, 7, 6, 5],
            [1, 9, 8, 0], [0, 8, 15, 7], [7, 15, 14, 6], [6, 14, 13, 5],
            [5, 13, 12, 4], [4, 12, 11, 3], [3, 11, 10, 2], [2, 10, 9, 1],
            [9, 10, 15, 8], [10, 11, 12, 13], [13, 14, 15, 10]];
 
    basePts = [[D/2 + gap,            0,  (p - d[2])/2],
               [D/2 + gap,            0,  (p + d[2])/2],
               [d[1]/2 + gap,         0,  (p + d[3])/2],
               [d[1]/2 + gap,         0,  p],
               [-0.1 + d[1]/2 + gap, 0,   p],
               [-0.1 + d[1]/2 + gap, 0,   0],
               [d[1]/2 + gap,         0,  0],
               [d[1]/2 + gap,         0,  (p - d[3])/2]];

    mTranslate([0, 0, -p])
        difference(){
            
            union(){

                for(i= [0 : iMax - 1]){


                    pts = concat(polyhedronAtI(i*fa, basePts, p), polyhedronAtI((i + 1)*fa, basePts, p));

                    polyhedron(points= pts, faces= path);
                }
                    cylinder(r= d[1]/2, h= h + 3*p, $fn= 360/fa);
            }

            mTranslate([0, 0, h + 5*p/2])
                cube([D + 0.2 + 2*gap, D + 0.2 + 2*gap, 3*p], center= true);
                
            mTranslate([0, 0, -p/2])
                cube([D + 0.2 + 2*gap, D + 0.2 + 2*gap, 3*p], center= true);
        }
}

module trapezoidalThread(D= 1, p= 0.12, h= 1, fa= 1, pos= [0, 0, 0], gap= 0, center= false){

   
    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
            trapezoidalThreadmod(D, p, h, fa, gap);
           
}


//trapezoidalThread(fa= 10, p = 0.4);
/*
difference(){
    
    trapezoidalThread(D= 13.157, p= 1.337, h= 4, fa= 10);
    mTranslate([5.5, 0.02,1])
    cube(1);
    
}
*/
    // Threadtap

/*
* z A
*   |
*   |
*   |                3 ___ 4
*   |                 |   |
*   |               2 |   |
*   |                /|   |
*   |               / |   |
*   |              /  |   |
*   |           1 /   |   |
*   |            |    |   |
*   |            |    |   |
*   |           0 \   |   |
*   |              \  |   |
*   |               \ |   |
*   |                \|   |
*   |               7 |   |
*   |_________________|___|___________>
*                    6     5          x
*/
module trapezoidalThreadTapmod(D= 1, p= 0.1, h= 1, fa= 1, gap= 0){

    assertion((-180 < fa) && (fa != 0) && (fa < 180), "fa must be within the following interval : [-180, 0[ U ]0, 180[");
    assertion((p > 0) && (p <= h), "p must be within the following interval : ]0, h]");

    a = getTrapezoidalThreadGap(p);
    d = getTrapezoidalDim(D, p, a);
    
    assertion((p + 2*a)*(2 - sqrt(3)) < p, "The choosen pitch is too small");
    
    nbTurns = 2 + h/p;
    iMax = nbTurns*(360/fa);

    path = [[0, 1, 2, 7],   [2, 3, 4, 5], [2, 5, 6, 7],       // Face 1

            [1, 0, 8, 9],   [2, 1, 9, 10],      // Side
            [2, 10, 11, 3], [3, 11, 12, 4],
            [4, 12, 13, 5], [5, 13, 14, 6],
            [6, 14, 15, 7], [7, 15, 8, 0],

            [15, 10, 9, 8], [13, 12, 11, 10], [15, 14, 13, 10]];   // Face 2

    basePts = [[(D - p)/2 + gap,            0,  (p - d[2])/2],
               [(D - p)/2 + gap,            0,  (p + d[2])/2],
               [a + D/2 + gap,         0,  (p + d[3])/2],
               [a + D/2 + gap,         0,  p],
               [0.1 + a + D/2 + gap, 0,  p],
               [0.1 + a + D/2 + gap, 0,  0],
               [a + D/2 + gap,         0,  0],
               [a + D/2 + gap,         0,  (p - d[3])/2]];

    echo(iMax, nbTurns);
    mTranslate([0, 0, -p])
        difference(){
            
            union(){

                for(i= [0 : iMax - 1]){


                    pts = concat(polyhedronAtI(i*fa, basePts, p), polyhedronAtI((i + 1)*fa, basePts, p));

                    polyhedron(points= pts, faces= path);
                }
            }
            
            mTranslate([0, 0, h + 5*p/2])
                cube([D + 0.4 + 2*a + 2*gap, D + 0.4 + 2*a + 2*gap, 3*p], center= true);
                
            mTranslate([0, 0, -p/2])
                cube([D + 0.4 + 2*a + 2*gap, D + 0.4 + 2*a + 2*gap, 3*p], center= true);
        }
}

module trapezoidalThreadTap(D= 1, p= 0.12, h= 1, fa= 1, pos= [0, 0, 0], gap= 0, center= false){

   
    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
            trapezoidalThreadTapmod(D, p, h, fa, gap);      
}

//trapezoidalThreadTap(D= 6, p=1, h=5, fa= 10);
/*
union(){
    
    difference(){
        
        cylinder(r= 4, h= 2.5, $fn= 360, center= true);

        cylinder(r= 2.5 + getTrapezoidalThreadGap(0.5), h= 2.6, $fn= 360, center= true);
        
    }
    
    trapezoidalThreadTap(D= 5, p= 0.5, h= 2, center= true);
}*/

/*
* knurling(r: radius of the knurling piece,
*          h: height of the knurling piece,
*          p: knurling pitch (only used with orient),
*          moduleNb: if ang defined, represent the number of knurling grooves, it should be even (only used with ang and orient= VERTICAL),
*          ang: if defined with an angle of 30 or 45, makes a diamond knurl,
*          orient: if defined with the VERTICAL or HORIZONTAL constant, makes a linear knurl,
*          fa: precision of the angle of rotation (only used with ang and orient= HORIZONTAL),
*          pos: position of the final piece,
*          rot: orientation ofthe fianl piece)
*
* Warning:
*   - The shape of the knurling and the part to be knurled must be placed so that the lower parts are on the XY plane oriented towards Z+.
*   - The pitch (p) is used when orient is defined. It is used to define the distance between two HORIZONTAL grooves.
*   - The number of modules (moduleNb) is used when ang or orient(= VERTICAL) are defined to determine the number of circular repetitions to be made.
*   - If you want to make a vertical knurling of a precise length, consider subtracting the height of the knurling piece from the total height. The first piece was placed on X axis with a translation of r, the other will been placed according a Z anti-clockwire rotation of the first piece.
*   -
*/

function knurlStepper(P, ang, p) = [P.x * cos(ang) - P.y * sin(ang),
                                    P.x * sin(ang) + P.y * cos(ang),
                                    P.z + abs(ang)*p/360];                               

module knurling(r= 1, h= 1, p= 0.1, moduleNb= 4, ang= undef, orient= undef, fa= 10, pos= [0, 0, 0], rot= ROT_Top){

    assertion($children == 2, "You must first pass the part to be knurled and then the shape to be repeated for knurling");
    assertion(!(isDef(ang) && isDef(orient)), "You cannot set diamond and linear knurling at the same time");
    assertion((len(pos) == 3), "You must given a 3D vector according [X, Y, Z]");
    assertion((h >= p), "The pitch must be smaller than or equal to the height");
    assertion((0 < fa) && (fa < 180), "fa must be within the following interval : [-180, 0[ U ]0, 180[");
//    assertion((moduleNb % 2 == 0), "The number of knurling grooves must be an even number");    

    if(isDef(ang)){

        assertion(((ang != 30) || (ang != 45)), "The angle of the diamond knurl must be 30 or 45°");
    }

    if(isDef(orient)){

        assertion(((orient != VERTICAL) || (orient != HORIZONTAL)), "The orient of the linear knurl must be HORIZONTAL or VERTICAL");
    }

    A = [r, 0, 0];
  //  fn = 360/moduleNb;

    mTranslate(pos)
        mRotate(rot)
            difference(){

                children(0);

                if(isDef(ang)){

                    assertion((360 % moduleNb == 0), "The remainder of the Euclidean division of 360 per moduleNb must be equal to 0");
                    
                    rotAng = 360/moduleNb;
                    
                    l = mod(makeVector(A, [r*cos(fa), r*sin(fa), 0])); //2*r*sin(fa/2);      // Pose problème.
                    fn = 360/fa;
                    length = l*tan(ang);
                    p = fn*length;
                    nbTurn = h/p;
                    iMax = nbTurn*fn;
                    /*
                    
                    fn = 360/fa;    // nb de rep/tours
                    nbTurn = h/p;
                    iMax = nbTurn*fn;
                    length = h/
                    */
                    echo(rotAng, length, nbTurn, fn, iMax);
                    #union(){

                        for(i= [0 : moduleNb - 1]){

                            k = pow(-1, i);
                            rotZ(i*rotAng)
                            union(){
                                for(j= [0 : iMax]){

                                    hull(){

                                        mTranslate(knurlStepper(A, k*j*fa, p))
                                            rotZ(k*j*fa)
                                            rotX(k*ang)
//                                            mRotate([k*ang, 0, k*j*fa])
                                                children(1);

                                        mTranslate(knurlStepper(A, k*(j + 1)*fa, p))
                                            rotZ(k*(j + 1)*fa)
                                            rotX(k*ang)
//                                            mRotate([k*ang, 0, k*(j + 1)*fa])
                                                children(1);
                                    }
                                }
                            }
                        }
                    }
                }
                else if(isDef(orient)){

                    if(orient == VERTICAL){

                        rotAng = 360/moduleNb;
                        union(){
                            for(i= [0 : moduleNb - 1]){

                                rotZ(i*rotAng)
                                    hull(){

                                        mTranslate(A)
                                            children(1);

                                        mTranslate(A + [0, 0, h])
                                            children(1);
                                    }
                            }
                        }
                    }
                    if(orient == HORIZONTAL){

                        nbTurn = h/p;
                        fn = 360/fa;
                        union(){
                            
                            for(i= [0 : moduleNb - 1]){

                                mTranslate([0, 0, i*p])
                                    union(){

                                        for(j= [0 : fn - 1]){
                                            
                                            hull(){
                                                
                                                rotZ(j*fa)
                                                    mTranslate(A)
                                                        children(1);
                                                
                                                rotZ((j + 1)*fa)
                                                    mTranslate(A)
                                                        children(1);
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
            }
}
/*
knurling(h= 1, ang= 35, moduleNb= 10, p = 0.4, fa= 10){

    mTranslate([0, 0, 0.1])
    cylinder(r= 1, h=1, $fn= 360/10);
    mTranslate([0.01, 0, 0])rotZ(90)rotX(45)cube([0.001, 0.1, 0.1], center= true);
}

mTranslate([1, 0, 0]) rotX(35) cube(0.1);
*/

/*
knurling(r= 1, h= 1 - 0.05, p= 0.2, orient= VERTICAL, moduleNb= 19, fa= 10){
    
    cylinder(r= 1, $fn= 30);
    mTranslate([-0.025, -0.025, 0]) cube(0.05);
}
*/
/*
knurling(r= 1, h= 1, p= 0.5, orient= HORIZONTAL, moduleNb= 6, fa= 10){
    
    cylinder(r= 1, $fn= 30);
    mTranslate([-0.025, -0.025, 0]) cube(0.05);
}
*/
//mTranslate([0, 0, 1])cube(1);