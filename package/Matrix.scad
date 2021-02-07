/*
* Matrix.scad
*   All function for lineaar transformation with matrix and other matrix specifications
*/

use<Basics.scad>
include<Constants.scad>

/*
* Representation of a linear transformatiopn matrix :
*
*      [[Scale X]	        [Shear X along Y]	[Shear X along Z]	[Translate X]
*       [Shear Y along X]	[Scale Y]	        [Shear Y along Z]	[Translate Y]
*       [Shear Z along X]	[Shear Z along Y]	[Scale Z]	        [Translate Z]
*       [0]                  [0]                 [0]                 [1]]
*/

/*
* matrix(...) :
*
* [[scalX]  [shXalY]    [shXalZ]	[transX]
*  [shYalX]	[scalY]	    [shYalZ]	[transY]
*  [shZalX]	[shZalY]	[scalZ]	    [transZ]
*  [0]      [0]         [0]         [1]]
*
* Returns: the associated linear transformation matrix
*/
function matrix(scalX= 1,
                scalY= 1,
                scalZ= 1,
                transX= 0,
                transY= 0,
                transZ= 0,
                shYalX= 0,
                shZalX= 0,
                shXalY= 0,
                shZalY= 0,
                shXalZ= 0,
                shYalZ= 0) = [[ifNullGetUnit(scalX), shXalY,               shXalZ,               transX],
                              [shYalX,               ifNullGetUnit(scalY), shYalZ,               transY],
                              [shZalX,               shZalY,               ifNullGetUnit(scalZ), transZ],
                              [0,                    0,                    0,                    1]];

/*
* matrix(...) :
*
* [[scal.x]     [shXalY]    [shXalZ]	[trans.x]
*  [shYalX]	    [scal.y]	[shYalZ]	[trans.y]
*  [shZalX]	    [shZalY]	[scal.z]    [trans.z]
*  [0]          [0]         [0]         [1]]
*
* Returns: the associated linear transformation matrix
*/
function matrix(scal= [1, 1, 1],
                trans= [0, 0, 0],
                shYalX= 0,
                shZalX= 0,
                shXalY= 0,
                shZalY= 0,
                shXalZ= 0,
                shYalZ= 0) = [[ifNullGetUnit(scal.x), shXalY,                shXalZ,                trans.x],
                              [shYalX,                ifNullGetUnit(scal.y), shYalZ,                trans.y],
                              [shZalX,                shZalY,                ifNullGetUnit(scal.z), trans.z],
                              [0,                     0,                     0,                     1]];

/*
* matRotX(ang: trigonometric rotation angle around X (in degrees))
*
* Returns: the associated linear transformation matrix
 */
function matRotX(ang= 0) = [[1, 0,        0,         0],
                            [0, cos(ang), -sin(ang), 0],
                            [0, sin(ang), cos(ang),  0],
                            [0, 0,        0,         1]];

/*
* matRotY(ang: trigonometric rotation angle around Y (in degrees))
*
* Returns: the associated linear transformation matrix
 */
function matRotY(ang= 0) = [[cos(ang),  0, sin(ang), 0],
                            [0,         1, 0,        0],
                            [-sin(ang), 0, cos(ang), 0],
                            [0,         0, 0,        1]];

/*
* matRotX(ang: trigonometric rotation angle around Z (in degrees))
*
* Returns: the associated linear transformation matrix
 */
function matRotZ(ang= 0) = [[cos(ang), -sin(ang), 0, 0],
                            [sin(ang), cos(ang),  0, 0],
                            [0,        0,         1, 0],
                            [0,        0,         0, 1]];

/*
* matRotX(ang: respectively the trigonometric rotation angles around [X, Y, Z] (in degrees))
*
* Returns: the associated linear transformation matrix
 */
function matRot(ang= [0, 0, 0]) = matRotX(ang.x)*matRotY(ang.y)*matRotZ(ang.z);

/*
* matTrans(v: respectively the translation on [X, Y, Z] axis)
*
* Returns: the associated linear transformation matrix
 */
function matTrans(v= [0, 0, 0]) = [[1, 0, 0, v.x],
                                   [0, 1, 0, v.y],
                                   [0, 0, 1, v.z],
                                   [0, 0, 0, 1]];

/*
* matScale(v: respectively the [X, Y, Z] scaling)
*
* Returns: the associated linear transformation matrix
 */
function matScale(v= [1, 1, 1]) = [[ifNullGetUnit(v.x), 0,                  0,                  0],
                                   [0,                  ifNullGetUnit(v.y), 0,                  0],
                                   [0,                  0,                  ifNullGetUnit(v.z), 0],
                                   [0,                  0,                  0,                  1]];

/*
* matTrans(k: uniform scaling)
*
* Returns: the associated linear transformation matrix
 */
function matScale(k= 1) = [[ifNullGetUnit(k), 0,                0,                0],
                           [0,                ifNullGetUnit(k), 0,                0],
                           [0,                0,                ifNullGetUnit(k), 0],
                           [0,                0,                0,                1]];

function scaleEdge(k, e) = matrix(trans= [k*e[0][3],
                                          k*e[1][3],
                                          k*e[2][3]]);
