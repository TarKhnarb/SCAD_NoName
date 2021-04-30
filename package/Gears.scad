use<Transforms.scad>
use<Basics.scad>
use<Bezier.scad>
use<Vector.scad>
include<Constants.scad>

module rackTooth(m= 1, toothNb= 1, width= 1, ang= 20, pos= [0, 0, 0], rot= ROT_Top, center= true){

    assertion(0 < m, "m should be greater than 0");
    assertion(1 <= toothNb, "toothNb should be greater than or equal to 1");
    assertion(0 < width, "width should be greater than 0");
    assertion((0 < ang) && (ang <= 90), "ang should bewithin ]0, 90]°");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");

    x = m*tan(ang);
    x_ = 1.25*m*tan(ang);
    y = m*PI;
    pts = [[0,      0,      -0.1], [0, 0,     1.25*m], [x,       0,     2.25*m], [-x + y/2,    0,     2.25*m],   [x_ + y/2,   0,     0],
           [y - x_,  0,      0],    [y, 0,     1.25*m], [y + 0.1, 0,     1.25*m], [y + 0.1,     0,     -0.1],     [y,         0,     -0.1],
           [0,      width,  -0.1], [0, width, 1.25*m], [x,       width, 2.25*m], [-x + y/2,    width, 2.25*m],   [x_ + y/2,   width, 0],
           [y - x_,  width,  0],    [y, width, 1.25*m], [y + 0.1, width, 1.25*m], [y + 0.1,     width, -0.1],     [y,         width, -0.1]];

    faces = [[0,  1,  4,  9],  [1,  2,  3,  4],  [4,  5,  8,  9],  [5,  6,  7,  8],
             [1,  0,  10, 11], [2,  1,  11, 12], [3,  2,  12, 13], [4,  3,  13, 14], [5, 4,  14, 15],
             [6,  5,  15, 16], [7,  6,  16, 17], [8,  7,  17, 18], [9,  8,  10, 0],  [8, 18, 19, 10],
             [19, 14, 11, 10], [14, 13, 12, 11], [19, 18, 15, 14], [18, 17, 16, 15]];

    mTranslate(pos)
        mRotate(rot)
            mTranslate((center ? [-toothNb*y/2, -width/2, 0] : [0, 0, 0]))
                union(){

                    for (i = [0 : toothNb - 1]) {

                        mTranslate(i*[y, 0, 0])
                            polyhedron(pts, faces);
                    }
                }
}

//rackTooth(m= 5, toothNb= 2, center= false);

function getGearDim(m, Z) = [m*PI,              // Pas
                             m*Z,               // Diamètre primitif
                             m*(Z + 2),         // Diamètre de tête
                             m*(Z - 2.5)];      // Diamètre depied

module gearMod(m, Z, width, ang, fn){

    d = getGearDim(m, Z);
    fa = 360/fn;

    delta = -d[1]*fa*PI/360;

    difference(){

        cylinder(d= d[2], h= width, $fn= fn, center= true);

        union(){

            for(i= [0 : fn - 1]){

                rotZ(i*fa)
                    mTranslate([0, i*delta, 0])
                        rackTooth(m= m, toothNb= Z + 2, width= width + 0.02, ang= ang, pos= [1.25*m + d[1]/2, -2*m*PI, width/2 + 0.01], rot= ROT_Lft + ROT_Back, center= false);
            }
        }
    }
}

module gear(m= 1, Z= 13, width= 1, ang= 20, fn= 50, pos= [0, 0, 0], rot= ROT_Top){

    assertion(0 < m, "m shoul be greater than 0");
    assertion(1 < Z, "Z shoul be greater than 1");
    assertion(0 < width, "width shoul be greater than 0");
    assertion((0 < ang) && (ang < 90), "width shoul be within ]0, 90[°");
    assertion(0 < fn, "fn shoul be greater than 0");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");

    mTranslate(pos)
        mRotate(rot)
            gearMod(m, Z, width, ang, fn);
}

/*
fn= 50;
m= 20;
Z= 25;
intersection(){
    
    mTranslate([m*(Z+7)/2, m*(Z+3)/2, 0])
        cube(m*(Z-4), center= true);
    
    difference(){
        
        gear(m= m, Z= Z, width= 5, fn= fn);
        
        cylinder(r= 2, h= 5.2, $fn= fn, center= true);
    }

}
*/

