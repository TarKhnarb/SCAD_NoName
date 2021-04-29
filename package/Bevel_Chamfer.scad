include<Constants.scad>
use<Basics.scad>
use<Transforms.scad>
use<Vector.scad>

module bevelMod(r, length, fn, orient){

    rotZ(orient)
        difference(){

            mTranslate([-0.1 + r/2, -0.1 + r/2, 0])
                cube([r + 0.1, r + 0.1, length], center= true);

            mTranslate([r, r, 0])
                cylinder(r= r, h= length + 0.02, $fn= 4*fn, center= true);
        }
}

/*
* bevel(r: radius of the bevel,
*       length: length of the bevel,
*       fn: number of segment for the arc circle,
*       pos: final position of the bevel,
*       rot: use sum of constants ROT_* to orient the bevel OR custom rotation vector as
*            [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*       orient: use constant or sum of constant ORIENT_* to orient the bevel,
*       center: if true center the bevel)
*/
module bevel(r= 1, length= 1, fn= 20, pos= [0, 0, 0], rot= ROT_Top, orient= ORIENT_1, center= false){

    assertion(0 < r, "r should be greater than 0");
    assertion(0 < length, "length should be greater than 0");
    assertion(0 < fn, "fn should be greater than 0");
    assertion((len(pos) == 3), "You should given pos as a 3D vector according [X, Y, Z]");
    assertion((len(rot) == 3), "You should given rot as a 3D vector according [X, Y, Z]");
    assertion(len(orient) == 1, "You should given a ORIENT_* constant");

    mTranslate(pos)
        mTranslate((center ? [0, 0, 0] : getTranslateRot(rot)*length/2))
            mRotate(rot)
                bevelMod(r, length, fn, orient[0]);
}

//bevel(rot= ROT_Rgt, orient= ORIENT_2, r= 5, length= 10);

module cylindricalBevelMod(r, R, fn, fnB){

    difference(){

        cylinder(r= R + r, h= r + 0.1, $fn= fn);

        mTranslate([0, 0, -0.05])
            cylinder(r= R - 0.05, h= r + 0.2, $fn= fn);

        mTranslate([0, 0, r + 0.1])
            rotate_extrude($fn= fn)
                mTranslate([R + r, 0, 0])
                    circle(r= r, $fn= 4*fnB);
    }
}

/*
* cylindricalbevel(r: radius of the bevel,
*                  R: radius of the axel to set the bevel
*                  fn: number of segment for the arc circle,
*                  fnB: number of segment for the bevel,
*                  pos: final position of the bevel,
*                  rot: use sum of constants ROT_* to orient the bevel OR custom rotation vector as
*                       [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*                  center: if true center the bevel)
*/
module cylindricalBevel(r= 1, R= 1, fn= 20, fnB= 20, pos= [0, 0, 0], rot= ROT_Top, center= false){

    assertion(0 < r, "r should be greater than 0");
    assertion(0 < R, "R should be greater than 0");
    assertion(0 < fn, "fn should be greater than 0");
    assertion((len(pos) == 3), "You should given pos as a 3D vector according [X, Y, Z]");
    assertion((len(rot) == 3), "You should given rot as a 3D vector according [X, Y, Z]");

    mTranslate(pos)
        mTranslate((center ? -getTranslateRot(rot)*(r + 0.1)/2 : [0, 0, 0]))
            mRotate(rot)
                cylindricalBevelMod(r, R, fn, fnB);
}

cylindricalBevel(r= 0.2, R= 2, fn= 100, rot= ROT_Bot);

module chamferMod(chamfer, length, ang,  orient){

    y = chamfer*tan(ang);
    pts = [[-0.1, y, 0], [0, y, 0], [chamfer, 0, 0], [chamfer, -0.1, 0], [-0.1, -0.1, 0],
           [-0.1, y, length], [0, y, length], [chamfer, 0, length], [chamfer, -0.1, length], [-0.1, -0.1, length]];

    faces = [[0, 1, 2, 3], [0, 2, 3, 4],
             [5, 6, 1, 0], [6, 7, 2, 1], [7, 8, 3, 2], [8, 9, 4, 3], [9, 5, 0, 4],
             [8, 7, 6, 5], [9, 8, 7, 5]];

    rotZ(orient)
        polyhedron(points= pts, faces= faces);
}

/*
* chamfer(chamfer: width of the chamfer,
*         length: length of the chamfer,
*         chamferAng: angle of the chamfer,it should be within [20,
*         pos: final position of the chamfer,
*         rot: use sum of constants ROT_* to orient the chamfer OR custom rotation vector as
*              [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*         orient: use constant or sum of constant ORIENT_* to orient the chamfer,
*         center: if true center the chamfer)
*/
module chamfer(chamfer= 1, length= 1, chamferAng= 45, pos= [0, 0, 0], rot= ROT_Top, orient= ORIENT_1, center= false){

    assertion(0 < chamfer, "chamfer should be greater than 0");
    assertion(0 < length, "chamfer should be greater than 0");
    assertion((19 < chamferAng) && (chamferAng < 61), "chamferAng should be within [20, 60]°");
    assertion((len(pos) == 3), "You should given pos as a 3D vector according [X, Y, Z]");
    assertion((len(rot) == 3), "You should given rot as a 3D vector according [X, Y, Z]");
    assertion(len(orient) == 1, "You should given a ORIENT_* constant");

    mTranslate(pos)
        mTranslate((center ? [0, 0, -length/2] : [0, 0, 0]))
            mRotate(rot)
                chamferMod(chamfer, length, chamferAng, orient[0]);
}

//chamfer(chamfer= 4, chamferAng= 25, rot= ROT_Lft, orient= ORIENT_3);

module cylindricalChamferMod(chamfer, chamferAng, R, fn){
    
    b = chamfer/tan(chamferAng);
    fa= 360/fn;
        
    difference(){

        union(){
            
            cylinder(r1= R + b, r2= R, h= chamfer, $fn= fn);

            mTranslate([0, 0, -0.1])
                cylinder(r= R + b, h= 0.1, $fn= fn);
        }   
    
        mTranslate([0, 0, -0.15])
            cylinder(r= R - 0.1, h= chamfer + 0.2, $fn= fnB);
    }
}

/*
* cylindricalchamfer(chamfer: width of the chamfer,
*                    chamferAng: angle of the chamfer,it should be within [20,
*                    pos: final position of the chamfer,
*                    rot: use sum of constants ROT_* to orient the chamfer OR custom rotation vector as
*                         [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*                    orient: use constant or sum of constant ORIENT_* to orient the chamfer,
*                    center: if true center the chamfer)
*/
module cylindricalChamfer(chamfer= 1, chamferAng= 45, R= 1, fn= 20, pos= [0, 0, 0], rot= ROT_Top, center= false){
    
    assertion(0 < chamfer, "chamfer should be greater than 0");
    assertion((19 < chamferAng) && (chamferAng < 61), "chamferAng should be within [20, 60]°");
    assertion((len(pos) == 3), "You should given pos as a 3D vector according [X, Y, Z]");
    assertion((len(rot) == 3), "You should given rot as a 3D vector according [X, Y, Z]");

    mTranslate(pos)
        mTranslate((center ? [0, 0, -length/2] : [0, 0, 0]))
            mRotate(rot)
                cylindricalChamferMod(chamfer, chamferAng, R, fn);
}

//cylindricalChamfer(chamferAng= 60, fn= 50);