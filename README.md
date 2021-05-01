# __SCAD_NoName__
___
## Présentation

SCAD_NoName est une bibliothèque additionnelle pour OpenSCAD __https://openscad.org/__.
Cette bibliothèque à pour but d'ajouter les principaux modules nécessaires pour la réalisation de pièces destinées à l'impression 3D.
___
## Contenu de l'archive
```
SCAD_NoName
|   README.md
|   Documentation.pdf
|
|___ package
|   |   BasicForms.scad
|   |   Basics.scad
|   |   Bevel_Chamfer.scad
|   |   Bezier.scad
|   |   Constants.scad
|   |   Gear.scad
|   |   Holes.scad
|   |   Matrix.scad
|   |   RenardSerie.scad
|   |   Spring.scad
|   |   Thread.scad
|   |   Transforms.scad
|   |   Useless.scad
|   |   Vector.scad
|
|___ pieces
|   |   Box.scad
|   |   Vase.scad
```
> __Note importante:__
>* Les fonctions __isDef, isUndef, echoMsg, echoError et assertion__ se trouvant dans __package/Basics.scad__, sont inspirées et/ou reprises de la bibliothèque BOSL/BOSL-master/compat.scad __https://openscad.org/libraries.html__.
>* Les modules de courbes et de surfaces de Bézier sont réalisées à partir de leur définitions trouvées sur wikipédia __https://en.wikipedia.org/wiki/B%C3%A9zier_curve__, __https://en.wikipedia.org/wiki/B%C3%A9zier_surface__.
>* Les autres modules ont étés créés à partir des livres suivants:
>   *  R. Quatremer, J.-P. Trotignon. Précis de construction mécanique 1. Dessin, conception et normalisation 11ème éd. Nathan, 1986.
>   *  M. Norbert, R. Phillipe. Aide-mémoire de l'élève dessinateur et du dessinateur industriel édition nouvelle. La Capitelle, Uzès, juin 1980.
>   *  M. Norbert. Aide-mémoire de l'élève dessinateur édition nouvelle. La Capitelle, Uzès, 1957-1958.

___
## Installation & utilisation

### Installation de OpenSCAD

> Les OS disponibles sont Windows, Mac OS, linux.
> Pour obtenir OpenScad, veuillez suivre les instructions suivantes : __https://openscad.org/downloads.html__

### Installation de la bibliothèque

> Une fois l'archive téléchargée, pour n'avoir qu'à utiliser __use/include<package/*.scad>__ vous pouvez déplacer le dossier __package__ dans le dossier __~/.config/OpenSCAD__ 
> (normalement créer après avoir installé OpenSCAD et ouvert un nouveau projet et l'avoir enregistré).
> 
> Vous pouvez aussi tout simplement déplacer le dossier __package__ sur la racine où se trouve votre projet.
> Dans ce cas, vous devrez indiquer le chemin jusqu'au fichier qui vous intéresse.
___
## Description de la bibliothèque

Les modules fonctionnels sont référencées dans le fichier __Documentation.pdf__.
La liste suivante explique brièvement la composition de chacun des fichiers.

>* BasicForms
> 
>        Ajoute de nouvelles formes de base.
>
>* Basics
>
>        Regroupe les fonctions utilitaires à la bibliothèque.
>
>* Bevel_Chamfer
>
>        Ajoute des congés et des chanfreins pour les inclures à des pièces.
>
>* Bezier
>
>        Ajoute des courbes et des surfaces de Bézier.
>
>* Constants
>
>        Regroupe les constantes nécessaires pour certains modules et fonctions.
>
>* Gears
>
>        Ajoute des engrenages.
>
>* Holes
>
>        Ajoute des modules de perçage.
>
>* Matrix
>
>        Regroupe les fonctions de génération de matrices de transformation.
>
>* RenardSeries
>
>        Ajoute une fonction de calcul pour les séries de Renard.
>
>* Spring
>
>        Ajoute des ressorts.
>
>* Thread
>
>        Ajoute des filetages et taraudages et un module de moletage.
>
>* Transforms
>
>        Ajoute des fonctions et des modules de transformation à l’aide de matrices de transformation.
>
>* Useless
>
>        Regroupe toutes les fonctions et modules devenus inutiles ou utilisés dans des phases de recherche.
>
>* Vector
>
>        Ajoute des fonctions de calculs sur les vecteurs. 
___