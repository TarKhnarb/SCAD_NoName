include<../package/BasicForms.scad>
include<../package/Thread.scad>

module topBox(){
    
    union(){
        
        difference(){
            
            knurling(r= 30, h= 29, ang= 45, moduleNb= 120, p = 0.4, fa= 5){

                chamferCylinder(h= 30, r= 30, chamfer= 2, chamferAng= 45, fn= 100, edges= [EDGE_Bot], pos= [0, 0, 15], center= true);
                
                mTranslate([0.01, 0, 0])
                    rotZ(90)
                        rotX(45)
                            cube([1, 1, 1], center= true);
            }
            
            mTranslate([0, 0, 5])
                cylinder(r= 27.5, h= 25.1, $fn= 100);
        }

        ISOTriangularThreadTap(D= 55, p= 3.5, h= 25, fa= 5, pos= [0, 0, 5]);
    }
}

//topBox();

module botBox(){
    
    difference(){
        
        union(){
            
            knurling(r= 30, h= 10, ang= 45, moduleNb= 120, p = 0.4, fa= 5){

                chamferCylinder(h= 7.5, r= 30, chamfer= 2, chamferAng= 45, fn= 100, edges= [EDGE_Bot], pos= [0, 0, 15/4], center= true);
                
                mTranslate([0.01, 0, 0])
                    rotZ(90)
                        rotX(45)
                            cube([1, 1, 1], center= true);
            }
            
            ISOTriangularThread(D= 55, p= 3.5, h= 25, gap= -0.2, fa= 5, pos= [0, 0, 5]);
        }

            chamferCylinder(r= 23, h= 25.1, chamfer= 2, chamferAng= 45, fn= 100, edges= [EDGE_Bot], pos= [0, 0, 17.5], center= true);
    }
}

//botBox();