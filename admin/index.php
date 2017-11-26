<?php

require_once("../config.inc.php");
include (INSTALL_DIR.'/inc/entetes.inc.php');

// ----------------------------------------------------------------------------
//
//
//
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$id = isset($_REQUEST['id'])?$_REQUEST['id']:Null;

require_once (INSTALL_DIR."/inc/classes/classFlashInfo.inc.php");
$flashInfo = new flashInfo();

if ($_SESSION[APPLICATION]->userStatus($module) == 'admin') {
	switch ($action) {
		case 'import':
			include ("inc/import.php");
			break;
		case 'maj':
			include ("inc/maj.php");
			break;
		case 'backup':
			include ("inc/backup.php");
			break;
		case 'clear':
			include ("inc/clear.php");
			break;
		case 'look':
			include ("inc/look.php");
			break;
		case 'gestUsers':
			include ("inc/gestUsers.php");
			break;
		case 'gestEleves':
			include ("inc/gestEleves.php");
			break;
		case 'autres':
			include ("inc/adminAutres.php");
			break;
		case 'news':
			include ("inc/news.php");
			break;
		default:
			// wtf
			break;
		}
	// si rien n'est décidé, présenter la page d'accueil
	if (!isset($smarty->tpl_vars['corpsPage']) && (!isset($smarty->tpl_vars['selecteur']))) {
		$smarty->assign('listeFichiers', $Application->scanDirectories("./save"));
		$smarty->assign('derniersConnectes', $Application->derniersConnectes(60));
		$smarty->assign('corpsPage', 'bilan');
		}
	//
	// ----------------------------------------------------------------------------
	$smarty->assign('INSTALL_DIR', INSTALL_DIR);
	$smarty->assign('executionTime', round($chrono->stop(),6));
	$smarty->display('index.tpl');
	}
	else die ('get out of here');
