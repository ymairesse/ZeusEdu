<?php
require_once("../config.inc.php");
include (INSTALL_DIR.'/inc/entetes.inc.php');

// ----------------------------------------------------------------------------
//
require_once("inc/classes/classPresences.inc.php");
$Presences = new Presences();

$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;

switch ($action) {
	case 'admin':
		include('inc/gestAdmin.inc.php');
		break;
	case 'presences':
		include('inc/gestPresences.inc.php');
		break;
	case 'listeAbsences':
		include ('inc/gestAbsences.inc.php');
		break;
	default:
		include('inc/gestPresences.inc.php');
		break;
	}

//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime",round($Application->chrono()-$debut,6));
$smarty->display ("index.tpl");
?>
