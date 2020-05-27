<?php

require_once("../config.inc.php");
include (INSTALL_DIR.'/inc/entetes.inc.php');

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$onglet = isset($_POST['onglet'])?$_POST['onglet']:0;
$smarty->assign('onglet',$onglet);

// ----------------------------------------------------------------------------
//
require_once("inc/classes/classHermes.inc.php");
$hermes = new hermes;

$acronyme = $user->getAcronyme();
$smarty->assign('acronyme',$acronyme);

switch ($action) {
	case 'Envoyer':
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
		if (in_array($userStatus, array('admin', 'direction', 'educ'))){
			$listeProfs = $hermes->listeMailingProfs();
			$listeTitus = $hermes->listeMailingTitulaires();
			$listeDirection = $hermes->listeDirection();
			$smarty->assign('listeProfs',$listeProfs);
			$smarty->assign('listeTitus',$listeTitus);
			$smarty->assign('listeDirection',$listeDirection);
		}
		$listesAutres = $hermes->listesPerso($acronyme);

		$smarty->assign('listesAutres',$listesAutres);
		$smarty->assign('nbPJ', range(0,9));	// nombre max de pièces jointes autorisées
		$smarty->assign('NOREPLY', NOREPLY);
		$smarty->assign('NOMNOREPLY', NOMNOREPLY);
		$smarty->assign('action','Envoyer');
		$smarty->assign('corpsPage','envoiMail');
	}

//
// ----------------------------------------------------------------------------
$smarty->assign('executionTime', round($chrono->stop(),6));
$smarty->display('index.tpl');
