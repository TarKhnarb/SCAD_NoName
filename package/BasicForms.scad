use<Basics.scad>
use<Matrix.scad>
use<Transforms.scad>
include<Constants.scad>

module colorCube(size= 1){

    s = size/2;

    union(){

        color([0, 0, 0])
            cube([s, s, s]);

        color([1, 0, 0])
            translate([-s, 0, 0])
                cube([s, s, s]);

        color([0, 1, 0])
            translate([0, -s, 0])
                cube([s, s, s]);

        color([0, 0, 1])
            translate([0, 0, -s])
                cube([s, s, s]);

        color([1, 1, 0])
            translate([-s, -s, 0])
                cube([s, s, s]);

        color([1, 0, 1])
            translate([-s, 0, -s])
                cube([s, s, s]);

        color([0, 1, 1])
            translate([0, - s, - s])
                cube([s, s, s]);

        color([1, 1, 1])
            translate([- s, - s, - s])
                cube([s, s, s]);
    }
}

    // Chamfers :

/*
* chamferBase(...)
*
* Only for functions
*
* Result: base for chamfer
*/
module chamferBase(chamfer, size){

    rotZ(45)
       cube([sqrt(2)*chamfer, sqrt(2)*chamfer, size + 0.01], center= true);
}

/*
* chamferCube(size: the size of the cube according to [X, Y, Z]
*             chamfer: chamfer size (chamfer < min(size)/2)
*             edges: vector of the edges to be chamfered)
*
* Result: custom chamfered cube
*/
module chamferCube(size= [1, 1, 1], chamfer= 0.1, edges= EDGE_All){

    assertion(chamfer < min(size)/2, "chamfer must be less than half the smallest size of the cube ");
    assertion(len(edges) != 0, "chamfer must be less than half the smallest size of the cube");
    
