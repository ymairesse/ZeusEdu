<?php

$etape = isset($_GET['etape']) ? $_GET['etape'] : Null;
if ($etape == Null)
    $etape = isset($_POST['etape']) ? $_POST['etape'] : Null;


switch ($etape) {
    case 'subjectif':
        require_once 'inc/notif/subjectif.inc.php';
        break;
    case 'historique':
        require_once 'inc/notif/historique.inc.php';
        break;
    case 'show':
        require_once 'inc/notif/newEditNotifications.inc.php';
        break;
    case 'enregistrer':
        require_once 'inc/notif/saveNotifications.inc.php';
        break;
}
