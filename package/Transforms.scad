/*
  Transforms.scad

*/

include<Constants.scad>
use<Basics.scad>
use<Matrix.scad>

/***********************************************
* move( u: vector, can be used for a specific move

*       k: scalar, allows the orientation vector
*          to be mutilated by this scalar
*
*       orient: vector, unit vector defined in
*               Constant.scad)
*
* Examples:
*   1. move a cube with a specific vector ([2, 3.4, 0])
*       move(u= [2, 3.4, 0]){ cube(1); };
*
*   2. move a cube with an orient (UP) and a scalar (3)
*       move(k= 3, orient= UP){ cube(1); };
*
*   3. move a cube with a combination of orients
*       move(orient= 3*UP + 2*LEFT + 2*BWD){ cube(1); };
*      which is equivalent to :
*       move(u= [-2, -2, 3]){ cube(1); };
*
************************************************/
module move(u= [0, 0, 0], k= 1, orient= CENTER){

    for(i= [0 : $children - 1]){
        
        translate(u + k*orient)
            children(i);
    }
}

/***********************************************
* paramScale(orient: vector, can be used for a specific orient defined in Constants.scad)
*
* Example:
*   1. scale a cube with a specific orientation (3*UP + 4*LEFT)
*       paramScale(orient= 3*UP + 4*LEFT){ cube(1); };
*
************************************************/
module paramScale(orient= ALLPOS){

    for(i= [0 : $children - 1]){

        scale(ALLPOS*orient)
            children(i);
    }
}

/*
* rotX(ang: trigonometric rotation angle around X (in degrees))
*
* Result: rotates $children around the X-axis
*/
module rotX(ang= 0){

    for(i= [0 : $children - 1]){

        multmatrix(m= matRotX(ang= ang)){

            children(i);
        }
    }
}

/*
* rotY(ang: trigonometric rotation angle around Y (in degrees))
*
* Result: rotates $children around the Y-axis
*/
module rotY(ang= 0){

    for(i= [0 : $children - 1]){

        multmatrix(m= matRotY(ang= ang)){

            children(i);
        }
    }
}

/*
* rotZ(ang: trigonometric rotation angle around Z (in degrees))
*
* Result: rotates $children around the Z-axis
*/
module rotZ(ang= 0){

    for(i= [0 : $children - 1]){

        multmatrix(m= matRotZ(ang= ang)){

            children(i);
        }
    }
}

/*
* mRotate(ang: respectively the trigonometric rotation angles around [X, Y, Z] (in degrees))
*
* Result: rotates $children around all axis
*/
module mRotate(ang= [0, 0, 0]){

    for(i= [0 : $children - 1]){

        multmatrix(m= matRot(ang= ang)){

            children(i);
        }
    }
}

/*
* mTranslate(v: respectively the translation on [X, Y, Z] axis)
*
* Result: translates $children across all axis
*/
module mTranslate(v= [0, 0, 0]){

    for(i= [0 : $children - 1]){

        multmatrix(m= matTrans(v= v)){

            children(i);
        }
    }
}

/*
* mScale(v: respectively the [X, Y, Z] scaling)
*
* Result: scales $children
*/
module mScale(v= [1, 1, 1]){

    for(i= [0 : $children - 1]){

        multmatrix(m= matScale(v= v)){

            children(i);
        }
    }
}

/*
* mScale(k: uniform scaling)
*
* Result: scales $children
*/
module mScale(k= 1){

    for(i= [0 : $children - 1]){

        multmatrix(m= matScale(k= k)){

            children(i);
        }
    }
}

module transform(m= matScale()){

    for(i= [0 : $children - 1]){

        multmatrix(m= m){

            children(i);
        }
    }
}