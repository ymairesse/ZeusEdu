<?php

switch ($mode) {
    case 'scan':
        require_once 'inc/retards/scanRetards.inc.php';
        break;

    case 'traitement':
        require_once 'inc/retards/traitement.inc.php';
        break;

    case 'synthese':
        require_once 'inc/retards/synthese.inc.php';
        break;
    }
