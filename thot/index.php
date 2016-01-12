<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';

// quel est l'utilisateur actif
$acronyme = $user->acronyme();

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

// si la page à montrer contient des onglets, quel est l'onglet actif
$onglet = isset($_POST['onglet']) ? $_POST['onglet'] : 0;
$smarty->assign('onglet', $onglet);

// ----------------------------------------------------------------------------
//

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new thot();
$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

$module = Application::repertoireActuel();

$listeCours = $user->listeCoursProf();
$smarty->assign('listeCours', $listeCours);

switch ($action) {
    case 'notification':
        include_once 'inc/notif/notifications.inc.php';
        break;
    case 'editNotification':
        include_once 'inc/notif/editNotifications.inc.php';
        break;
    case 'jdc':
        include_once 'inc/jdc.inc.php';
        break;
    case 'connexions':
        if ($userStatus == 'admin') {
            include_once 'inc/connexions.inc.php';
        }
        break;
    case 'gestion':
        include_once 'inc/gestion.inc.php';
        break;
	case 'admin':
		include_once ('inc/admin.inc.php');
    default:
        // wtf
        break;
}

//
// ----------------------------------------------------------------------------
$smarty->assign('executionTime', round($chrono->stop(), 6));
$smarty->display('index.tpl');
