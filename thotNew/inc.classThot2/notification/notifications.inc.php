<?php

switch ($etape) {
    case 'subjectif':
        require_once 'inc/notification/subjectif.inc.php';
        break;
        
    case 'notif':
        require_once 'inc/notification/historique.inc.php';
        break;
    }
