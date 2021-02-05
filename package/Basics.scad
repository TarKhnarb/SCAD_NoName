/*

  Basics.scad
    Contain all basics function  for the package
*/

    // Return true if the variable is defined, false otherwise
function isDef(u) = (u != undef);

    // return true if the variable is undefined, flase otherwise
function isUndef(u) = ((version_num() > 20190100) ? (u == undef) : !isDef(u));

function echoMsg(msg) = ((version_num() > 20190100)? echo(msg) : 0);

module echoError(msg, pfx="ERROR"){

    echo(str("<p style=\"background-color: #ffb0b0\"><b>", pfx, ":</b> ", msg, "</p>"));
}

function echoError(msg, pfx= "ERROR") = echoMsg(str("<p style=\"background-color: #ffb0b0\"><b>",
                                                     pfx, ":</b> ", msg, "</p>"));

function assertion(succ, msg) = (version_num() > 20190100) ? let(FAILED = succ) assert(FAILED, msg) : 0;


/*
* ifNullGetUnit(value: var iable to test)
*
*   Test if the value is undef or equal to 0, return 1 otherwise return the value.
*   Mainly used for testing scale paraleters
*/
function ifNullGetUnit(value) = (isUndef(value) || (value == 0) ? 1 : value);

/*
* matrix(scaleX:
*
*
*
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
                shYalZ= 0) = [[ifNullGetUnit(scaleX), shXalY, shXalZ, transX],
                              [shYalX, ifNullGetUnit(scaleY), shYalZ, transY],
                              [shZalX, shZalY, ifNullGetUnit(scaleZ), transZ],
                              [0,      0,      0,      1]];