use<Basics.scad>
use<Matrix.scad>
use<Transforms.scad>
include<Constants.scad>


module removal(chamfer, size){

    rotZ(45)
    cube([sqrt(2)*chamfer, sqrt(2)*chamfer, size + 0.01], center= true);
}

module final(size){

    cube(size, center= true);
}


module test(size= [1, 1, 1], chamfer= 1, pos= [1, 1, 1], edges= EDGE_All){

    assertion(chamfer < min(size)/2, "chamfer must be less than half the smallest size of the cube ");
    assertion(len(edges) != 0, "chamfer must be less than half the smallest size of the cube ");
    rots  = [[0, 0, 0], [90, 0, 0], [90, 0, 0]];
    if(edges == EDGE_All){

        difference(){

            final(size);

            for(i= [0 : 2]){

                for(r= [0 : 3]){

                    transform(m= matRotZ(90*r)*scaleEdge(k= size[i]/2, e= edges[i])*matRot(rots[i]))
                    removal(chamfer, size[i]);
                }
            }
        }
    }
    else{

        difference(){

            final(size);

            for(i= [0 : len(edges) - 1]){

                if((edges[i] == EDGE_Top) || (edges[i] == EDGE_Bot)){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotZ(r)*scaleEdge(k= size.z/2, e= edges[i] * EDGE_Lft)*matRotX(90))
                        removal(chamfer, size.z);
                    }
                }
                else if((edges[i] == EDGE_Back) || (edges[i] == EDGE_Frt)){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotY(r)*scaleEdge(k= size.y/2, e= edges[i] * EDGE_Lft))
                        removal(chamfer, size.y);
                    }
                }
                else if((edges[i] == EDGE_Rgt) || (edges[i] == EDGE_Lft)){

                    for(r= [0 : 90 : 270]){

                        transform(m= matRotX(r)*scaleEdge(k= size.x/2, e= edges[i] * EDGE_Back))
                        removal(chamfer, size.x);
                    }
                }
                else if((edges[i] == EDGE_TopBack) || (edges[i] == EDGE_BackTop)
                || (edges[i] == EDGE_TopFrt) || (edges[i] == EDGE_FrtTop)
                || (edges[i] == EDGE_BotBack) || (edges[i] == EDGE_BackBot)
                || (edges[i] == EDGE_BotFrt) || (edges[i] == EDGE_FrtBot)){

                    transform(m= scaleEdge(k= size.x/2, e= edges[i])*matRotY(90))
                    removal(chamfer, size.x);
                }
                else if((edges[i] == EDGE_TopRgt) || (edges[i] == EDGE_RgtTop)
                || (edges[i] == EDGE_TopLft) || (edges[i] == EDGE_LftTop)
                || (edges[i] == EDGE_BotRgt) || (edges[i] == EDGE_RgtBot)
                || (edges[i] == EDGE_BotLft) || (edges[i] == EDGE_LftBot)){

                    transform(m= scaleEdge(k= size.y/2, e= edges[i])*matRotX(90))
                    removal(chamfer, size.y);
                }
                else if((edges[i] == EDGE_BackRgt) || (edges[i] == EDGE_RgtBack)
                || (edges[i] == EDGE_BackLft) || (edges[i] == EDGE_LftBack)
                || (edges[i] == EDGE_FrtRgt) || (edges[i] == EDGE_RgtFrt)
                || (edges[i] == EDGE_FrtLft) || (edges[i] == EDGE_LftFrt)){

                    transform(m= scaleEdge(k= size.z/2, e= edges[i]))
                    removal(chamfer, size.z);
                }
            }
        }

    }
}

test(chamfer= .1, edges= [EDGE_BackLft, EDGE_BackTop]);