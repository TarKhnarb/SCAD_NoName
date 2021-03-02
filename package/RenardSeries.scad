use<Basics.scad>

/*
* normalNumbersSerie(R: normal number,
*                    n: desired rankvalue,
*                    B: base number)
* Return:
*   Return the corresponding normal number.
 */
function normalNumbersSerie(R, n, B) = B*pow(exp(ln(10)/R), n);

/*
* normalNumbersSerie(R: normal number,
*                    n: desired rankvalue,
*                    B: base number)
* Return:
*   Return the corresponding normal number.
 */
function renardSerie(R= undef, n= undef, B= undef) = 
    (isDef(R) && isDef(n) && isDef(B) ? (
                                         (search(R, [5, 10, 20, 40])) ? (
                                                                         (search(B, [1, 10, 100])) ? (
                                                                                                       ((B == 10) && (R == 40) && (n == 1) ? (
                                                                                                                                              normalNumbersSerie(R, 2, B)
                                                                                                                                         ) : (
                                                                                                                                              ((B == 10) && (R == 40) && (n > 1) ? (
                                                                                                                                                                                    normalNumbersSerie(R, n+2, B)
                                                                                                                                                                               ) : (
                                                                                                                                                                                    normalNumbersSerie(R, n, B)))))
                                                                                                  ) : (
                                                                                                      echoError(msg= "B must be equal to 1, 10 or 100"))
                                                                    ) : (
                                                                         echoError(msg= "R must be equal to 5, 10, 20 or 40"))
                                    ) : (
                                          echoError(msg= "R, n and B must be defined")
                                    )
    );

echo(renardSerie(R= 20, n= 6, B= 10));

