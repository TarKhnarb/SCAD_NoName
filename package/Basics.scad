/*

  Basics.scad
    Contain all basics function  for the package
*/

    // Return true if the variable is defined, false otherwise
function isDef(u) = (u != undef);

    // return true if the variable is undefined, flase otherwise
function isUndef(u) = ((version_num() > 20190100) ? (u == undef) : !isDef(u));

