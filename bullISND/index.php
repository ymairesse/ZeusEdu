<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';

// ----------------------------------------------------------------------------
//

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

require_once 'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$acronyme = $user->getAcronyme();

$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
$smarty->assign('etape', $etape);

$smarty->assign('corpsPage', null);
$smarty->assign('selecteur', null);

switch ($action) {
    case 'init':
        include 'inc/init.inc.php';
        break;
    case 'ecran':
        include 'inc/gestEcran.php';
        break;
    case 'gestionCotes':
        // aperçu des cotes pour un cours
        include 'inc/gestCotes.php';
        break;
    case 'pdf':
        include 'inc/gestPDF.php';
        break;
    case 'direction':
        include 'inc/direction.php';
        break;
    case 'parEcole':
        include 'inc/gestEcoles.php';
        break;
    case 'educ':
        // notes des éducateurs dans le bulletin
        include 'inc/gestEduc.php';
        break;
    case 'nota':
        // notes des coordinateurs dans le bulletin
        include 'inc/gestNotas.php';
        break;
    case 'gestEncodageBulletins':
        // encodage des bulletins par les profs des différentes branches
        include 'inc/gestEncodageBulletins.php';
        break;
    case 'gestEprExternes':
        // encodage des points des épreuves externes
        include 'inc/gestEprExternes.php';
        break;
    case 'gestSituations':
        include 'inc/gestSituations.php';
        break;
    case 'gestionBaremes':
        include 'inc/gestBaremes.php';
        break;
    case 'delibes':
        include 'inc/gestDelibes.php';
        break;
    case 'admin':
        include 'inc/admin.php';
        break;
    case 'gestCours':
        include 'inc/gestcours.php';
        break;
    case 'titu':
        include 'inc/gestTitus.php';
        break;
    case 'carnet':
        include 'inc/carnet.php';
        break;
    case 'news':
        if ($user->userStatus($module) == 'admin') {
            include 'inc/delEditNews.php';
        }
        break;
    default:
        include 'inc/news.php';
        break;
    }

$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('executionTime', round($chrono->stop(), 6));

$smarty->display('index.tpl');