    if(edges == EDGE_All){

        difference(){

            cube(size, center= true);
            
            for(r= [0, 1]){

                union(){
                    
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(90))
                        chamferBase(chamfer, size.y);
                          
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(90))
                        chamferBase(chamfer, size.y);  
                    
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.y/2, e=EDGE_Frt)*matRotY(90))
                        chamferBase(chamfer, size.x);
                    
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.y/2, e=EDGE_Frt)*matRotY(90))
                        chamferBase(chamfer, size.x);
                    
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.y/2, e= EDGE_Back)*scaleEdge(k= size.x/2, e= EDGE_Lft))
                        chamferBase(chamfer, size.z);
        
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Lft))
                        chamferBase(chamfer, size.z);
                }
            }
        }
    }
    else{

        difference(){

            cube(size, center= true);

            for(i= [0 : len(edges) - 1]){

                if((edges[i] == EDGE_Top) || (edges[i] == EDGE_Bot)){

                    for(r= [0, 1]){

                        union(){
                            
                            transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= edges[i])*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(90))
                                chamferBase(chamfer, size.y);
                            
                            transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= edges[i])*scaleEdge(k= size.y/2, e= EDGE_Frt)*matRotY(90))
                                chamferBase(chamfer, size.x);
                        }
                    }
                }
                else if((edges[i] == EDGE_Back) || (edges[i] == EDGE_Frt)){

                    for(r= [0, 1]){

                        union(){
                            
                            transform(m= matRotY(r*180)*scaleEdge(k= size.y/2, e= edges[i])*scaleEdge(k= size.x/2, e= EDGE_Lft))
                                chamferBase(chamfer, size.z);
                            
                            transform(m= matRotY(r*180)*scaleEdge(k= size.y/2, e= edges[i])*scaleEdge(k= size.z/2, e= EDGE_Top)*matRotY(90))
                                chamferBase(chamfer, size.x);
                        }
                    }
                }
                else if((edges[i] == EDGE_Rgt) || (edges[i] == EDGE_Lft)){

                    for(r= [0, 1]){

                        union(){
                            
                            transform(m= matRotX(r*180)*scaleEdge(k= size.x/2, e= edges[i])*scaleEdge(k= size.y/2, e= EDGE_Back))
                                chamferBase(chamfer, size.z);
                            
                            transform(m= matRotX(r*180)*scaleEdge(k= size.x/2, e= edges[i])*scaleEdge(k= size.z/2, e= EDGE_Top)*matRotX(90))
                                chamferBase(chamfer, size.y);
                        }
                    }
                }
                else if((edges[i] == EDGE_TopFrt) || (edges[i] == EDGE_FrtTop)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.y/2, e=EDGE_Frt)*matRotY(90))
                        chamferBase(chamfer, size.x);
                }
                else if((edges[i] == EDGE_TopBack) || (edges[i] == EDGE_BackTop)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.y/2, e=EDGE_Back)*matRotY(90))
                        chamferBase(chamfer, size.x);
                } 
                else if((edges[i] == EDGE_BotBack) || (edges[i] == EDGE_BackBot)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.y/2, e=EDGE_Back)*matRotY(90))
                        chamferBase(chamfer, size.x);
                }
                else if((edges[i] == EDGE_BotFrt) || (edges[i] == EDGE_FrtBot)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.y/2, e=EDGE_Frt)*matRotY(90))
                        chamferBase(chamfer, size.x);
                }
                else if((edges[i] == EDGE_TopRgt) || (edges[i] == EDGE_RgtTop)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.x/2, e= EDGE_Rgt)*matRotX(90))
                        chamferBase(chamfer, size.y);
                }
                else if((edges[i] == EDGE_TopLft) || (edges[i] == EDGE_LftTop)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(90))
                        chamferBase(chamfer, size.y);
                }
                else if((edges[i] == EDGE_BotRgt) || (edges[i] == EDGE_RgtBot)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.x/2, e= EDGE_Rgt)*matRotX(90))
                        chamferBase(chamfer, size.y);
                }
                else if((edges[i] == EDGE_BotLft) || (edges[i] == EDGE_LftBot)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(90))
                        chamferBase(chamfer, size.y);
                }
                else if((edges[i] == EDGE_BackRgt) || (edges[i] == EDGE_RgtBack)){

                    transform(m= scaleEdge(k= size.y/2, e= EDGE_Back)*scaleEdge(k= size.x/2, e= EDGE_Rgt))
                        chamferBase(chamfer, size.z);
                }
                else if((edges[i] == EDGE_BackLft) || (edges[i] == EDGE_LftBack)){

                    transform(m= scaleEdge(k= size.y/2, e= EDGE_Back)*scaleEdge(k= size.x/2, e= EDGE_Lft))
                        chamferBase(chamfer, size.z);
                }
                else if((edges[i] == EDGE_FrtRgt) || (edges[i] == EDGE_RgtFrt)){

                    transform(m= scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Rgt))
                        chamferBase(chamfer, size.z);
                }
                else if((edges[i] == EDGE_FrtLft) || (edges[i] == EDGE_LftFrt)){

                    transform(m= scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Lft))
                        chamferBase(chamfer, size.z);
                }
            }
        }
    }
}

/*
* chamferCylinder(h: height of the cylinder
*                 r: radius of the cylinder
*                 chamfer: chamfer size (chamfer < r/2)
*                 edges: vector of the edges to be chamfered ONLY EDGE_Top or EDGE_Bot)
*
* Result: custom chamfered cylinder
*/
module chamferCylinder(h= 1, r= 1, chamfer= 0.1, fn= 100, edges= [EDGE_Top, EDGE_Bot]){

    assertion(chamfer < r/2, "chamfer must be less than half the smallest size of the cube");
    assertion(len(edges) != 0, "chamfer must be less than half the smallest size of the cube");
    assertion(fn > 1, "nb of chamfer must be greater than 1");

    step = 360/fn;

