<?php
require_once("../config.inc.php");
include (INSTALL_DIR.'/inc/entetes.inc.php');

// ----------------------------------------------------------------------------
//
require_once("inc/classes/classPresences.inc.php");
$Presences = new Presences();

$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;

$acronyme = $user->getAcronyme();
$smarty->assign('user',$acronyme);

switch ($action) {
	case 'presences':
		include('inc/gestPresences.inc.php');
		break;
	case 'listes':
		include ('inc/gestListes.inc.php');
		break;
	case 'autorisations':
		include('inc/autorisations.inc.php');
		break;
	case 'signalements':
		include ('inc/signalements.inc.php');
		break;
	case 'admin':
		include('inc/gestAdmin.inc.php');
		break;
	}

//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime", round($chrono->stop(),6));
$smarty->display ("index.tpl");
?>
