use<Basics.scad>
use<Matrix.scad>
use<Vector.scad>
use<Transforms.scad>
include<Constants.scad>

/*
* colorCube(size: size of the cube)
*
* Result:
*   Centered colored cube.
*/
module colorCube(size= 1){

    assertion(0 < size, "size should be greater than 0");
    s = size/2;

    union(){

        color([0, 0, 0])
            cube([s, s, s]);

        color([1, 0, 0])
            mTranslate([-s, 0, 0])
                cube(s);

        color([0, 1, 0])
            mTranslate([0, -s, 0])
                cube(s);

        color([0, 0, 1])
            mTranslate([0, 0, -s])
                cube(s);

        color([1, 1, 0])
            mTranslate([-s, -s, 0])
                cube(s);

        color([1, 0, 1])
            mTranslate([-s, 0, -s])
                cube(s);

        color([0, 1, 1])
            mTranslate([0, -s, -s])
                cube(s);

        color([1, 1, 1])
            mTranslate([-s, -s, -s])
                cube(s);
    }
}

/*
writeOnFace(pos= [0, 0, 5], text= "Top", color= "grey", size= 3, valign= "center", halign= "center")
writeOnFace(pos= [0, 5, 0], text= "Back", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Back + [0, 0, 180])
writeOnFace(pos= [0, -5, 0], text= "Front", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Frt)
writeOnFace(pos= [5, 0, 0], text= "Right", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Rgt + [0, 0, 90])
writeOnFace(pos= [-5, 0, 0], text= "Left", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Lft + [0, 0, -90])
writeOnFace(pos= [0, 0, -5], text= "Bottom", color= "grey", size= 2, valign= "center", halign= "center", rot= ROT_Bot)
    colorCube(10);
*/

    // Chamfers :
module chamferBase(chamfer, size){

    rotZ(45)
       cube([sqrt(2)*chamfer, sqrt(2)*chamfer, size + 0.01], center= true);
}

/*
* chamferCube(chamfer: chamfer size (chamfer < min(size)/2),
*             size: the size of the cube according to [X, Y, Z],
*             pos: position to place the cube,
*             rot: use sum of constants ROT_* for orient the cube OR custom rotation vector as
*                  [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*             edges: vector of the edges to be chamfered,
*             center: boolean, centrer or not the cube)
*/
module chamferCube(chamfer= 0.1, size= [1, 1, 1], pos= [0, 0, 0], rot= ROT_Top, edges= EDGE_All, center= false){

    assertion((0 < chamfer) && (chamfer <= min(size)/2), "chamfer should be greater than 0 and less than half of the smallest size of the cube");
    assertion(len(size) == 3, "size should be a 3D vector");
    for(i= [0 : 2]){

        assertion(0 < size[i], "The size of the cube should be greater than 0");
    }

    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");
    assertion(len(edges) != 0, "You should give a vector containing at least one edge constant");

