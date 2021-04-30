use<../package/Bezier.scad>
use<../package/Transforms.scad>

c1 = 5;
fa1 = 360/32;
z1 = 40;

c2 = 0.5;
fa2 = 360/24;
z2 = 25;

c3 = 30;
fa3 = 360/16;
z3 = -4;

c4 = 5;
fa4 = 360/8;
z4 = -5;

pts = [[[c1*cos(12*fa1), c1*sin(12*fa1), z1],    [c1*cos(11*fa1), c1*sin(11*fa1), z1],     [c1*cos(10*fa1), c1*sin(10*fa1), z1],        [c1*cos(9*fa1),  c1*sin(9*fa1),  z1],      [c1*cos(8*fa1),  c1*sin(8*fa1),  z1],      [c1*cos(7*fa1),  c1*sin(7*fa1),  z1],      [c1*cos(6*fa1),  c1*sin(6*fa1),  z1],      [c1*cos(5*fa1),  c1*sin(5*fa1),  z1],     [c1*cos(4*fa1),  c1*sin(4*fa1),  z1]],
       [[c1*cos(13*fa1), c1*sin(13*fa1), z1],    [c2*cos(9*fa2),  c2*sin(9*fa2),  z2],     [c2*cos(8*fa2),  c2*sin(8*fa2),  z2],        [c2*cos(7*fa2),  c2*sin(7*fa2),  z2],      [c2*cos(6*fa2),  c2*sin(6*fa2),  z2],      [c2*cos(5*fa2),  c2*sin(5*fa2),  z2],      [c2*cos(4*fa2),  c2*sin(4*fa2),  z2],      [c2*cos(3*fa2),  c2*sin(3*fa2),  z2],     [c1*cos(3*fa1),  c1*sin(3*fa1),  z1]],
       [[c1*cos(14*fa1), c1*sin(14*fa1), z1],    [c2*cos(10*fa2), c2*sin(10*fa2), z2],     [c3*cos(6*fa3),  c3*sin(6*fa3),  z3],        [c3*cos(5*fa3),  c3*sin(5*fa3),  z3],      [c3*cos(4*fa3),  c3*sin(4*fa3),  z3],      [c3*cos(3*fa3),  c3*sin(3*fa3),  z3],      [c3*cos(2*fa3),  c3*sin(2*fa3),  z3],      [c2*cos(2*fa2),  c2*sin(2*fa2),  z2],     [c1*cos(2*fa1),  c1*sin(2*fa1),  z1]],
       [[c1*cos(15*fa1), c1*sin(15*fa1), z1],    [c2*cos(11*fa2), c2*sin(11*fa2), z2],     [c3*cos(7*fa3),  c3*sin(7*fa3),  z3],        [c4*cos(3*fa4),  c4*sin(3*fa4),  z4],      [c4*cos(2*fa4),  c4*sin(2*fa4),  z4],      [c4*cos(1*fa4),  c4*sin(1*fa4),  z4],      [c3*cos(1*fa3),  c3*sin(1*fa3),  z3],      [c2*cos(1*fa2),  c2*sin(1*fa2),  z2],     [c1*cos(1*fa1),  c1*sin(1*fa1),  z1]],
       [[c1*cos(16*fa1), c1*sin(16*fa1), z1],    [c2*cos(12*fa2), c2*sin(12*fa2), z2],     [c3*cos(8*fa3),  c3*sin(8*fa3),  z3],        [c4*cos(4*fa4),  c4*sin(4*fa4),  z4],      [0,              0,             -5],       [c4*cos(0*fa4),  c4*sin(0*fa4),  z4],      [c3*cos(0*fa3),  c3*sin(0*fa3),  z3],      [c2*cos(0*fa2),  c2*sin(0*fa2),  z2],     [c1*cos(0*fa1),  c1*sin(0*fa1),  z1]],
       [[c1*cos(17*fa1), c1*sin(17*fa1), z1],    [c2*cos(13*fa2), c2*sin(13*fa2), z2],     [c3*cos(9*fa3),  c3*sin(9*fa3),  z3],        [c4*cos(5*fa4),  c4*sin(5*fa4),  z4],      [c4*cos(6*fa4),  c4*sin(6*fa4),  z4],      [c4*cos(7*fa4),  c4*sin(7*fa4),  z4],      [c3*cos(15*fa3), c3*sin(15*fa3), z3],      [c2*cos(23*fa2), c2*sin(23*fa2), z2],     [c1*cos(31*fa1), c1*sin(31*fa1), z1]],
       [[c1*cos(18*fa1), c1*sin(18*fa1), z1],    [c2*cos(14*fa2), c2*sin(14*fa2), z2],     [c3*cos(10*fa3), c3*sin(10*fa3), z3],        [c3*cos(11*fa3), c3*sin(11*fa3), z3],      [c3*cos(12*fa3), c3*sin(12*fa3), z3],      [c3*cos(13*fa3), c3*sin(13*fa3), z3],      [c3*cos(14*fa3), c3*sin(14*fa3), z3],      [c2*cos(22*fa2), c2*sin(22*fa2), z2],     [c1*cos(30*fa1), c1*sin(30*fa1), z1]],
       [[c1*cos(19*fa1), c1*sin(19*fa1), z1],    [c2*cos(15*fa2), c2*sin(15*fa2), z2],     [c2*cos(16*fa2), c2*sin(16*fa2), z2],        [c2*cos(17*fa2), c2*sin(17*fa2), z2],      [c2*cos(18*fa2), c2*sin(18*fa2), z2],      [c2*cos(19*fa2), c2*sin(19*fa2), z2],      [c2*cos(20*fa2), c2*sin(20*fa2), z2],      [c2*cos(21*fa2), c2*sin(21*fa2), z2],     [c1*cos(29*fa1), c1*sin(29*fa1), z1]],
       [[c1*cos(20*fa1), c1*sin(20*fa1), z1],    [c1*cos(21*fa1), c1*sin(21*fa1), z1],     [c1*cos(22*fa1), c1*sin(22*fa1), z1],        [c1*cos(23*fa1), c1*sin(23*fa1), z1],      [c1*cos(24*fa1), c1*sin(24*fa1), z1],      [c1*cos(25*fa1), c1*sin(25*fa1), z1],      [c1*cos(26*fa1), c1*sin(26*fa1), z1],      [c1*cos(27*fa1), c1*sin(27*fa1), z1],     [c1*cos(28*fa1), c1*sin(28*fa1), z1]]];

bezierSurface(M= pts, fn= 50)
       sphere(1, $fn= 30);
/*

for(i= [0 : 4]){
    
    for(j= [0 : 4]){
        
        mTranslate(pts[i][j])
            sphere(1, $fn= 30);
    }
}
*/