    difference(){

        cylinder(r= r, h= h, $fn= fn, center= true);

        for(i= ((len(edges) - 1) == 0 ? [0] : [0 : len(edges) - 1])){
            
            if(edges[i] == EDGE_Top){

                for(j= [0 : fn - 1]){

                    transform(m= matRotZ((j + 1)*step)*scaleEdge(k= h/2, e= EDGE_Top)*scaleEdge(k= r, e= EDGE_Rgt)*matRotX(90))
                        chamferBase(chamfer, 2*r);
                }
            }
            if(edges[i] == EDGE_Bot){

                for(j= [0 : fn - 1]){

                    transform(m= matRotZ((j + 1)*step)*scaleEdge(k= h/2, e= EDGE_Bot)*scaleEdge(k= r, e= EDGE_Rgt)*matRotX(90))
                        chamferBase(chamfer, 2*r);
                }
            }
        }
    }
}

    // Bevels :

/*
* bevelBase(...)
*
* Only for functions
*
* Result: base for linear bevel
*/
module bevelBase(bevel, size, fn){
    
    mTranslate([bevel/2, bevel/2, 0])
        difference(){
    
            cube([bevel + 0.01, bevel + 0.01, size + 0.01], center= true);
        
            mTranslate([bevel/2, bevel/2, 0])
                cylinder(r= bevel, h= size + 0.02, center= true, $fn= fn);
        }        
}

/*
* bevelCube(size: the size of the cube according to [X, Y, Z]
*           bevel: bevel radius (bevel < min(size)/2)
*           fn: precision of the bevel pitch
*           edges: vector of the edges to be beveled)
*
* Result: custom beveled cube
*/
module bevelCube(size= [1, 1, 1], bevel= 0.1, fn= 100, edges= EDGE_All){

    assertion(bevel < min(size)/2, "bevel must be less than half the smallest size of the cube ");
    assertion(fn > 0, "fn must be greater than 0");
    assertion(len(edges) != 0, "bevel must be less than half the smallest size of the cube ");

