/*
    Vector.scad
        All vector fonctionalities
*/

use<Basics.scad>

    // Make the vector uv
function makeVector(u= [0, 0, 0], v= [0, 0, 0]) = v-u;

//function produitVectoriel EXIST: cross

    // Return the mod of a vecttor
function mod(v= undef) = (isUndef(v) ? 0 : sqrt(v*v));

    // Return the oriented angle between u and v
function angleVectors(u= [1, 0, 0], v= [0, 1, 0]) = (u*v)/(mod(u)*mod(v));

