module bevelBase(bevel, size, fn){

    mTranslate([bevel/2, bevel/2, 0])
    difference(){

        cube([bevel + 0.01, bevel + 0.01, size + 0.01], center= true);

        mTranslate([bevel/2, bevel/2, 0])
        cylinder(r= bevel, h= size + 0.02, center= true, $fn= fn);
    }
}

module bevelCylinder(h= 1, r= 1, bevel= 0.1, fn= 50, edges= [EDGE_Top, EDGE_Bot]){

    assertion(bevel < r/2, "chamfer must be less than half the smallest size of the cube ");
    assertion(len(edges) != 0, "chamfer must be less than half the smallest size of the cube ");
    assertion(fn > 1, "nb of chamfer must be greater than 1");

    step = 360/fn;
    length= 2*PI*r/fn;

    difference(){

        cylinder(r= r, h= h, $fn= fn, center= true);

        for(i= ((len(edges) - 1) == 0 ? [0] : [0 : len(edges) - 1])){

            if(edges[i] == EDGE_Top){

                for(j= [0 : fn - 1]){

                    transform(m= matRotZ((j + 1)*step)*scaleEdge(k= h/2, e= EDGE_Top)*scaleEdge(k= r, e= EDGE_Rgt)*matRot([-90, 0, 90]))
                    bevelBase(bevel, length, fn);
                }
            }
            if(edges[i] == EDGE_Bot){

                for(j= [0 : fn - 1]){

                    transform(m= matRotZ((j + 1)*step)*scaleEdge(k= h/2, e= EDGE_Bot)*scaleEdge(k= r, e= EDGE_Rgt)*matRot([90, 0, 90]))
                    bevelBase(bevel, length, fn);
                }
            }
        }
    }
}
