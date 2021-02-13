use<Transforms.scad>
use<Basics.scad>
use<Matrix.scad>

                                   
function stepper(P, ang, p) = [P.x * cos(ang) - P.y * sin(ang),
                               P.x * sin(ang) + P.y * cos(ang),
                               P.z + ang*p/360];

function getISOTriangularDim(D, p) = [p*sqrt(3)/2,             // H:  Hauteur théorique du filet
                                      p*15*sqrt(3)/32,         // H1: Hauteur réele du filet
                                      p*3*sqrt(3)/8,           // H2: Hauteur de filet en contact
                                      D - p*15*sqrt(3)/16,     // D1:  Diamètre du noyau de la vis
                                      D + p*sqrt(3)/16,        // D2 Diamètre à fond de filet de l'écrou
                                      D - p*3*sqrt(3)/4,       // D3: Diamètre intérieur de l'écrou
                                      p*sqrt(3)/32];           // r: Rayon de l'arrondi

function ISOTriangBaseAtI(ang, Pts, p, k= 0) =
    (k == (len(Pts) - 1) ? (
                            [stepper(Pts[k], ang, p)]
                       ) : (
                            concat([stepper(Pts[k], ang, p)], ISOTriangBaseAtI(ang, Pts, p, k + 1)))
    );
                          

module ISOTriangularThreadmod(D= 1, p= 0.1, h= 1, fa= 1){

    assertion((fa >= 0.01) && (fa < 180), "fa must be within the following interval : [0.01, 180[");
    assertion((p > 0) && (p <= h), "fa must be within the following interval : ]0, h]");

    d = getISOTriangularDim(D, p);
    nbTurns = h/p;
    iMax = nbTurns*(360/fa);

    path = [[0, 1, 5],  [1, 2, 3],   [3, 4, 5],   [1, 3, 5], // Face 1

            [0, 1, 7],  [0, 6, 7],   [1, 2, 8],   [1, 7, 8],  // Side
            [2, 3, 9],  [2, 8, 9],   [3, 4, 10],  [3, 9, 10],
            [4, 5, 11], [4, 10, 11], [0, 5, 11],  [0, 6, 11],
    
            [6, 7, 11], [7, 8, 9],   [9, 10, 11], [7, 9, 11]]; // Face 2
    
    basePts = [[D/2,                    0,  -d[6] + p/2],
               [D/2,                    0,  d[6] + p/2],
               [-d[6] + d[3]/2,         0,  p],
               [-d[6] - 0.01 + d[3]/2,  0,  p],
               [-d[6] - 0.01 + d[3]/2,  0,  0],
               [-d[6] + d[3]/2,         0,  0]];
    
    union(){
        
        for(i= [0 : iMax-1]){
        
           
            pts = concat(ISOTriangBaseAtI(ang= i*fa, Pts= basePts, p= p, k= 0), ISOTriangBaseAtI(ang= (i + 1)*fa, Pts= basePts, p= p, k= 0));
            
            polyhedron(points= pts, faces= path);
        }
    }
    
}

module ISOTriangularThread(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], center= true){

   
    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
            ISOTriangularThreadmod(D, p, h,fa);
           
}

module ISOTriangularThreadTapmod(D= 1, p= 0.1, h= 1, fa= 1){

    assertion((fa >= 0.01) && (fa < 180), "fa must be within the following interval : [0.01, 180[");
    assertion((p > 0) && (p <= h), "fa must be within the following interval : ]0, h]");

    d = getISOTriangularDim(D, p);
    nbTurns = h/p;
    iMax = nbTurns*(360/fa);

    path = [[0, 1, 5],  [1, 2, 3],   [3, 4, 5],   [1, 3, 5], // Face 1

            [0, 1, 7],  [0, 6, 7],   [1, 2, 8],   [1, 7, 8],  // Side
            [2, 3, 9],  [2, 8, 9],   [3, 4, 10],  [3, 9, 10],
            [4, 5, 11], [4, 10, 11], [0, 5, 11],  [0, 6, 11],

            [6, 7, 11], [7, 8, 9],   [9, 10, 11], [7, 9, 11]]; // Face 2

    basePts = [[d[5]/2,                0,  -d[6] + p/2],
               [d[5]/2,                0,  d[6] + p/2],
               [d[6] + d[4]/2,         0,  p],
               [d[6] + 0.01 + d[4]/2,  0,  p],
               [d[6] + 0.01 + d[4]/2,  0,  0],
               [d[6] + d[4]/2,         0,  0]];

    union(){

        for(i= [0 : iMax-1]){


            pts = concat(ISOTriangBaseAtI(ang= i*fa, Pts= basePts, p= p, k= 0), ISOTriangBaseAtI(ang= (i + 1)*fa, Pts= basePts, p= p, k= 0));

            polyhedron(points= pts, faces= path);
        }
    }

}


module ISOTriangularThreadTap(D= 1, p= 0.1, h= 1, fa= 1, pos= [0, 0, 0], center= true){

   
    mTranslate((center ? [pos.x, pos.y, pos.z - (h + p)/2] : pos))
            ISOTriangularThreadTapmod(D, p, h,fa);
           
}

ISOTriangularThreadTap(D= 5, p= 0.5, h= 2);