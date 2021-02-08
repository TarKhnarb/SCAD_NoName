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


module chamferBase(chamfer, size){

    rotZ(45)
       cube([sqrt(2)*chamfer, sqrt(2)*chamfer, size + 0.01], center= true);
}

module chamferCube(size= [1, 1, 1], chamfer= 1, edges= EDGE_All){

    assertion(chamfer < min(size)/2, "chamfer must be less than half the smallest size of the cube ");
    assertion(len(edges) != 0, "chamfer must be less than half the smallest size of the cube ");
    rots  = [[0, 0, 0], [90, 0, 0], [90, 0, 0]];
    if(edges == EDGE_All){

        difference(){

            cube(size, center= true);

            for(i= [0 : 2]){

                for(r= [0 : 3]){

                    transform(m= matRotZ(90*r)*scaleEdge(k= size[i]/2, e= edges[i])*matRot(rots[i]))
                        chamferBase(chamfer, size[i]);
                }
            }
        }
    }
    else{

        difference(){

            cube(size, center= true);

            for(i= [0 : len(edges) - 1]){

                if((edges[i] == EDGE_Top) || (edges[i] == EDGE_Bot)){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotZ(r)*scaleEdge(k= size.z/2, e= edges[i] * EDGE_Lft)*matRotX(90))
                            chamferBase(chamfer, size.z);
                    }
                }
                else if((edges[i] == EDGE_Back) || (edges[i] == EDGE_Frt)){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotY(r)*scaleEdge(k= size.y/2, e= edges[i] * EDGE_Lft))
                            chamferBase(chamfer, size.y);
                    }
                }
                else if((edges[i] == EDGE_Rgt) || (edges[i] == EDGE_Lft)){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotX(r)*scaleEdge(k= size.x/2, e= edges[i] * EDGE_Back))
                            chamferBase(chamfer, size.x);
                    }
                }
                else if((edges[i] == EDGE_TopBack) || (edges[i] == EDGE_BackTop)
                        || (edges[i] == EDGE_TopFrt) || (edges[i] == EDGE_FrtTop)
                        || (edges[i] == EDGE_BotBack) || (edges[i] == EDGE_BackBot)
                        || (edges[i] == EDGE_BotFrt) || (edges[i] == EDGE_FrtBot)){

                    transform(m= scaleEdge(k= size.x/2, e= edges[i])*matRotY(90))
                        chamferBase(chamfer, size.x);
                }
                else if((edges[i] == EDGE_TopRgt) || (edges[i] == EDGE_RgtTop)
                        || (edges[i] == EDGE_TopLft) || (edges[i] == EDGE_LftTop)
                        || (edges[i] == EDGE_BotRgt) || (edges[i] == EDGE_RgtBot)
                        || (edges[i] == EDGE_BotLft) || (edges[i] == EDGE_LftBot)){

                    transform(m= scaleEdge(k= size.y/2, e= edges[i])*matRotX(90))
                        chamferBase(chamfer, size.y);
                }
                else if((edges[i] == EDGE_BackRgt) || (edges[i] == EDGE_RgtBack)
                        || (edges[i] == EDGE_BackLft) || (edges[i] == EDGE_LftBack)
                        || (edges[i] == EDGE_FrtRgt) || (edges[i] == EDGE_RgtFrt)
                        || (edges[i] == EDGE_FrtLft) || (edges[i] == EDGE_LftFrt)){

                    transform(m= scaleEdge(k= size.z/2, e= edges[i]))
                        chamferBase(chamfer, size.z);
                }
            }
        }

    }
}

module bevelBase(bevel, size, fn){
    
    mTranslate([bevel/2, bevel/2, 0])
        difference(){
    
            cube([bevel + 0.01, bevel + 0.01, size + 0.01], center= true);
        
            mTranslate([bevel/2, bevel/2, 0])
                cylinder(r= bevel, h= size + 0.02, center= true, $fn= fn);
        }        
}

module bevelCube(size= [1, 1, 1], bevel= 1, fn= 100, edges= EDGE_All){

    assertion(bevel < min(size)/2, "bevel must be less than half the smallest size of the cube ");
    assertion(fn > 0, "fn must be greater than 0");
    assertion(len(edges) != 0, "bevel must be less than half the smallest size of the cube ");
    rots  = [[0, 0, 0], [-90, 0, 0], [90, 0, 0]];