    mTranslate((center ? pos : pos + size*1/2)){
        mRotate(rot){

            if(edges == EDGE_All){

                difference(){

                    cube(size, center = true);

                    for(r = [0, 1]){

                        union(){

                            transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(90))
                                chamferBase(chamfer, size.y);

                            transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(90))
                                chamferBase(chamfer, size.y);

                            transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(90))
                                chamferBase(chamfer, size.x);

                            transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(90))
                                chamferBase(chamfer, size.x);

                            transform(matRotZ(r*180)*scaleEdge(size.y/2, EDGE_Back)*scaleEdge(size.x/2, EDGE_Lft))
                                chamferBase(chamfer, size.z);

                            transform(matRotZ(r*180)*scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Lft))
                                chamferBase(chamfer, size.z);
                        }
                    }
                }
            }
            else{

                difference(){

                    cube(size, center = true);

                    for(i= [0 : len(edges) - 1]){

                        if((edges[i] == EDGE_Top) || (edges[i] == EDGE_Bot)){

                            for(r = [0, 1]){

                                union(){

                                    transform(matRotZ(r*180)*scaleEdge(size.z/2, edges[i])*scaleEdge(size.x/2, EDGE_Lft)*matRotX(90))
                                        chamferBase(chamfer, size.y);

                                    transform(matRotZ(r*180)*scaleEdge(size.z/2, edges[i])*scaleEdge(size.y/2, EDGE_Frt)*matRotY(90))
                                        chamferBase(chamfer, size.x);
                                }
                            }
                        }
                        else if((edges[i] == EDGE_Back) || (edges[i] == EDGE_Frt)){

                            for(r = [0, 1]){

                                union(){

                                    transform(matRotY(r*180)*scaleEdge(size.y/2, edges[i])*scaleEdge(size.x/2, EDGE_Lft))
                                        chamferBase(chamfer, size.z);

                                    transform(matRotY(r*180)*scaleEdge(size.y/2, edges[i])*scaleEdge(size.z/2, EDGE_Top)*matRotY(90))
                                        chamferBase(chamfer, size.x);
                                }
                            }
                        }
                        else if((edges[i] == EDGE_Rgt) || (edges[i] == EDGE_Lft)){

                            for(r = [0, 1]){

                                union(){

                                    transform(matRotX(r*180)*scaleEdge(size.x/2, edges[i])*scaleEdge(size.y/2, EDGE_Back))
                                        chamferBase(chamfer, size.z);

                                    transform(matRotX(r*180)*scaleEdge(size.x/2, edges[i])*scaleEdge(size.z/2, EDGE_Top)*matRotX(90))
                                        chamferBase(chamfer, size.y);
                                }
                            }
                        }
                        else if((edges[i] == EDGE_TopFrt) || (edges[i] == EDGE_FrtTop)){

                            transform(scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(90))
                                chamferBase(chamfer, size.x);
                        }
                        else if((edges[i] == EDGE_TopBack) || (edges[i] == EDGE_BackTop)){

                            transform(scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.y/2, EDGE_Back)*matRotY(90))
                                chamferBase(chamfer, size.x);
                        }
                        else if((edges[i] == EDGE_BotBack) || (edges[i] == EDGE_BackBot)){

                            transform(scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.y/2, EDGE_Back)*matRotY(90))
                                chamferBase(chamfer, size.x);
                        }
                        else if((edges[i] == EDGE_BotFrt) || (edges[i] == EDGE_FrtBot)){

                            transform(scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(90))
                                chamferBase(chamfer, size.x);
                        }
                        else if((edges[i] == EDGE_TopRgt) || (edges[i] == EDGE_RgtTop)){

                            transform(scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.x/2, EDGE_Rgt)*matRotX(90))
                                chamferBase(chamfer, size.y);
                        }
                        else if((edges[i] == EDGE_TopLft) || (edges[i] == EDGE_LftTop)){

                            transform(scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(90))
                                chamferBase(chamfer, size.y);
                        }
                        else if((edges[i] == EDGE_BotRgt) || (edges[i] == EDGE_RgtBot)){

                            transform(scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.x/2, EDGE_Rgt)*matRotX(90))
                                chamferBase(chamfer, size.y);
                        }
                        else if((edges[i] == EDGE_BotLft) || (edges[i] == EDGE_LftBot)){

                            transform(scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(90))
                                chamferBase(chamfer, size.y);
                        }
                        else if((edges[i] == EDGE_BackRgt) || (edges[i] == EDGE_RgtBack)){

                            transform(scaleEdge(size.y/2, EDGE_Back)*scaleEdge(size.x/2, EDGE_Rgt))
                                chamferBase(chamfer, size.z);
                        }
                        else if((edges[i] == EDGE_BackLft) || (edges[i] == EDGE_LftBack)){

                            transform(scaleEdge(size.y/2, EDGE_Back)*scaleEdge(size.x/2, EDGE_Lft))
                                chamferBase(chamfer, size.z);
                        }
                        else if((edges[i] == EDGE_FrtRgt) || (edges[i] == EDGE_RgtFrt)){

                            transform(scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Rgt))
                                chamferBase(chamfer, size.z);
                        }
                        else if((edges[i] == EDGE_FrtLft) || (edges[i] == EDGE_LftFrt)){

                            transform(scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Lft))
                                chamferBase(chamfer, size.z);
                        }
                    }
                }
            }
        }
    }
}

