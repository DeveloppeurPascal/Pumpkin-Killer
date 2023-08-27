# 20220702 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à niveau du projet en Delphi 11.1 Alexandria (précédente version 10.3 Rio)
* saisie de la TODO liste initiale suite à tests du jeu et parcours des sources
* refaire icône du jeu  dans Pic Mob Generator pour récupérer les nouvelles tailles d'images
* ajouter plateforme Linux
* ajouter plateforme macOS ARM (Apple Silicon M1)
* mise à jour des icônes dans toutes les plateformes cibles du projet
* mise à jour des infos de versions pour l'Apple Silicon M1 (macOS ARM)
* mise à jour des infos de versions pour macOS 64 bits
* passage de la version en 1.1 pour toutes les versions (release et debug)
* ajout de ITSAppUsesNonExemptEncryption=false pour Mac

* test de fonctionnement sur toutes les plateformes

* passage du clic de la zone de jeu avec recherche de la citrouille touchée au test direct de chaque citrouille en tant que composant au niveau de la fiche (prise en charge du clic dessus dès qu'elle est en mouvement, pas lors de sa fin de vie)

* bogue iPadOS : des rebords apparaissaient sur l'écran en mode paysage (manquait le storyboard, qui semble être utilisé pour fournir la bonne taille d'écran au programme)
* modification des paramètres permettant de masquer la barre de notification sur iOS

* modification des liens de redirections remplacés par la version normale des URL (sans redirection, ni stats)

* ajout de la dépendance du projet avec les librairies / toolbox Delphi dispo sur GitHub (https://github.com/DeveloppeurPascal/librairies) pour prendre la dernière version de u_URLOpen au lieu d'une version copiée et pas maintenue

* le bouton de partage sociale depuis l'écran Game Over n'est plus affiché en dur pour iOS / Android mais dépend désormais de la disponibilité du service de plateforme correspondant
* la capture d'écran partagée en fin de partie est désormais faite systématiquement lors de l'action de partage et pas juste pour iOS (si c'est pris en charge sur la plateforme concernée).

* mise en place du bundle Android (32+64) en déploiement 64 bits pour magasin d'application
* mise en place du bundle macOS (Intel+Apple Silicon) en déploiement macOS ARM 64 bits pour magasin d'application

* compilation et déploiement du projet pour les plateformes ciblées

* soumission et publication l'application sur Itch.io (Windows, Mac, Android)
* soumission de l'application sur Google Play (Android)
* soumission de l'application sur Amazon (Android)
* soumission de l'application sur App Store (iOS)
* soumission de l'application sur Mac App Store (Mac)
