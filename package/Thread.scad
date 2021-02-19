use<Transforms.scad>
use<Basics.scad>
use<Matrix.scad>
include<Constants.scad>

    // Runtime function
function stepper(P, ang, p) = [P.x * cos(ang) - P.y * sin(ang),
                               P.x * sin(ang) + P.y * cos(ang),
                               P.z + ang*p/360];

function polyhedronAtI(ang, Pts, p, k= 0) =
    (k == (len(Pts) - 1) ? (
                            [stepper(Pts[k], ang, p)]
                       ) : (
                            concat([stepper(Pts[k], ang, p)], polyhedronAtI(ang, Pts, p, k + 1)))
    );
    
function polyhedronPoints(Pts, fa, p, iMax, k= 0) =
    (k == (iMax - 1) ? (
                        polyhedronAtI(k*fa, Pts, p)
                   ) : (
                        concat(polyhedronAtI(k*fa, Pts, p), polyhedronPoints(Pts, fa, p, iMax, k + 1)))
    );
    
function facesIdAtI(Faces, nbFaces, nbPts, k= 0) =
    ((k == (nbFaces - 1)) ? (
                               [Faces[k] + nbPts*[1, 1, 1, 1]] 
                          ) : (
                               let(n = k + 1)
                               concat([Faces[k] + nbPts*[1, 1, 1, 1]], facesIdAtI(Faces, nbFaces, nbPts, n)))
    );
    
function polyhedronFaces(Faces, nbFaces, nbPts, iMax, k= 0) = 
    ((k == iMax - 1) ? (
                        [facesIdAtI(Faces, nbPts)]
                   ) : (
                        let(n = k + 1)
                        concat([facesIdAtI(Faces, nbPts)], polyhedronFaces(Faces, nbFaces, nbPts, iMax, n)))
    
    );

/* TODO     ATTENTION TOUTES LES FACES DES POLYHEDRONS SONT A REVOIR,
   TODO         1. Regrouper les points en faces et non en triangles
   TODO         2. Orienter les face afin que la différence se fasse comme il faut (cf polyhedron dans squareHole() <Holes.scad>)
*/
// Todo ajouter une variable de jeu à chaque fonctions (<=> translatX(jeu) pour les taraudages, et tanslat(-jeu) pour les filetages)
    // ISO triangular

function getISOTriangularDim(D, p) = [p*sqrt(3)/2,             // H:  Hauteur théorique du filet
                                      p*15*sqrt(3)/32,         // H1: Hauteur réele du filet
                                      p*3*sqrt(3)/8,           // H2: Hauteur de filet en contact
                                      D - p*15*sqrt(3)/16,     // D1:  Diamètre du noyau de la vis
                                      D + p*sqrt(3)/16,        // D2 Diamètre à fond de filet de l'écrou
                                      D - p*3*sqrt(3)/4,       // D3: Diamètre intérieur de l'écrou
                                      p*sqrt(3)/32];           // r: Rayon de l'arrondi

    // Thread

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
module ISOTriangularThreadmod(D= 1, p= 0.1, h= 1, fa= 1){

    assertion((fa >= 0.01) && (fa < 180), "fa must be within the following interval : [0.01, 180[");
    assertion((p > 0) && (p <= h), "p must be within the following interval : ]0, h]");

    d = getISOTriangularDim(D, p);
    nbTurns = h/p;
    iMax = nbTurns*(360/fa);

    sides = [[0, 1, 7, 6],  [1, 2, 8, 7],   [2, 3, 9, 8],  // Side
            [3, 4, 10, 9], [4, 5, 11, 10], [0, 6, 11, 5]];
    
    basePts = [[D/2,                    0,  -d[6] + p/2],
               [D/2,                    0,  d[6] + p/2],
               [-d[6] + d[3]/2,         0,  p],
               [-d[6] - 0.01 + d[3]/2,  0,  p],
               [-d[6] - 0.01 + d[3]/2,  0,  0],
               [-d[6] + d[3]/2,         0,  0]];
    
    union(){
        
        polyhedron(points= polyhedronAtI(ang= 0, Pts= basePts, p = p), faces= [[0, 5, 2, 1], [5, 4, 3, 2]]);
        
        for(i= [0 : iMax - 1]){
           
            pts = concat(polyhedronAtI(ang= i*fa, Pts= basePts, p= p), polyhedronAtI(ang= (i + 1)*fa, Pts= basePts, p= p));
            
            polyhedron(points= pts, faces= sides);
        }
        
        
        polyhedron(points= polyhedronAtI(ang= iMax*fa, Pts= basePts, p = p), faces= [[0, 1, 2, 5], [2, 3, 4, 5]]);

        mTranslate([0, 0, (h + p)/2])
            cylinder(r= -d[6] + d[3]/2, h= h+p, $fn= 360/fa, center= true);
    }
    
}

module ISOTriangularThread(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], center= true){

   
    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
            ISOTriangularThreadmod(D, p, h,fa);
}

//ISOTriangularThread();

    // Threadtap

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
module ISOTriangularThreadTapmod(D= 1, p= 0.1, h= 1, fa= 1){

    assertion((fa >= 0.01) && (fa < 180), "fa must be within the following interval : [0.01, 180[");
    assertion((p > 0) && (p <= h), "p must be within the following interval : ]0, h]");

    d = getISOTriangularDim(D, p);
    nbTurns = h/p;
    iMax = nbTurns*(360/fa);

    sides = [[0, 6, 7, 1],  [1, 7, 8, 2],  // Side
            [2, 8, 9, 3],  [3, 9, 10, 4],   
            [5, 11, 10, 4], [0, 6, 11, 5]];