//chamferCube(size= [1, 2, 2], chamfer= 0.1, edges= [EDGE_Top, EDGE_Bot]);

//chamferCube(chamfer= 0.2);

module chamferAngBase(chamfer, fs, ang= 45){

    L = chamfer/cos(ang) + 0.02;
    l = chamfer*sin(ang) + 0.02;
    gamma = atan(l/L);
    d = sqrt((L*L + l*l)/4);
    
    A = [d*cos(ang - gamma), -d*sin(ang - gamma), 0];  // A'
    
    B = [chamfer + 0.01*cos(ang), -0.01*sin(ang), 0];  // A"

    mTranslate(makeVector(A, B))
        rotZ(-ang)
            cube([L, l, fs + 0.02], center=true);
}

/*
* chamferCylinder(h: height of the cylinder,
*                 r: radius of the cylinder],
*                 chamfer: chamfer size (chamfer < r/2),
*                 chamferAng: chamfer angle [20, 60],
*                 fn: precision of the cylinder,
*                 pos: position to place the cube,
*                 rot: use sum of constants ROT_* for orient the cylinder OR custom rotation vector as
*                      [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*                 edges: vector of the edges to be chamfered ONLY EDGE_Top or EDGE_Bot,
*                 center: boolean, centrer or not the cube)
*/
module chamferCylinder(h= 1, r= 1, chamfer= 0.1, chamferAng= 45, fn= 50, pos= [0, 0, 0], rot= ROT_Top, edges= [EDGE_Top, EDGE_Bot], center= false){

    assertion(0 < h, "h should be greater than 0");
    assertion(0 < r, "r should be greater than 0");
    assertion((0 < chamfer) && (chamfer <= r), "chamfer should be greater than 0 and less than r/2");
    assertion((19 < chamferAng) && (chamferAng < 61), "chamferAng should be within [20, 60]°");
    assertion(1 < fn, "fn should be greater than 1");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");
    assertion(len(edges) != 0, "You should give a vector containing at least one edge constant");

    step = 360/fn;

    mTranslate((center ? pos : pos + [r, r, h/2])){
        mRotate(rot){
            difference(){

                cylinder(r= r, h= h, $fn= fn, center= true);

                for(i= ((len(edges) - 1) == 0 ? [0] : [0 : len(edges) - 1])){
                    
                    if(edges[i] == EDGE_Top){

                        for(j= [0 : fn - 1]){

                            transform(matRotZ((j + 1)*step)*scaleEdge(h/2, EDGE_Top)*scaleEdge(r, EDGE_Rgt)*matRot([90, 0, 180]))
                                chamferAngBase(chamfer, r*tan(step), chamferAng);
                        }
                    }

                    if(edges[i] == EDGE_Bot){

                        for(j= [0 : fn - 1]){

                            transform(matRotZ((j + 1)*step)*scaleEdge(h/2, EDGE_Bot)*scaleEdge(r, EDGE_Rgt)*matRot([90, 180, 0]))
                                chamferAngBase(chamfer, r*tan(step), chamferAng);
                        }
                    }
                }
            }
        }
    }
}

//chamferCylinder(chamferAng= 20,center= true);

//chamferCylinder(r= 2,chamferAng= 20);

//chamferCylinder(h= 3, chamfer= 0.5, edges= [EDGE_Top]);

    // Bevels:

module bevelBase(bevel, size, fn){
    
    mTranslate([bevel/2, bevel/2, 0])
        difference(){
    
            cube([bevel + 0.01, bevel + 0.01, size + 0.01], center= true);
        
            mTranslate([bevel/2, bevel/2, 0])
                cylinder(r= bevel, h= size + 0.02, center= true, $fn= 4*fn);
        }        
}

