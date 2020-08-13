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

$module = $Application->getModule(1);

$listeCours = $user->listeCoursProf();
$smarty->assign('listeCours', $listeCours);

$titulaire = $user->listeTitulariats();
$smarty->assign('titulaire', $titulaire);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

switch ($action) {
    case 'notification':
        include_once 'inc/notif/notifications.inc.php';
        break;
    case 'remediation':
        require_once 'inc/remediation/remediation.inc.php';
        break;
    case 'jdc':
        require_once 'inc/jdc.inc.php';
        break;
    case 'connexions':
        if ($userStatus == 'admin') {
            include_once 'inc/connexions.inc.php';
        }
        break;
    case 'files':
        include_once 'inc/files/gestFiles.php';
        break;
    case 'gestion':
        include_once 'inc/parents/gestion.inc.php';
        break;
    case 'reunionParents':
        include_once 'inc/gestRP.inc.php';
        break;
    case 'reunionTitulaires':
        include_once 'inc/gestRtitu.inc.php';
        break;
	case 'admin':
		include_once ('inc/admin.inc.php');
        break;
    case 'stats':
        include_once 'inc/stats.inc.php';
        break;
    case 'formulaires':
        include_once 'inc/forms/gestForms.inc.php';
        break;
    case 'bib':
        include_once 'inc/books/gestBooks.inc.php';
        break;
    case 'agendas':
        require_once 'inc/agenda/agenda.inc.php';
        break;
	case 'archive':
		include ('inc/jdc/archivesJdc.inc.php');
		break;
	case 'forum':
		require_once 'inc/forum/gestForums.php';
		break;
    default:
        require_once 'inc/news.php';
        break;
}

//
// ----------------------------------------------------------------------------

$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('executionTime', round($chrono->stop(), 6));

$smarty->display('index.tpl');
