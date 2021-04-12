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
* angleVectors(u: first vector,
*              v: second vector)
*
* Return:
*   The oriented angle between u and v.
 */
function angleVectors(u= [1, 0, 0], v= [0, 1, 0]) =
    (len(u) == len(v) ? (acos((u*v)/(mod(u)*mod(v)))
                    ) : (
                         echoError(msg= "u and v must have the same length"))
    );

/*
* matVectRotX(ang: angle in degree)
*
* Return:
*   X-axis rotation matrix of a 3D vector
*/
function matVectRotX(ang= 0) = [[1, 0,        0],
                                [0, cos(ang), -sin(ang)],
                                [0, sin(ang), cos(ang)]];

/*
* applyVectRotX(v: vector to be rotated along the X-axis,
*               ang: angle in degree)
*
* Return:
*   The vector v rotated along the X-axis.
 */
function applyVectRotX(v= [1, 1, 1], ang= 0) = v*matVectRotX(ang);

/*
* matVectRotY(ang: angle in degree)
*
* Return:
*   Y-axis rotation matrix of a 3D vector
*/
function matVectRotY(ang= 0) = [[cos(ang),  0, sin(ang)],
                                [0,         1, 0],
                                [-sin(ang), 0, cos(ang)]];

/*
* applyVectRotY(v: vector to be rotated along the Y-axis,
*               ang: angle in degree)
*
* Return:
*   The vector v rotated along the Y-axis.
 */
function applyVectRotY(v= [1, 1, 1], ang= 0) = v*matVectRotY(ang);

/*
* matVectRotZ(ang: angle in degree)
*
* Return:
*   Z-axis rotation matrix of a 3D vector
*/
function matVectRotZ(ang= 0) = [[cos(ang), -sin(ang), 0],
                                [sin(ang), cos(ang),  0],
                                [0,        0,         1]];

/*
* applyVectRotZ(v: vector to be rotated along the Z-axis,
*               ang: angle in degree)
*
* Return:
*   The vector v rotated along the Z-axis.
 */
function applyVectRotZ(v= [1, 1, 1], ang= 0) = v*matVectRotZ(ang);


/*
* matVectRot(ang: angles vector [angX, angY, angZ] in degree)
*
* Return:
*   Matrix of rotations according to the vector [angX, angY, angZ] of a 3D vector.
*/
function matVectRot(ang= [0, 0, 0]) = matVectRotX(ang.x)*matVectRotY(ang.y)*matVectRotZ(ang.z);


/*
* applyVectRot(v: vector to be rotated along all axis,
*               ang: angles vector [angX, angY, angZ] in degree)
*
* Return:
*   The vector v rotated along all axis.
 */
function applyVectRot(v= [1, 1, 1], ang= [0,0,0]) = v*matVectRot(ang);