/*
* bevelCube(size: the size of the cube according to [X, Y, Z],
*           bevel: bevel radius (bevel < min(size)/2),
*           fn: precision of the bevel pitch,
*           pos: position to place the cube,
*           rot: use sum of constants ROT_* for orient the cube OR custom rotation vector as
*                [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*           edges: vector of the edges to be beveled,
*           center: boolean, centrer or not the cube)
*/
module bevelCube(size= [1, 1, 1], bevel= 0.1, fn= 20, pos= [0, 0, 0], rot= ROT_Top, edges= EDGE_All, center= false){

    assertion(len(size) == 3, "size should be a 3D vector");
    for(i= [0 : 2]){

        assertion(0 < size[i], "The size of the cube should be greater than 0");
    }

    assertion((0 < bevel ) && (bevel <= min(size)/2), "bevel should be greater than 0 and less than half of the smallest size of the cube");
    assertion(0 < fn, "fn should be greater than 0");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");
    assertion(len(edges) != 0, "You should give a vector containing at least one edge constant");

    mTranslate((center ? pos : pos + size*1/2)){
        mRotate(rot){
            if(edges == EDGE_All){

                difference(){

                    cube(size, center= true);

                    for(r= [0, 1]){

                        union(){
                            
                                // Top
                            transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(-90))
                                bevelBase(bevel, size.y, fn);
                                    
                            transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(90))
                                bevelBase(bevel, size.x, fn);
                            
                                // Bot
                            transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(-90))
                                bevelBase(bevel, size.x, fn);
                                
                            transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(90))
                                bevelBase(bevel, size.y, fn);
                            
                                // Frt
                            transform(matRotZ(r*180)*scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Rgt)*matRotZ(90))
                                bevelBase(bevel, size.z, fn);

                                // Back
                            transform(matRotZ(r*180)*scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Lft))
                                bevelBase(bevel, size.z, fn);
                        }
                    }
                }
            }
            else{

                difference(){

                    cube(size, center= true);

                    for(i= (((len(edges) - 1) == 0) ? [0] : [0 : len(edges) - 1])){

                        if(edges[i] == EDGE_Top){

                            for(r= [0, 1]){

                                union(){
                                    
                                    transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(-90))
                                        bevelBase(bevel, size.y, fn);
                                    
                                    transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(90))
                                        bevelBase(bevel, size.x, fn);
                                }
                                
                            }
                        }
                        else if(edges[i] == EDGE_Bot){

                            for(r= [0, 1]){

                                union(){
                                    
                                    transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(-90))
                                        bevelBase(bevel, size.x, fn);
                                
                                    transform(matRotZ(r*180)*scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(90))
                                        bevelBase(bevel, size.y, fn);
                                }
                            }
                        }
                        else if(edges[i] == EDGE_Back){

                            for(r= [0, 1]){

                                union(){
                                    
                                    transform(matRotY(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.y/2, EDGE_Back)*matRot([0,90,-90]))
                                        bevelBase(bevel, size.x, fn);
                                    
                                    transform(matRotY(r*180)*scaleEdge(size.y/2, EDGE_Back)*scaleEdge(size.x/2, EDGE_Lft)*matRotZ(-90))
                                        bevelBase(bevel, size.z, fn);
                                }
                            }
                        }
                        else if(edges[i] == EDGE_Frt){

                            for(r= [0, 1]){

                                union(){
                                    
                                    transform(matRotY(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(90))
                                        bevelBase(bevel, size.x, fn);
                                    
                                    transform(matRotY(r*180)*scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Lft))
                                        bevelBase(bevel, size.z, fn);
                                }
                            }
                        }
                        else if(edges[i] == EDGE_Rgt){

                            for(r= [0, 1]){

                                union(){
                                    
                                    transform(matRotX(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.x/2, EDGE_Rgt)*matRot([-90, 0, 90]))
                                        bevelBase(bevel, size.y, fn);
                                    
                                    transform(matRotX(r*180)*scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Rgt)*matRotZ(90))
                                        bevelBase(bevel, size.z, fn);   
                                }
                            }
                        }
                        else if(edges[i] == EDGE_Lft){

                            for(r= [0, 1]){

                                union(){
                                    
                                    transform(matRotX(r*180)*scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(-90))
                                        bevelBase(bevel, size.y, fn);
                                    
                                    transform(matRotX(r*180)*scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Lft))
                                        bevelBase(bevel, size.z, fn);
                                }
                            }
                        }
                        else if((edges[i] == EDGE_TopBack) || (edges[i] == EDGE_BackTop)){
                            
                            transform(scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.y/2, EDGE_Back)*matRot([0,90,-90]))
                                bevelBase(bevel, size.x, fn);
                        }
                        else if((edges[i] == EDGE_TopFrt) || (edges[i] == EDGE_FrtTop)){
                            
                            transform(scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(90))
                                bevelBase(bevel, size.x, fn);
                        }
                        else if((edges[i] == EDGE_BotBack) || (edges[i] == EDGE_BackBot)){

                            transform(scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.y/2, EDGE_Back)*matRot([0, -90, -90]))
                                bevelBase(bevel, size.x, fn);
                        }
                        else if((edges[i] == EDGE_BotFrt) || (edges[i] == EDGE_FrtBot)){

                            transform(scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.y/2, EDGE_Frt)*matRotY(-90))
                                bevelBase(bevel, size.x, fn);
                        }
                        else if((edges[i] == EDGE_TopRgt) || (edges[i] == EDGE_RgtTop)){

                            transform(scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.x/2, EDGE_Rgt)*matRot([-90, 0, 90]))
                                bevelBase(bevel, size.y, fn);
                        }
                        else if((edges[i] == EDGE_TopLft) || (edges[i] == EDGE_LftTop)){

                            transform(scaleEdge(size.z/2, EDGE_Top)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(-90))
                                bevelBase(bevel, size.y, fn);
                        }
                        else if((edges[i] == EDGE_BotRgt) || (edges[i] == EDGE_RgtBot)){

                            transform(scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.x/2, EDGE_Rgt)*matRot([90, 0, 90]))
                                bevelBase(bevel, size.y, fn);
                        }
                        else if((edges[i] == EDGE_BotLft) || (edges[i] == EDGE_LftBot)){

                            transform(scaleEdge(size.z/2, EDGE_Bot)*scaleEdge(size.x/2, EDGE_Lft)*matRotX(90))
                                bevelBase(bevel, size.y, fn);
                        }
                        else if((edges[i] == EDGE_BackRgt) || (edges[i] == EDGE_RgtBack)){

                            transform(scaleEdge(size.y/2, EDGE_Back)*scaleEdge(size.x/2, EDGE_Rgt)*matRotZ(180))
                                bevelBase(bevel, size.z, fn);
                        }                
                        else if((edges[i] == EDGE_BackLft) || (edges[i] == EDGE_LftBack)){

                            transform(scaleEdge(size.y/2, EDGE_Back)*scaleEdge(size.x/2, EDGE_Lft)*matRotZ(-90))
                                bevelBase(bevel, size.z, fn);
                        }                
                        else if((edges[i] == EDGE_FrtRgt) || (edges[i] == EDGE_RgtFrt)){

                            transform(scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Rgt)*matRotZ(90))
                                bevelBase(bevel, size.z, fn);
                        }                
                        else if((edges[i] == EDGE_FrtLft) || (edges[i] == EDGE_LftFrt)){

                            transform(scaleEdge(size.y/2, EDGE_Frt)*scaleEdge(size.x/2, EDGE_Lft))
                                bevelBase(bevel, size.z, fn);
                        }
                    }
                }
            }
        }
    }
}