// Ne fonctionne pas
module helicoidalGearTooth(m= 1, toothNb= 1, width= 1, ang= 20, beta= 20, pos= [0, 0, 0], rot= ROT_Top){

    assertion(0 < m, "m should be greater than 0");
    assertion(1 <= toothNb, "toothNb should be greater than or equal to 1");
    assertion(0 < width, "width should be greater than 0");
    assertion((0 < ang) && (ang <= 90), "ang should bewithin ]0, 90]°");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");

    a = m*(PI/2 - 2*tan(ang));
    b = m*(PI + 5*tan(ang))/2;
    c = m*PI - b;
    
    height = width/cos(beta) + 0.02;
    
    pts = [[-m, -a/2, -height/2], [-m, a/2, -height/2], [1.25*m, b/2, -height/2], [1.25*m, b/2 + c, -height/2],
           [1.25*m + 0.1, b/2 + c, -height/2], [1.25*m + 0.1, -b/2 - c, -height/2], [1.25*m, -b/2 - c, -height/2], [1.25*m, -b/2, -height/2],
           [-m, -a/2, height/2], [-m, a/2, height/2], [1.25*m, b/2, height/2], [1.25*m, b/2 + c, height/2],
           [1.25*m + 0.1, b/2 + c, height/2], [1.25*m + 0.1, -b/2 - c, height/2], [1.25*m, -b/2 - c, height/2], [1.25*m, -b/2, height/2]];

    faces = [[0, 1, 2, 7], [2, 5, 6, 7], [2, 3, 4, 5],
             [1, 0, 8, 9], [2, 1, 9, 10], [3, 2, 10, 11], [4, 3, 11, 12],
             [5, 4, 12, 13], [6, 5, 13, 14], [7, 6, 14, 15], [0, 7, 15, 8],
             [15, 10, 9, 8], [15, 14, 13, 10], [13, 12, 11, 10]];

    mTranslate(pos)
        mRotate(rot)
            rotX(beta)
                union(){

                    for(i= [0 : toothNb - 1]){

                        mTranslate(i*[0, m*PI, 0])
                            polyhedron(pts, faces);
                    }
                }
}

//helicoidalGearTooth(toothNb= 5);

module helicoidalGearMod(m, Z, width, ang, beta, fn, pitch){
    
     
    d = getGearDim(m, Z);
    fa = 360/fn;
    rotAng = 360/Z;
    delta = -d[1]*pitch[0]*cos(beta)*fa*PI/360;
    delta_ = -d[1]*pitch[0]*sin(beta)*fa*PI/360;
    
    pos= [0, 0, 0];
    
    difference(){
        
        cylinder(d= d[2], h= width, $fn= fn, center= true);
        
        #union(){
            
            for(i= [0 : fn]){
                
                rotZ(i*fa)
                    mTranslate([0, i*delta, i*delta_])
                        helicoidalGearTooth(m= m, toothNb= Z, width= 3*width, ang= ang, beta= pitch[0]*beta, pos= [d[1]/2, 0, 0]);
            }
        }
    }
}

module helicoidalGear(m= 1, Z= 13, width= 1, ang= 20, beta= 20, fn= 50, pitch= LEFT_HAND, pos= [0, 0, 0], rot= ROT_Top){
    
    d = getGearDim(m, Z);
    
    helicoidalGearMod(m, Z, width, ang, beta, fn, pitch);
}

//helicoidalGear(m= 10, Z= 13, width= 10, ang= 20, beta= 30, fn= 50);


//___________________________ Test autre méthode de construction


function involute(r, t) = [r*(cos(t*180/PI) + t*sin(t*180/PI)),
                           r*(sin(t*180/PI) - t*cos(t*180/PI)),
                           0];

function toothPts(r, t, n, k= 0) =
    (k < n ? (concat([involute(r, k*t)], toothPts(r, t, n, k + 1))
         ) : (
              [involute(r, k*t)])
    );

module tooth(m, Z, d, ang, width, t, rot, pts, pts2, pos1, pos2, r, R, A, C, fn, helicoidal){
    
    for(i= [0 : len(pts) - 2]){
           
        hull(){
            rotZ(-ang/4)
                mTranslate(pts[i] + [0, 0.005, 0])
                    cylinder(r= 0.01, h= width, $fn= fn, center= true);
           
            rotZ(-ang/4)
                mTranslate(pts[i + 1] + [0, 0.005, 0])
                    cylinder(r= 0.01, h= width, $fn= fn, center= true);
            
            rotZ(ang/4)
                mTranslate(pts2[i] - [0, 0.005, 0])
                    cylinder(r= 0.01, h= width, $fn= fn, center= true);
           
            rotZ(ang/4)
                mTranslate(pts2[i + 1] - [0, 0.005, 0])
                    cylinder(r= 0.01, h= width, $fn= fn, center= true);
        }
    }