    basePts = [[d[5]/2,                0,  -d[6] + p/2],
               [d[5]/2,                0,  d[6] + p/2],
               [d[6] + d[4]/2,         0,  p],
               [d[6] + 0.01 + d[4]/2,  0,  p],
               [d[6] + 0.01 + d[4]/2,  0,  0],
               [d[6] + d[4]/2,         0,  0]];

    union(){
        
        polyhedron(points= polyhedronAtI(0, basePts, p), faces= [[0, 1, 2, 5], [2, 3, 4, 5]]);

        for(i= [0 : iMax-1]){


            pts = concat(polyhedronAtI(i*fa, basePts, p), polyhedronAtI((i + 1)*fa, basePts, p));

            polyhedron(points= pts, faces= sides);
        }
                
        polyhedron(points= polyhedronAtI(iMax, basePts, p), faces= [[0, 5, 2, 1], [5, 4, 3, 2]]);
    }

}

module ISOTriangularThreadTap(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], center= true){

   
    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
            ISOTriangularThreadTapmod(D, p, h,fa);
           
}

//ISOTriangularThreadTap();

//ISOTriangularThreadTap();
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
module trapezoidalThreadmod(D= 1, p= 0.1, h= 1, fa= 1){

    assertion((fa >= 0.01) && (fa < 180), "fa must be within the following interval : [0.01, 180[");
    assertion((p > 0) && (p <= h), "p must be within the following interval : ]0, h]");

    a = getTrapezoidalThreadGap(p);
    d = getTrapezoidalDim(D, p, a);
    nbTurns = h/p;
    iMax = nbTurns*(360/fa);

    path = [[0, 1, 7],  [1, 2, 7],   [3, 4, 6],    [4, 5, 6],       // Face 1

            [0, 1, 9],  [0, 8, 9],   [1, 2, 10],   [1, 9, 10],      // Side
            [2, 3, 11], [2, 10, 11], [3, 4, 12],   [3, 11, 12],
            [4, 5, 13], [4, 12, 13], [5, 6, 14],   [5, 13, 14],
            [6, 7, 15], [6, 14, 15], [0, 7, 8],    [7, 8, 15],

            [8, 9, 15], [9, 10, 15], [11, 12, 14], [12, 13, 14]];   // Face 2

    basePts = [[D/2,            0,  (p - d[2])/2],
               [D/2,            0,  (p + d[2])/2],
               [d[1]/2,         0,  (p + d[3])/2],
               [d[1]/2,         0,  p],
               [-0.01 + d[1]/2, 0,  p],
               [-0.01 + d[1]/2, 0,  0],
               [d[1]/2,         0,  0],
               [d[1]/2,         0,  (p - d[3])/2]];

    union(){

        for(i= [0 : iMax-1]){


            pts = concat(polyhedronAtI(ang= i*fa, Pts= basePts, p= p, k= 0), polyhedronAtI(ang= (i + 1)*fa, Pts= basePts, p= p, k= 0));

            polyhedron(points= pts, faces= path);
        }

        mTranslate([0, 0, (h + p)/2])
            cylinder(r= d[1]/2, h= h+p, $fn= 360/fa, center= true);
    }

}

module trapezoidalThread(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], center= true){

   
    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
            trapezoidalThreadmod(D, p, h,fa);
           
}


//trapezoidalThread();

//trapezoidalThread(D= 3, p= 0.2, h= 4);

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
module trapezoidalThreadTapmod(D= 1, p= 0.1, h= 1, fa= 1){

    assertion((fa >= 0.01) && (fa < 180), "fa must be within the following interval : [0.01, 180[");
    assertion((p > 0) && (p <= h), "p must be within the following interval : ]0, h]");

    a = getTrapezoidalThreadGap(p);
    d = getTrapezoidalDim(D, p, a);
    nbTurns = h/p;
    iMax = nbTurns*(360/fa);

    path = [[0, 1, 2, 7],   [3, 4, 5, 6],       // Face 1

            [0, 1, 9, 8],   [1, 2, 10, 9],      // Side
            [2, 3, 11, 10], [3, 4, 12, 11],
            [4, 5, 13, 12], [5, 6, 14, 13],
            [6, 7, 15, 14], [7, 0, 8, 15],
    
//            [3, 11, 14, 6],

            [8, 9, 10, 15], [11, 12, 13, 14]];   // Face 2

    basePts = [[(D - p)/2,            0,  (p - d[2])/2],
               [(D - p)/2,            0,  (p + d[2])/2],
               [a + D/2,         0,  (p + d[3])/2],
               [a + D/2,         0,  p],
               [0.01 + a + D/2, 0,  p],
               [0.01 + a + D/2, 0,  0],
               [a + D/2,         0,  0],
               [a + D/2,         0,  (p - d[3])/2]];

    union(){

        for(i= [0 : iMax - 1]){


            pts = concat(polyhedronAtI(ang= i*fa, Pts= basePts, p= p, k= 0), polyhedronAtI(ang= (i + 1)*fa, Pts= basePts, p= p, k= 0));

            polyhedron(points= pts, faces= path);
        }
    }

}

module trapezoidalThreadTap(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], center= false){

   
    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
            trapezoidalThreadTapmod(D, p, h,fa);
           
}
/*
union(){
    
    difference(){
        
        cylinder(r= 4, h= 2.5, $fn= 360, center= true);

        cylinder(r= 2.5 + getTrapezoidalThreadGap(0.5), h= 2.6, $fn= 360, center= true);
        
    }
    
    trapezoidalThreadTap(D= 5, p= 0.5, h= 2, center= true);
}*/