//bevelCube(size= [1, 1, 2], bevel= 0.4, edges= [EDGE_Top, EDGE_Bot]);

//bevelCube(bevel= 0.2);

module cylindBevelBase(r, bevel, fn){

    mTranslate([0, 0, -bevel])
        difference(){

            mTranslate([0, 0, (bevel + 0.01)/2])
                cylinder(r= r*3/2 + 0.01, h= bevel + 0.01, $fn= fn, center= true);

            union(){

                cylinder(r= r - bevel, h= 2*bevel, $fn= fn, center= true);

                rotate_extrude($fn= fn){

                    mTranslate([r - bevel, 0, 0])
                        circle(r= bevel, $fn= fn);
                }
            }
        }
}

/*
* bevelCylinder(h: height of the cylinder,
*               r: radius of the cylinder,
*               bevel: bevel radius (chamfer < r/2),
*               fn: precision of the cylinder pitch,
*               fnB: precision of the bevel pitch,
*               pos: position to place the cube,
*               rot: use sum of constants ROT_* for orient the cylinder OR custom rotation vector as
*                    [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*               edges: vector of the edges to be chamfered ONLY EDGE_Top or EDGE_Bot,
*               center: boolean, centrer or not the cube)
*/
module bevelCylinder(h= 1, r= 1, bevel= 0.1, fn= 20, fnB= 20, pos= [0, 0, 0], rot= ROT_Top, edges= [EDGE_Top, EDGE_Bot], center= false){

