### À ne pas oublier:
* Faire les spritesets pour chaque personnage et qui dépende de chaque environnement (Battle, Worlds, etc…).
Non, sérieux, ça coupe les temps de loading (test-only) et temps d'export, et, plus importantement, ça aide vraiment avec les "boundaries" de chaque personnage.
* Gestion des saves dans le splash(et global)
* Gestion du Game over
* Réorganiser SE par dossiers! (partiellement fait!)
* Réecrire le système de Guard (sauf la partie du Signal). Il est un peu confus.
* Réorganiser systèmes events(text) et battle de façon abstraite.
* POUR TRANSFERER MUSIC, 2 SCENES, UNE CONTENANT LA MUSIQUE CHARGEANT L'AUTRE ET ALLANT A L'AUTRE SCENE A LA FIN HANDLANT LA SECONDE(en gros repenser le système de chargement)
* Fixer les spawns de debug(liés a l'issue au dessus)
* Ajouter Keyaku dans les remerciements ~~et avertir Kreiss~~
* Documenter la nomenclature des fichiers, où:
	- "nom_de_script" ---> script interne qui ne doit pas être considérée comme Class
	- "NomDeScript" ---> script pour un node

### CE QUI SUIS EST LIE A L'EXPORT ET NON AU JEU EN SOIT

* AVANT EXPORT verifier groupes images pour atlas
* Vérifier compression des musiques et SE

### CE QUI SUIS EST LIE A DES MODS DE GODOT ENGINE

* Changer le format d'abstraction pck de Godot Engine en hashant les noms
* Supprimer les options non voulues au player release(autorisé seulement a
  exécuter ressources internes)
DEMANDER KREISS MENU OPTIONS(FullScreen, langues, FPS)


### A VERIFIER:
Rien pour l'instant.
