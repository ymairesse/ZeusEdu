<?php

switch ($mode) {
    case 'subjectif':
        require_once 'inc/notif/subjectif.inc.php';
        break;
    case 'notif':
        require_once 'inc/notif/historique.inc.php';
        break;
    }
