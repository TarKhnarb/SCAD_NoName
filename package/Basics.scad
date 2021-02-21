/*

  Basics.scad
    Contain all basics function  for the package
*/

    // Return true if the variable is defined, false otherwise
function isDef(u) = (version_num() > 20190100) ? !isUndef(u) : (u != undef);

    // return true if the variable is undefined, flase otherwise
function isUndef(u) = ((version_num() > 20190100) ? (u == undef) : !isDef(u));

function echoMsg(msg) = (isDef(msg) ? echo(msg) : 0);

module echoError(msg, pfx="ERROR"){

    echo(str("<p style=\"background-color: #ffb0b0\"><b>", pfx, ":</b> ", msg, "</p>"));
}

function echoError(msg, pfx= "ERROR") = echoMsg(str("<p style=\"background-color: #ffb0b0\"><b>",
                                                     pfx, ":</b> ", msg, "</p>"));

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
* ifNullGetUnit(value: var iable to test)
*
*   Test if the value is undef or equal to 0, return 1 otherwise return the value.
*   Mainly used for testing scale paraleters
*/
function ifNullGetUnit(value) = (isUndef(value) || (value == 0) ? 1 : value);

    // Geometrical values

/*
* regularDiameter(nbS: number of sides,
*                 lengthS: length of a side)
*
* Result:
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
   