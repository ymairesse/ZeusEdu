ZeusEdu
=======
Application de gestion de la vie scolaire. Version avec "responsive design"
Plus d'informations: http://sio2.be/?s=ZEUS

Avertissement
=============
Le logiciel est en perpétuelle construction, modification, restructuration, amélioration et parfois... régression.
En principe, le code présenté sur Github a toujours été testé en vraie grandeur sur une installation réelle utilisée
au jour le jour.
Si vous constatez un bug sur votre installation, venez toujours vérifier s'il n'y a pas eu une mise à jour de rectification.
Sinon, n'hésitez pas à me contacter pour obtenir la correction.
Les dates des commits doivent vous indiquer si des mises à jour ont encore lieu régulièrement.

Modifications importantes
=========================
Les mises à jour cruciales à réaliser dans la base de données ou dans des fichiers de portée générale

2017-12-20 : mise à jour de /inc/classes/classApplication.inc.php (ajout de la fonction dateTimeFr($dateTime))
2017-12-27 : ajout du champ "rédacteur" dans la table didac_thotJdc pour permettre la rédaction par les élèves
2017-12-28 : ajout de la table didac_thotJdcLike
2017-12-30 : mise à jour /screen.css
2017-12-31 : modification de la classe Ecole
2018-01-04: modification de la classe Athena
2018-01-04 : ajout de la table didac_athenaDemandes
2018-01-06 : modification de la table didac_adesFaits (valeurs NULL pour certains champs)
2018-01-07 : ajout de la table didac_thotJdcEleves
2018-02-15 : valeur par défaut du champ PJ de hermesArchives = Null, modification de la table didac_hermesArchives (ajout de deux champs: publie, dateFin)
2018-02-25 : modification de la longueur du champ "acroDest" dans la table didac_hermesArchives (4 acronymes x 7 signes + les virgules)
2018-03-04 : modification du type de champ pour le texte des messages Hermes => mediumBlob au lieu de Blob
2018-05-23 : ajout de la table didac_thotJDCTypes
2018-06-02 : ajout de la table didac_thotJdcPJ : pièces jointes au JDC
2018-08-07 : ajout du type "groupe" dans didac_thotNotifications (champ "type")
2018-08-23 : suppression des champs "url", "start" et "end" de la table didac_thotJdc
2018-08-23 : ajout du type "coursGrp" dans didac_thotJdc (le type "cours" peut être gardé temporairement)
2018-09-01 : ajout de deux fonctions dans la class classEcole.inc.php
2018-09-01 : ajout de la table didac_adesRetards dans la BD
2018-09-01 : mise à jour de la class Eleve (inc/classes/classEleve.inc.php)
2018-09-08 : ajustement des sections possibles dans la table didac_titus (changement de "G" -> "GT")
2018-09-09 : suppresion de la clef primaire multiple sur didac_thotShares et ajout de la clef primaire sur shareId
2018-09-22 : ajout du champ "lastModif" à la table didac_thotJdc

Installation
============

 - Configurer le fichier /config.inc.php pour la base de données
 - uploader tous les fichiers sur le serveur web
 - créer la base de données: par exemple avec phpMyAdmin. La base de données doit être en utf8_unicode_ci
 - lancer la procédure d'installation et d'initialisation des tables de la base de données à partir de http://ecole.org/install/index.php
 (où ecole.org désigne l'adresse URL de votre serveur)
 - vérifier le fonctionnement de l'application avec l'utilisateur ADM et le mot de passe 123456
 - effacer le répertoire /install !!!
 - configurer le fichier /config.ini pour l'établissement scolaire
 - importer les contenus des tables depuis les fichiers .csv

 Des fichiers .csv d'exemples se trouvent dans le répertoire /admin/exemples

 Informations plus détaillées sur le wiki http://sio2.be/wiki/doku.php

 Création d'une application
 ==========================

 - Cloner le répertoire nouvelleApplication avec le nom qui convient
 - Créer une icone .png 80x80px à mettre dans le répertoire /images avec le nom qui convient
 - Ajouter l'application dans l'admin générale
 - Activer l'application pour les utilisateurs dans l'admin générale
 - Créer l'application ;o)
