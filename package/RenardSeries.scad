use<Basics.scad>

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
                                                                                                      echo("B doit etre égal à 1, 10 ou 100"))
                                                                    ) : (
                                                                         echo("R doit etre égal à 5, 10, 20 ou 40"))
                                    ) : (
                                          echo("R, n et B doivent etre définis")
                                    )
    );

function normalNumbersSerie(R, n, B) = B*pow(exp(ln(10)/R), n);

echo(renardSerie(R= 20, n= 6, B= 10));



