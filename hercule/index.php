<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';

// ----------------------------------------------------------------------------
//

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

require_once '../bullISND/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$acronyme = $user->getAcronyme();

$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
$smarty->assign('etape', $etape);

$smarty->assign('corpsPage', null);
$smarty->assign('selecteur', null);


include 'inc/direction.php';


$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('executionTime', round($chrono->stop(), 6));

$smarty->display('index.tpl');
