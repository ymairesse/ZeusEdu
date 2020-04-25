<?php

require_once("../config.inc.php");
include (INSTALL_DIR.'/inc/entetes.inc.php');

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$onglet = isset($_POST['onglet'])?$_POST['onglet']:0;
$smarty->assign('onglet',$onglet);

// ----------------------------------------------------------------------------
//
require_once 'inc/classes/classHermes.inc.php';
$Hermes = new Hermes;

$acronyme = $user->getAcronyme();
$unRead = $Hermes->unreadMessages4User($acronyme);

$smarty->assign('acronyme',$acronyme);
$smarty->assign('unRead', $unRead);

switch ($action) {
	case 'notifications':
		require_once 'inc/notifications.inc.php';
		break;
	case 'envoiMessages':
		require_once ('inc/envoyer.inc.php');
		break;
	case 'archives':
		require_once ('inc/archives.inc.php');
		break;
	case 'gestion':
		require_once ('inc/gestion.inc.php');
		break;
	case 'preferences':
		require_once ('inc/preferences.inc.php');
		break;
	default:
		require_once 'inc/notifications.inc.php';
		break;
	}

//
// ----------------------------------------------------------------------------
$smarty->assign('executionTime', round($chrono->stop(),6));
$smarty->display('index.tpl');
