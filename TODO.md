A ne pas oublier:
* Gestion des saves dans le splash(et global)
* Gestion du Game over
* Réorganiser SE par dossiers!
* Réorganiser systèmes events(text) et battle de façon abstraite.
* POUR TRANSFERER MUSIC, 2 SCENES, UNE CONTENANT LA MUSIQUE CHARGEANT L'AUTRE ET ALLANT A L'AUTRE SCENE A LA FIN HANDLANT LA SECONDE(en gros repenser le système de chargement)
* Fixer les spawns de debug(liés a l'issue au dessus)
* Ajouter Keyaku dans les remerciements et avertir Kreiss

CE QUI SUIS EST LIE A L'EXPORT ET NON AU JEU EN SOIT

* AVANT EXPORT verifier groupes images pour atlas
* Vérifier compression des musiques et SE

CE QUI SUIS EST LIE A DES MODS DE GODOT ENGINE

* Changer le format d'abstraction pck de Godot Engine en hashant les noms
* Supprimer les options non voulues au player release(autorisé seulement a
  exécuter ressources internes)
DEMANDER KREISS MENU OPTIONS(FullScreen, langues, FPS)


A VERIFIER:
* ScreenLoader a l'air de crasher si la scène est freed avant d'une facon wtf, le is_queue_deletion devrait le fixer.(repenser le système de chargement encore une fois.)
