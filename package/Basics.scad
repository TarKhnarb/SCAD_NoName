use<Transforms.scad>
include<Constants.scad>
/*

  Basics.scad
    Contain all basics function  for the package
*/
/*
* isDef(u: any variable)
*
* Return:
*   True if the variable is defined, false otherwise
 */
function isDef(u) = (version_num() > 20190100) ? !isUndef(u) : (u != undef);

/*
* isUndef(u: any variable)
*
* Return:
*   True if the variable is undefined, flase otherwise
*/
function isUndef(u) = ((version_num() > 20190100) ? (u == undef) : !isDef(u));
/*
* echoMsg(msg : message to write in the console)
*
* Return:
*   Write in the console the message (if it was defined)
 */
function echoMsg(msg) = (isDef(msg) ? echo(msg) : 0);

/*
* echoError(msg: message to write in the console, string,
*           pfx: error prefix, by default as "ERROR")
*
* Return:
*   Writes in the console an error message highlighted in red with "prefix, message".
 */
module echoError(msg, pfx="ERROR"){

    echo(str("<p style=\"background-color: #ffb0b0\"><b>", pfx, ":</b> ", msg, "</p>"));
}

function echoError(msg, pfx= "ERROR") = echoMsg(str("<p style=\"background-color: #ffb0b0\"><b>",
                                                     pfx, ":</b> ", msg, "</p>"));
/*
* assertion(succ: bool, if the test is false, echo an error
*           msg: message to write in the console if succ is false)
*
* Return:
*   If
 */
function assertion(succ, msg) = (version_num() > 20190100) ? let(FAILED = succ) assert(FAILED, msg) : 0;

module assertion(succ, msg){

    if(version_num() > 20190100) {

        FAILED = succ;
        assert(FAILED, msg);
    }
    else if(!succ){

        echo_error(msg);
    }
}

/*
* ifNullGetUnit(value: variable to test)
*
* Return:
*   Test if the value is undef or equal to 0, return 1 otherwise return the value.
*   Mainly used for testing scale paraleters
*/
function ifNullGetUnit(value) = (isUndef(value) || (value == 0) ? 1 : value);

    // Geometrical values

/*
* regularDiameter(nbS: number of sides,
*                 lengthS: length of a side)
*
* Return:
*   Diameter of the circumscribed circle of the regular polygon with nbS sides
*/
function regularDiameter(nbS= 4, lengthS= 1) =
    (nbS > 2 ? (
                lengthS/cos(360/(2*nbS))
           ) : (
                echoError("nbS must be greater than 2"))
    );

/*
* regularRadius(nbS: number of sides,
*               lengthS: length of a side)
*
* Result:
*   Radius of the circumscribed circle of the regular polygon with nbS sides
*/
function regularRadius(nbS= 4, lengthS= 1) =
    (nbS > 2 ? (
                lengthS/(2*cos(360/(2*nbS)))
           ) : (
                echoError("nbS must be greater than 2"))
    );

/*
* writeOnFace(pos: position on the face,
*             text: parameter of openscad text() function refer to https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Text,
*             size: parameter of openscad text() function,
*             font: parameter of openscad text() function,
*             halign: parameter of openscad text() function,
*             spacing: parameter of openscad text() function,
*             direction: parameter of openscad text() function,
*             language: parameter of openscad text() function,
*             script: parameter of openscad text() function,
*             fn: parameter of openscad text() function,
*             h: height of th texte added,
*             rot: use sum of constants ROT_* for orient the hole OR custom rotation vector as
*                  [angX, angY, anfZ], note that the rotation is in the anti-clockwise direction,
*             diff: if true pierce the face with a depth of h, otherwise add the texte with a height of h)
*
* Result:
*   Add or remove a text on a face
 */
module writeOnFace(pos= [0, 0, 0], color= "white", text= "Test", size= 1, font, halign, valign, spacing, direction, language, script, fn= 30, h= 0.1, rot= ROT_Top, diff= false){

    if(diff){

        difference(){

            children();

            color(color)
                mTranslate(pos)
                    mRotate(rot)
                        mTranslate([0, 0, -h])
                            linear_extrude(h + 0.01)
                                text(text= text, size= size, font= font, halign= halign, valign= valign, spacing= spacing, direction= direction, language= language, script= script, $fn= fn);
        }
    }
    else{

        union(){

            children();

            color(color)
                mTranslate(pos)
                    mRotate(rot)
                        mTranslate([0, 0, -0.01])
                            linear_extrude(h + 0.01)
                                text(text= text, size= size, font= font, halign= halign, valign= valign, spacing= spacing, direction= direction, language= language, script= script, $fn= fn);
        }
    }
}
// Exemple:
/*
* Adds the name of the applied rotation constant on the corresponding side 
*/
/*
writeOnFace(pos= [0, 0, 5], text= "Top", color= "grey", size= 3, valign= "center", halign= "center")
writeOnFace(pos= [0, 5, 0], text= "Back", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Back + [0, 0, 180])
writeOnFace(pos= [0, -5, 0], text= "Front", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Frt)
writeOnFace(pos= [5, 0, 0], text= "Right", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Rgt + [0, 0, 90])
writeOnFace(pos= [-5, 0, 0], text= "Left", color= "grey", size= 3, valign= "center", halign= "center", rot= ROT_Lft + [0, 0, -90])
writeOnFace(pos= [0, 0, -5], text= "Bottom", color= "grey", size= 2, valign= "center", halign= "center", rot= ROT_Bot)
    cube(10, center= true);
*/

/*
* factorial(n: integer)
*
* Warning only integer or you will get an error on the recursion
*
* Return:
*   The factorial of n.
*/
function factorial(n) = (n==0 ? 1 : factorial(n - 1)*n);

/*
* choose(n: top coefficient,
*        k: bottom coefficient)
*
* Warning only integer or you will get an error on the recursion
*
* Return:
*   n choose k.
*/
function choose(n, k) =
((n >= k) && (k >= 0) ? (factorial(n)/(factorial(k)*factorial(n - k))
) : (
echoError(msg= "n must be greater or equal than k and k must be greater or equal than 0"))
);