    assertion(0 < h, "h should be greater than 0");
    assertion(0 < r, "r should be greater than 0");
    assertion((0 < bevel) && (bevel <= r/2), "bevel should be greater than 0 and less than r/2");
    assertion(1 < fn, "fn should be greater than 1");
    assertion(1 < fnB, "fnB chamfer should be greater than 1");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");
    assertion(len(edges) != 0, "You should give a vector containing at least one edge constant");

    step = 360/fn;
    length= 2*PI*r/fn;

    mTranslate((center ? pos : pos + [r, r, h/2])){
        mRotate(rot){
            difference(){

                cylinder(r= r, h= h, $fn= fn, center= true);

                for(i= ((len(edges) - 1) == 0 ? [0] : [0 : len(edges) - 1])){
                    
                    if(edges[i] == EDGE_Top){
                        
                        mTranslate([0, 0, h/2])
                            cylindBevelBase(r, bevel, fnB);
                    }

                    if(edges[i] == EDGE_Bot){

                        mTranslate([0, 0, -h/2])
                            rotX(180)
                                cylindBevelBase(r, bevel, fnB);
                    }
                }
            }
        }
    }
}

//bevelCylinder(r= 0.5);

//bevelCylinder(h= 3, bevel= 0.5, edges= [EDGE_Top]);

    // Linear pipe
/*
*
*              |<--------------->| r
*              |    |<---------->| r1
*                   |____________|  _
*              |    /     /<---->|  A
*              |   /     /   r2  |  |
*                 /     /        |  |   h
*              | /pipe /            |
*              |/_____/__________| _V_
*              /     /           |
*             /thick/
*
 */
/*
* linearPipe(r: bottom outer radius of the pipe,
*            thick: thickness of the pipe,
*            r1: if def, top outer radius of the pipe,
*            r2: if def thickness isn't used, top inner radius of the pipe,
*            h: height of the pipe,
*            pos: position to place the cube,
*            fn: precision of the cylinders,
*            rot: use sum of constants ROT_* for orient the pipe OR custom rotation vector as
*                 [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*            center: center the piece at [0, 0, 0])
*
*  Result:
*   A parametrized linear pipe.
*/
module linearPipe(r= 1, thick= 0.1, r1= undef, r2= undef, h= 1, fn= 50, pos=[0, 0, 0], rot= ROT_Top, center= false){

    assertion(0 < r, "r should be greater than 0");
    assertion(0 < thick, "thick should be greater than 0");
    assertion(0 < h, "h should be greater than 0");
    assertion(0 < fn, "fn should be greater than 0");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");