    if(edges == EDGE_All){

        difference(){

            cube(size, center= true);

            for(i= [0 : 2]){

                for(r= [0 : 3]){

                    transform(m= matRotZ(90*r)*scaleEdge(k= size[2-i]/2, e= edges[i])*matRot(rots[i]))
                        bevelBase(bevel, size[i], fn);
                }
            }
        }
    }
    else{

        difference(){

            cube(size, center= true);

            for(i= [0 : len(edges) - 1]){

                if(edges[i] == EDGE_Top){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotZ(r)*scaleEdge(k= size.z/2, e= edges[i] * EDGE_Lft)*matRotX(-90))
                            bevelBase(bevel, size.z, fn);
                    }
                }
                else if(edges[i] == EDGE_Bot){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotZ(r)*scaleEdge(k= size.z/2, e= edges[i] * EDGE_Lft)*matRotX(90))
                            bevelBase(bevel, size.z, fn);
                    }
                }
                else if(edges[i] == EDGE_Back){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotY(r)*scaleEdge(k= size.y/2, e= edges[i] * EDGE_Lft)*matRotZ(-90))
                            bevelBase(bevel, size.y, fn);
                    }
                }
                else if(edges[i] == EDGE_Frt){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotY(r)*scaleEdge(k= size.y/2, e= edges[i] * EDGE_Lft))
                            bevelBase(bevel, size.y, fn);
                    }
                }
                else if(edges[i] == EDGE_Rgt){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotX(r)*scaleEdge(k= size.x/2, e= edges[i] * EDGE_Back)*matRotZ(180))
                            bevelBase(bevel, size.x, fn);
                    }
                }
                else if(edges[i] == EDGE_Lft){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotX(r)*scaleEdge(k= size.x/2, e= edges[i] * EDGE_Back)*matRotZ(-90))
                            bevelBase(bevel, size.x, fn);
                    }
                }
                else if((edges[i] == EDGE_TopBack) || (edges[i] == EDGE_BackTop)){
                    
                    transform(m= scaleEdge(k= size.x/2, e= edges[i])*matRot([0,90,-90]))
                        bevelBase(bevel, size.x, fn);
                }
                else if((edges[i] == EDGE_TopFrt) || (edges[i] == EDGE_FrtTop)){
                    
                    transform(m= scaleEdge(k= size.x/2, e= edges[i])*matRotY(90))
                        bevelBase(bevel, size.x, fn);
                }
                else if((edges[i] == EDGE_BotBack) || (edges[i] == EDGE_BackBot)){

                    transform(m= scaleEdge(k= size.x/2, e= edges[i])*matRot([0, -90, -90]))
                        bevelBase(bevel, size.x, fn);
                }
                else if((edges[i] == EDGE_BotFrt) || (edges[i] == EDGE_FrtBot)){

                    transform(m= scaleEdge(k= size.x/2, e= edges[i])*matRotY(-90))
                        bevelBase(bevel, size.x, fn);
                }
                else if((edges[i] == EDGE_TopRgt) || (edges[i] == EDGE_RgtTop)){

                    transform(m= scaleEdge(k= size.y/2, e= edges[i])*matRot([-90, 0, 90]))
                        bevelBase(bevel, size.y, fn);
                }
                else if((edges[i] == EDGE_TopLft) || (edges[i] == EDGE_LftTop)){

                    transform(m= scaleEdge(k= size.y/2, e= edges[i])*matRotX(-90))
                        bevelBase(bevel, size.y, fn);
                }
                else if((edges[i] == EDGE_BotRgt) || (edges[i] == EDGE_RgtBot)){

                    transform(m= scaleEdge(k= size.y/2, e= edges[i])*matRot([90, 0, 90]))
                        bevelBase(bevel, size.y, fn);
                }
                else if((edges[i] == EDGE_BotLft) || (edges[i] == EDGE_LftBot)){

                    transform(m= scaleEdge(k= size.y/2, e= edges[i])*matRotX(90))
                        bevelBase(bevel, size.y, fn);
                }
                else if((edges[i] == EDGE_BackRgt) || (edges[i] == EDGE_RgtBack)){

                    transform(m= scaleEdge(k= size.z/2, e= edges[i])*matRotZ(180))
                        bevelBase(bevel, size.z, fn);
                }                
                else if((edges[i] == EDGE_BackLft) || (edges[i] == EDGE_LftBack)){

                    transform(m= scaleEdge(k= size.z/2, e= edges[i])*matRotZ(-90))
                        bevelBase(bevel, size.z, fn);
                }                
                else if((edges[i] == EDGE_FrtRgt) || (edges[i] == EDGE_RgtFrt)){

                    transform(m= scaleEdge(k= size.z/2, e= edges[i])*matRotZ(90))
                        bevelBase(bevel, size.z, fn);
                }                
                else if((edges[i] == EDGE_FrtLft) || (edges[i] == EDGE_LftFrt)){

                    transform(m= scaleEdge(k= size.z/2, e= edges[i]))
                        bevelBase(bevel, size.z, fn);
                }
            }
        }

    }
}

//mTranslate([.3, 0, 0]) chamferBase(chamfer= .1, size= 1);
//bevelBase(bevel= .1, size= 1, fn= 100);
test(bevel= .1, edges= [EDGE_FrtLft]);