    if(edges == EDGE_All){

        difference(){

            cube(size, center= true);

            for(r= [0, 1]){

                union(){
                    
                        // Top
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(-90))
                        bevelBase(bevel, size.y, fn);
                            
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.y/2, e= EDGE_Frt)*matRotY(90))
                        bevelBase(bevel, size.x, fn);
                    
                    // Bot
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.y/2, e= EDGE_Frt)*matRotY(-90))
                                bevelBase(bevel, size.x, fn);
                        
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(90))
                        bevelBase(bevel, size.y, fn);
                    
                    // Frt
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Rgt)*matRotZ(90))
                        bevelBase(bevel, size.z, fn);
                    transform(m= matRotZ(r*180)*scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Lft))
                        bevelBase(bevel, size.z, fn);
                }
            }
        }
    }
    else{

        difference(){

            cube(size, center= true);

            for(i= ((len(edges) - 1) == 0 ? [0] : [0 : len(edges) - 1])){

                if(edges[i] == EDGE_Top){

                    for(r= [0, 1]){

                        union(){
                            
                            transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(-90))
                                bevelBase(bevel, size.y, fn);
                            
                            transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.y/2, e= EDGE_Frt)*matRotY(90))
                                bevelBase(bevel, size.x, fn);
                        }
                        
                    }
                }
                else if(edges[i] == EDGE_Bot){

                    for(r= [0, 1]){

                        union(){
                            
                            transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.y/2, e= EDGE_Frt)*matRotY(-90))
                                bevelBase(bevel, size.x, fn);
                        
                            transform(m= matRotZ(r*180)*scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(90))
                                bevelBase(bevel, size.y, fn);
                        }
                    }
                }
                else if(edges[i] == EDGE_Back){

                    for(r= [0, 1]){

                        union(){
                            
                            transform(m= matRotY(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.y/2, e= EDGE_Back)*matRot([0,90,-90]))
                                bevelBase(bevel, size.x, fn);
                            
                            transform(m= matRotY(r*180)*scaleEdge(k= size.y/2, e= EDGE_Back)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotZ(-90))
                                bevelBase(bevel, size.z, fn);
                        }
                    }
                }
                else if(edges[i] == EDGE_Frt){

                    for(r= [0, 1]){

                        union(){
                            
                            transform(m= matRotY(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.y/2, e= EDGE_Frt)*matRotY(90))
                                bevelBase(bevel, size.x, fn);
                            
                            transform(m= matRotY(r*180)*scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Lft))
                                bevelBase(bevel, size.z, fn);
                        }
                    }
                }
                else if(edges[i] == EDGE_Rgt){

                    for(r= [0, 1]){

                        union(){
                            
                            transform(m= matRotX(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.x/2, e= EDGE_Rgt)*matRot([-90, 0, 90]))
                                bevelBase(bevel, size.y, fn);
                            
                            transform(m= matRotX(r*180)*scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Rgt)*matRotZ(90))
                                bevelBase(bevel, size.z, fn);   
                        }
                    }
                }
                else if(edges[i] == EDGE_Lft){

                    for(r= [0, 1]){

                        union(){
                            
                            transform(m= matRotX(r*180)*scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(-90))
                                bevelBase(bevel, size.y, fn);
                            
                            transform(m= matRotX(r*180)*scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Lft))
                                bevelBase(bevel, size.z, fn);
                        }
                    }
                }
                else if((edges[i] == EDGE_TopBack) || (edges[i] == EDGE_BackTop)){
                    
                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.y/2, e= EDGE_Back)*matRot([0,90,-90]))
                        bevelBase(bevel, size.x, fn);
                }
                else if((edges[i] == EDGE_TopFrt) || (edges[i] == EDGE_FrtTop)){
                    
                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.y/2, e= EDGE_Frt)*matRotY(90))
                        bevelBase(bevel, size.x, fn);
                }
                else if((edges[i] == EDGE_BotBack) || (edges[i] == EDGE_BackBot)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.y/2, e= EDGE_Back)*matRot([0, -90, -90]))
                        bevelBase(bevel, size.x, fn);
                }
                else if((edges[i] == EDGE_BotFrt) || (edges[i] == EDGE_FrtBot)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.y/2, e= EDGE_Frt)*matRotY(-90))
                        bevelBase(bevel, size.x, fn);
                }
                else if((edges[i] == EDGE_TopRgt) || (edges[i] == EDGE_RgtTop)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.x/2, e= EDGE_Rgt)*matRot([-90, 0, 90]))
                        bevelBase(bevel, size.y, fn);
                }
                else if((edges[i] == EDGE_TopLft) || (edges[i] == EDGE_LftTop)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Top)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(-90))
                        bevelBase(bevel, size.y, fn);
                }
                else if((edges[i] == EDGE_BotRgt) || (edges[i] == EDGE_RgtBot)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.x/2, e= EDGE_Rgt)*matRot([90, 0, 90]))
                        bevelBase(bevel, size.y, fn);
                }
                else if((edges[i] == EDGE_BotLft) || (edges[i] == EDGE_LftBot)){

                    transform(m= scaleEdge(k= size.z/2, e= EDGE_Bot)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotX(90))
                        bevelBase(bevel, size.y, fn);
                }
                else if((edges[i] == EDGE_BackRgt) || (edges[i] == EDGE_RgtBack)){

                    transform(m= scaleEdge(k= size.y/2, e= EDGE_Back)*scaleEdge(k= size.x/2, e= EDGE_Rgt)*matRotZ(180))
                        bevelBase(bevel, size.z, fn);
                }                
                else if((edges[i] == EDGE_BackLft) || (edges[i] == EDGE_LftBack)){

                    transform(m= scaleEdge(k= size.y/2, e= EDGE_Back)*scaleEdge(k= size.x/2, e= EDGE_Lft)*matRotZ(-90))
                        bevelBase(bevel, size.z, fn);
                }                
                else if((edges[i] == EDGE_FrtRgt) || (edges[i] == EDGE_RgtFrt)){

                    transform(m= scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Rgt)*matRotZ(90))
                        bevelBase(bevel, size.z, fn);
                }                
                else if((edges[i] == EDGE_FrtLft) || (edges[i] == EDGE_LftFrt)){

                    transform(m= scaleEdge(k= size.y/2, e= EDGE_Frt)*scaleEdge(k= size.x/2, e= EDGE_Lft))
                        bevelBase(bevel, size.z, fn);
                }
            }
        }

    }
}

