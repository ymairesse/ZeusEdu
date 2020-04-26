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


Installation
============

L'installation sur le serveur web et l'initialisation de la base de données sont décrites dans la vidéo https://youtu.be/xYIUn1mpE2A

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

Licence
=======

Copyright 2005-2020 <COPYRIGHT Yves Mairesse ymairesse@sio2.be>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
