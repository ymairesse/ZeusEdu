<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';

// ----------------------------------------------------------------------------
//
require_once 'inc/classes/classPresences.inc.php';
$Presences = new Presences();
$acronyme = $user->getAcronyme();

$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : null;
$mode = isset($_REQUEST['mode']) ? $_REQUEST['mode'] : null;
$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;

// les photos sont-elles visibles?
$photosVis = isset($_COOKIE['photosVis']) ? $_COOKIE['photosVis'] : null;
$smarty->assign('photosVis', $photosVis);

$appli = $Application->getModule(1);

switch ($action) {
    case 'admin':
        include 'inc/gestAdmin.inc.php';
        break;
    case 'presences':
        include 'inc/gestPresences.inc.php';
        break;
    case 'retard':
        include 'inc/gestRetards.inc.php';
        break;
    case 'listes':
        include 'inc/gestListes.inc.php';
        break;

    case 'signaler':
        include 'inc/absences/signaler.php';
        break;

    case 'signalements':
        include 'inc/signalements.inc.php';
        break;
    case 'preferences':
        include 'inc/preferences.inc.php';
        break;
    case 'scan':
        if (in_array($user->userStatus($appli), array('educ', 'accueil', 'admin'))) {
            include('inc/retards/scanRetards.inc.php');
        }
        break;
    default:
        if (in_array($user->userStatus($appli), array('accueil'))) {
            include('inc/retards/scanRetards.inc.php');
        }
        else {
            include 'inc/gestPresences.inc.php';
        }
        break;
    }

//
// ----------------------------------------------------------------------------
$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('executionTime', round($chrono->stop(), 6));

$smarty->display('index.tpl');