/*
* cylinderBevelBase(...)
*
* Only for functions
*
* Result: base for beveledcylinder
*/
module cylyndBevelBase(r, bevel, fn){

    mTranslate([0, 0, -bevel])
    difference(){

        
        mTranslate([0, 0, (bevel + 0.01)/2])
            cylinder(r= r + 0.01, h= bevel + 0.01, $fn= fn, center= true);

            
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
* chamferCylinder(h: height of the cylinder
*                 r: radius of the cylinder
*                 bevel: bevel radius (chamfer < r/2)
*                 fn: precision of the bevel pitch
*                 edges: vector of the edges to be chamfered ONLY EDGE_Top or EDGE_Bot)
*
* Result: custom beveled cylinder
*/
module bevelCylinder(h= 1, r= 1, bevel= 0.1, fn= 100, edges= [EDGE_Top, EDGE_Bot]){

    assertion(bevel < r/2, "chamfer must be less than half the smallest size of the cube ");
    assertion(len(edges) != 0, "chamfer must be less than half the smallest size of the cube ");
    assertion(fn > 1, "nb of chamfer must be greater than 1");

    step = 360/fn;
    length= 2*PI*r/fn;

    difference(){

        cylinder(r= r, h= h, $fn= fn, center= true);

        for(i= ((len(edges) - 1) == 0 ? [0] : [0 : len(edges) - 1])){
            
            if(edges[i] == EDGE_Top){
                
                mTranslate([0, 0, h/2])
                    cylyndBevelBase(r= r, bevel= bevel, fn= fn);
            }
            if(edges[i] == EDGE_Bot){

                mTranslate([0, 0, -h/2])
                    rotX(180)
                        cylyndBevelBase(r= r, bevel= bevel, fn= fn);
            }
        }
    }
}

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
*            r2: if def thickness isn't used, top inner radius od the pipe,
*            h: height of the pipe,
*            fn: precision of the cylinders,
*            rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as
*                 [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*            center: center the piece at [0, 0, 0])
*
*  Result:
*   A parametrized linear pipe.
*/
module linearPipe(r= 1, thick= 0.1, r1= undef, r2= undef, h= 1, fn= 50, rot= ROT_Top, center= false){
    
    mRotate(rot)
        if(isDef(r1)){

            difference(){

                if(isDef(r2)){

                    assertion(r1 > r2, "r1 should be strictly greater than r2");
                    
                    
                    x = tan(atan((r - (r1 - r2) - r2)/h))*0.01;
                    
                    difference(){
                        
                        cylinder(r1= r, r2= r1, h= h, center= center, $fn= fn);
                        
                        mTranslate((center ? [0, 0, 0] : [0, 0, -0.01]))
                            cylinder(r1= r - (r1 - r2) + x, r2= r2 - x, h= h + 0.02, center= center, $fn= fn);
                    }
                }
                else{
                    
                    assertion(r1 > thick, "r1 should be strictly greater than thick");
                    
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
                
                assertion(r > r2, "r should be strictly greater than r2");
                
                difference(){
                    
                    cylinder(r= r, h= h, center= center, $fn= fn);

                    mTranslate((center ? [0, 0, 0] : [0, 0, -0.01]))
                        cylinder(r= r2, h= h + 0.02, center= center, $fn= fn);
                }
            }
            else{
                
                assertion(r > thick, "r should be strictly greater than thick");
                
                difference(){
                    
                    cylinder(r= r, h= h, center= center, $fn= fn);

                    mTranslate((center ? [0, 0, 0] : [0, 0, -0.01]))
                        cylinder(r= r - thick, h= h + 0.02, center= center, $fn= fn);
                }
            }
            
        }
}
// Exemple:
/*
* Create a centered pipe of height= 10, oriented at the Left with a thickness of 0.5, a bottom radius of r=2 and a top radius r1= 1
 */
/*
linearPipe(r= 2, r1= 1, thick= 0.5, h= 10, center= true, rot= ROT_Lft);
*/