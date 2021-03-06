include<Constants.scad>
use<Basics.scad>
use<Matrix.scad>

/*
* rotX(ang: trigonometric rotation angle around X (in degrees))
*
* Result: rotates $children around the X-axis
*/
module rotX(ang= 0){

    for(i= [0 : $children - 1]){

        multmatrix(m= matRotX(ang))
            children(i);
    }
}

/*
* rotY(ang: trigonometric rotation angle around Y (in degrees))
*
* Result: rotates $children around the Y-axis
*/
module rotY(ang= 0){

    for(i= [0 : $children - 1]){

        multmatrix(m= matRotY(ang))
            children(i);
    }
}

/*
* rotZ(ang: trigonometric rotation angle around Z (in degrees))
*
* Result: rotates $children around the Z-axis
*/
module rotZ(ang= 0){

    for(i= [0 : $children - 1]){

        multmatrix(m= matRotZ(ang))
            children(i);
    }
}

/*
* mRotate(ang: respectively the trigonometric rotation angles around [X, Y, Z] (in degrees))
*
* Result: rotates $children around all axis
*/
module mRotate(ang= [0, 0, 0]){

    assertion(len(ang) == 3, "ang should be a 3D vector");
    for(i= [0 : $children - 1]){

        multmatrix(m= matRot(ang))
            children(i);
    }
}

/*
* mTranslate(v: respectively the translation on [X, Y, Z] axis)
*
* Result: translates $children across all axis
*/
module mTranslate(v= [0, 0, 0]){

    assertion(len(v) == 3, "v should be a 3D vector");
    for(i= [0 : $children - 1]){

        multmatrix(m= matTrans(v))
            children(i);
    }
}

/*
* mScale(k: uniform scaling)
*
* Result: scales $children
*/
module mScale(k= [1, 1, 1]){

    assertion(len(k) == 3, "v should be a 3D vector");
    for(i= [0 : $children - 1]){

        multmatrix(m= matScale([ifNullGetUnit(k.x), ifNullGetUnit(k.y), ifNullGetUnit(k.z)]))
            children(i);
    }
}

module transform(m= matScale([1, 1, 1])){

    for(i= [0 : $children - 1]){

        multmatrix(m= m)
            children(i);
    }
}