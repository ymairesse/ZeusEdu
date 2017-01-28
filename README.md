ZeusEdu
=======
Application de gestion de la vie scolaire. Version avec "responsive design"
Plus d'informations: http://sio2.be/?s=ZEUS

Avertissement
=============
Le logiciel est en perpétuelle construction, modification, restructuration, amélioration et parfois... régression.
En principe, le code présenté sur Github a toujours été testé en vraie grandeur sur une installation réelle utilisée
au jour le jour.
Si vous constatez un bug sur votre installation, venez toujours vérifier s'il n'y a pas eu une mise à jour de rectifiction.
Sinon, n'hésitez pas à me contacter pour obtenir la correction.
Les dates des commits doivent vous indiquer si des mises à jour ont encore lieu régulièrement.

Installation
============

 - Configurer le fichier /config.inc.php pour la base de données
 - uploader tous les fichiers sur le serveur web
 - créer la base de données: par exemple avec phpMyAdmin. La base de données doit être en utf8_unicode_ci
 - lancer la procédure d'installation et d'initialisation des tables de la base de données à partir de http://ecole.org/install/index.php
 (où ecole.org désigne l'adresse URL de votre serveur)
 - vérifier le fonctionnement de l'application avec l'utilisateur ADM et le mot de passe 123456
 - effacer le répertoir /install.php !!!
 - configurer le fichier /config.ini pour l'établissement scolaire
 - importer les contenus des tables depuis les fichiers .csv

 Des fichiers .csv d'exemples se trouvent dans le répertoire /admin/exemples

 Informations plus détaillées sur le wiki http://sio2.be/wiki/doku.php
