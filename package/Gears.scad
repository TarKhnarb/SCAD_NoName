use<Transforms.scad>
use<Basics.scad>
include<Constants.scad>

module rackTooth(m= 1, toothNb= 1, width= 1, ang= 20, pos= [0, 0, 0], rot= ROT_Top, center= true){

    assertion(0 < m, "m should be greater than 0");
    assertion(1 <= toothNb, "toothNb should be greater than or equal to 1");
    assertion(0 < width, "width should be greater than 0");
    assertion((0 < ang) && (ang <= 90), "ang should bewithin ]0, 90]°");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");

    x = m*tan(ang);
    y = m*PI;
    pts = [[0,      0,      -0.1], [0, 0,     1.25*m], [x,       0,     2.25*m], [-x + y/2,    0,     2.25*m],   [x + y/2,   0,     0],
           [y - x,  0,      0],    [y, 0,     1.25*m], [y + 0.1, 0,     1.25*m], [y + 0.1,     0,     -0.1],     [y,         0,     -0.1],
           [0,      width,  -0.1], [0, width, 1.25*m], [x,       width, 2.25*m], [-x + y/2,    width, 2.25*m],   [x + y/2,   width, 0],
           [y - x,  width,  0],    [y, width, 1.25*m], [y + 0.1, width, 1.25*m], [y + 0.1,     width, -0.1],     [y,         width, -0.1]];

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

//rackTooth(m= 5, toothNb= 2);

function getGearDim(m, Z) = [m*PI,              // Pas
                             m*Z,               // Diamètre primitif
                             m*(Z + 2),         // Diamètre de tête
                             m*(Z - 2.5)];      // Diamètre depied

module gearMod(m, Z, width, ang, fn){

    d = getGearDim(m, Z);
    fa = 360/fn;

    delta = -d[1]*fa*PI/360;

    difference(){

        cylinder(d= d[2], h= width, $fn= 50, center= true);

        union(){

            for(i= [0 : fn - 1]){

                rotZ(i*fa)
                    mTranslate([0, i*delta, 0])
                        rackTooth(m= m, toothNb= Z+2, width= width + 0.02, ang= ang, pos= [1.25*m + d[1]/2, -2*m*PI, width/2 + 0.01], rot= ROT_Lft + ROT_Back, center= false);
            }
        }
    }
}

module gear(m= 1, Z= 13, width= 1, ang= 20, fn= 10, pos= [0, 0, 0], rot= ROT_Top){

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
fn= 100;
difference(){
    
    gear(m= 0.7, Z= 13, width= 5, fn= fn);
    
    cylinder(r= 2, h= 5.2, $fn= fn, center= true);
}
(*/