    mTranslate(pos){
        mRotate(rot){
            
            if(isDef(r1)){

                assertion(0 < r1, "r1 should be greater than 0");
                difference(){

                    if(isDef(r2)){

                        assertion(r2 < r1, "r1 should be strictly greater than r2");
                        x = tan(atan((r - (r1 - r2) - r2)/h))*0.01;
                        
                        difference(){
                            
                            cylinder(r1= r, r2= r1, h= h, center= center, $fn= fn);
                            
                            mTranslate((center ? [0, 0, 0] : [0, 0, -0.01]))
                                cylinder(r1= r - (r1 - r2) + x, r2= r2 - x, h= h + 0.02, center= center, $fn= fn);
                        }
                    }
                    else{
                        
                        assertion(thick < r1, "r1 should be strictly greater than thick");
                        x = tan(atan((r - thick - (r1 - thick))/h))*0.01;
                        
                        difference(){
                            
                            cylinder(r1= r, r2= r1, h= h, center= center, $fn= fn);
                            
                            mTranslate((center ? [0, 0, 0] : [0, 0, -0.01]))
                                cylinder(r1= r - thick + x, r2= r1 - thick - x, h= h + 0.02, center= center, $fn= fn);
                        }
                    }
                }
            }
            else{
                
                if(isDef(r2)){
                    
                    assertion(r2 < r, "r should be strictly greater than r2");
                    difference(){
                        
                        cylinder(r= r, h= h, center= center, $fn= fn);

                        mTranslate((center ? [0, 0, 0] : [0, 0, -0.01]))
                            cylinder(r= r2, h= h + 0.02, center= center, $fn= fn);
                    }
                }
                else{
                    
                    assertion(thick < r, "r should be strictly greater than thick");
                    difference(){
                        
                        cylinder(r= r, h= h, center= center, $fn= fn);

                        mTranslate((center ? [0, 0, 0] : [0, 0, -0.01]))
                            cylinder(r= r - thick, h= h + 0.02, center= center, $fn= fn);
                    }
                }
                
            }
        }
    }
}

//linearPipe(r= 2, r1= 1, thick= 0.5, h= 10, center= true, rot= ROT_Lft);

//linearPipe(r= 2, r1= 3, r2= 2.9, h= 4, center= true);

/*
* regularIcosahedron(t: length of an edges,
*                  pos: final positionof the regular isocaedre,
*                  rot: use sum of constants ROT_* for orient the pipe OR custom rotation vector as
*                       [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction)
 */
module regularIcosahedron(t= 1, pos= [0, 0, 0], rot= ROT_Top){

    assertion(0 < t, "t should be greater than 0");
    assertion(len(pos) == 3, "pos should be a 3D vector");
    assertion(len(rot) == 3, "rot should be a 3D vector");

    t = t/2;
    phi = (1 + sqrt(5))/2;

    pts = [[-t*phi, -t, 0], [t*phi, -t, 0], [t*phi, t, 0], [-t*phi, t, 0],
            [0, -t*phi, -t], [0, t*phi, -t], [0, t*phi, t], [0, -t*phi, t],
            [t, 0, -t*phi], [-t, 0, -t*phi], [-t, 0, t*phi], [t, 0, t*phi]];

    face = [[0, 3, 10], [0, 3, 9],
            [1, 2, 8], [1, 2, 11],
            [10, 11, 6], [10, 11, 7],
            [4, 7, 1], [4, 7, 0],
            [5, 6, 2], [5, 6, 3],
            [8, 9, 5], [8, 9, 4],
            [0, 7, 10], [0, 9, 4],
            [3, 6, 10], [3, 9, 5],
            [2, 6, 11], [2, 5, 8],
            [1, 7, 11], [1, 4, 8]];

    mTranslate(pos)
        mRotate(rot)
            polyhedron(points= pts, faces= face);
}

//regularIcosahedron(t= 5);