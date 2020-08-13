<?php

$etape = isset($_GET['etape']) ? $_GET['etape'] : Null;
if ($etape == Null)
    $etape = isset($_POST['etape']) ? $_POST['etape'] : Null;

switch ($etape) {
    case 'subjectif':
        require_once 'inc/notif/subjectif.inc.php';
        break;
    case 'notif':
        require_once 'inc/notif/historique.inc.php';
        break;
    }
