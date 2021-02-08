/*
    constants.scad
        Constants allowing the placement of future pieces
*/

    // Vectors
CENTER = [0, 0, 0];

UP = [0, 0, 1];

DOWN = [0, 0, -1];

FWD = [0, 1, 0];

RIGHT = [1, 0, 0];

BWD = [0, -1, 0];

LEFT = [-1, 0, 0];

ALLPOS = [1, 1, 1];

ALLNEG = [-1, -1, -1];

/*
               A
              / Y
    A        /
  Z |   ___________
    | / |         /|
    |/  |        / |
    /___________/  |
    |   ._ _ _ _|_ |
    |  /        | /
    | /         |/
    |/__________/  _ _ _>
                      X

    Les arrêtes sont défini à partir de cette vu 3D d'un cube. (L'orientation des axes est important pour l'utilisation ultérieur)
    En considérant le repère au centre du cube, le première face comme étant Front, celle du dessus Top, . . .
    Une arrête est représenté par la matrice de translation associée
*/

    // Edges

// Edges of plans
EDGE_Top    = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 1], [0, 0, 0, 1]]; // Top edges position
EDGE_Bot    = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, -1], [0, 0, 0, 1]]; // Bottom edges position
EDGE_Back   = [[1, 0, 0, 0], [0, 1, 0, 1], [0, 0, 1, 0], [0, 0, 0, 1]]; // Back edges position
EDGE_Frt    = [[1, 0, 0, 0], [0, 1, 0, -1], [0, 0, 1, 0], [0, 0, 0, 1]]; // Front edges position
EDGE_Rgt    = [[1, 0, 0, 1], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]; // Right edges position
EDGE_Lft    = [[1, 0, 0, -1], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]; // Left edges position

// Unique edge:
EDGE_TopBack    = EDGE_Top * EDGE_Back;
EDGE_TopFrt     = EDGE_Top * EDGE_Frt;
EDGE_TopRgt     = EDGE_Top * EDGE_Rgt;
EDGE_TopLft     = EDGE_Top * EDGE_Lft;

EDGE_BotBack    = EDGE_Bot * EDGE_Back;
EDGE_BotFrt     = EDGE_Bot * EDGE_Frt;
EDGE_BotRgt     = EDGE_Bot * EDGE_Rgt;
EDGE_BotLft     = EDGE_Bot * EDGE_Lft;

EDGE_BackTop    = EDGE_TopBack;
EDGE_BackBot    = EDGE_BotBack;
EDGE_BackRgt    = EDGE_Back * EDGE_Rgt;
EDGE_BackLft    = EDGE_Back * EDGE_Lft;

EDGE_FrtTop     = EDGE_TopFrt;
EDGE_FrtBot     = EDGE_BotFrt;
EDGE_FrtRgt     = EDGE_Frt * EDGE_Rgt;
EDGE_FrtLft     = EDGE_Frt * EDGE_Lft;

EDGE_RgtTop     = EDGE_TopRgt;
EDGE_RgtBot     = EDGE_BotRgt;
EDGE_RgtBack    = EDGE_BackRgt;
EDGE_RgtFrt     = EDGE_FrtRgt;

EDGE_LftTop     = EDGE_TopLft;
EDGE_LftBot     = EDGE_BotLft;
EDGE_LftBack    = EDGE_BackLft;
EDGE_LftFrt     = EDGE_FrtLft;

EDGE_All        = [EDGE_FrtLft, EDGE_TopLft, EDGE_BotLft];

