<?php

switch ($mode) {
    case 'scan':
        require_once 'inc/retards/scanRetards.inc.php';
        break;
    // case 'listeRetards':
    //     require_once 'inc/retards/generateListeRetards.inc.php';
    //     break;
    case 'gestion':
        require_once 'inc/retards/retards.inc.php';
        break;
    }
