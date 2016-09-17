<?php

switch ($mode) {
    case 'classes':
        require 'inc/notif/notificationClasse.inc.php';
        break;
    case 'coursGrp':
        require 'inc/notif/notificationCours.inc.php';
        break;
    case 'niveau':
        require 'inc/notif/notificationNiveau.inc.php';
        break;
    case 'ecole':
        require 'inc/notif/notificationEcole.inc.php';
        break;
    case 'historique':
        require 'inc/notif/historique.inc.php';
        break;
    }