    color("purple")
        difference(){
            
            mTranslate([pos1.x - r*3/2, -A.y, -width/2])
                cube([r*3/2, 2*A.y , width]);
        
            mTranslate(C)
                cylinder(r= r, h= width + 0.01, $fn= 4*fn, center= true);
                
            mTranslate([C.x, -C.y, C.z])
                cylinder(r= r, h= width + 0.01, $fn= 4*fn, center= true);
        }
}

module gearTooth(m, Z, d, ang, width, fn, helicoidal= false){
    
    t = 1/fn;
    rot = 360/Z;
    
//    pts = toothPts(m*Z*cos(ang)/2, t, fn); // Développante de cercle x+
    pts = toothPts(m*Z/2, t, fn);
    
//    pts2 = toothPts(m*Z*cos(ang)/2, -t, fn); // Développante de cercle x-
    pts2 = toothPts(m*Z/2, -t, fn);
    
    
    pos2 = matVectRotZ(-rot/4)*pts[0] - [0, 0.005, 0];  // Point de départ des développantes de cercle
    pos1 = matVectRotZ(rot/4)*pts2[0] + [0, 0.005, 0];
            
    r = pts[0].x - d[3]/2;  // Rayon de fond de dent
    R = d[3]/2;             // Rayon de pied
    
    l1 = -pos1.x/pos1.y;                                            // Cte 
    l2 = (R*R - 2*r*r + pos1.x*pos1.x + pos1.y*pos1.y)/(2*pos1.y);  // Cte 
    Dx = 4*(R*R*(1 + l1*l1) - l2*l2);                               // Delta_x
    X = (-2*l1*l2 - sqrt(abs(Dx)))/(2 + 2*l1*l1);                   // Coordonnee x de A
    
    A = [X, l1*X +l2, 0];   // Point tangent au cercle de pied
        
    k1 = (A.y - pos1.y)/(pos1.x - A.x);                             // Cte 
    k2 = (pos1.x*pos1.x + pos1.y*pos1.y - R*R)/(2*pos1.x - 2*A.x);  // Cte 
    Dy = (2*(k1*(k2 - A.x) - A.y))*(2*(k1*(k2 - A.x) - A.y)) - 4*(1 + k1*k1)*(k2*(k2 - 2*A.x) - r*r + R*R); // Delta_y
    Y = (-2*(k1*(k2 - A.x) - A.y) + sqrt(abs(Dy)))/(2 + 2*k1*k1);   // Coordonnee y de C
    
    C = [Y*k1 + k2, Y, 0]; // Centre de placement des cylindres
    
    t1 = involute(m*Z*cos(ang)/2, sqrt(m*m*Z*Z*(1 - cos(ang)*cos(ang)))/(m*Z*cos(ang))) - [0, 0.005, 0];
    t2 = angleVectors(matVectRotZ(-2*m*PI)*[m*Z/2, 0, 0], t1); // Angle entre l'intersection de la developpante et du cercle primitif, et l'axe x
    
    
//    color("green") mTranslate(t1 + [0, 0, 0.5]) sphere(0.02, $fn= 30);
//    color("yellow") rotZ(2*m*PI) mTranslate(t1 + [0, 0, 0.5]) sphere(0.02, $fn= 30);
    
    tooth(m, Z, d, rot, width, t, t2, pts, pts2, pos1, pos2, r, R, A, C, fn, helicoidal);
}

module linearGear(m= 1, Z= 13, width= 1, ang= 20, fn= 20){
    
    d = getGearDim(m, Z);
    
    
    color("red") cylinder(d= d[1], h= 0.005, $fn= fn, center= true);
    color("blue") cylinder(d= d[3], h= 0.15, $fn= fn, center= true);

    difference(){
        
        gearTooth(m, Z, d, ang, width, fn);
        
        difference(){
            
            cylinder(d= 2*d[2], h= width + 0.01, $fn= 2*fn, center= true);
            
            cylinder(d= d[2], h= width + 0.01, $fn= 2*fn, center= true);
        }
    }
}
 
//linearGear(fn= 50, width= 0.1);
