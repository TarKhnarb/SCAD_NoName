/*
    Vector.scad
        All vector fonctionalities
*/

use<Basics.scad>

/*
* makeVector(u: first vector,
*            v: second vector)
*
* Return:
*   Get mathématical vector uv.
 */
function makeVector(u= [0, 0, 0], v= [0, 0, 0]) =  v - u;

/*
* middleVector(u: first vector,
*              v: second vector)
*
* Return:
*   Coordonates of the center of the vector uv.
 */
function middleVector(u= [1, 1, 1], v= [1, 1, 1]) = (u + v)/2;

//function produitVectoriel EXIST: cross

/*
* mod(v: vector)
*
* Return:
*   The module of the vector v.
 */
function mod(v= undef) = (isUndef(v) ? 0 : sqrt(v*v));

/*
* angleVector(u: first vector,
*             v: second vector)
*
* Return:
*   The oriented angle between u and v.
 */
function angleVectors(u= [1, 0, 0], v= [0, 1, 0]) = (u*v)/(mod(u)*mod(v));

