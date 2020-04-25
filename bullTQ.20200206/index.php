<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';

// ----------------------------------------------------------------------------
//
require_once 'inc/classes/classBullTQ.inc.php';
$BullTQ = new bullTQ();

$acronyme = $user->getAcronyme();
$smarty->assign('tituTQ', $BullTQ->tituTQ($acronyme));

$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;

switch ($action) {
    case 'bulletin':
        include 'inc/bulletin.inc.php';
        break;
    case 'stages':
        include 'inc/stages/evalStages.inc.php';
        break;
    case 'print':
        include 'inc/print.inc.php';
        break;
    case 'titu':
        include 'inc/titu.inc.php';
        break;
    case 'delibe':
        include 'inc/delibe.inc.php';
        break;
    case 'gestion':
        include 'inc/gestion.inc.php';
        break;
    case 'admin':
        include 'inc/admin.inc.php';
        break;
    case 'news':
        $autorise = array('admin');
        if (in_array($user->userStatus($module), $autorise)) {
            include 'inc/delEditNews.php';
        }
        break;
    default:
        include 'inc/news.php';
        break;
    }

//
// ----------------------------------------------------------------------------
$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('executionTime', round($chrono->stop(), 6));

$smarty->display('index.tpl');
