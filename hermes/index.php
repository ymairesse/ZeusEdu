<?php
require_once("../config.inc.php");
include (INSTALL_DIR.'/inc/entetes.inc.php');

// afficher($_POST, true);
// ----------------------------------------------------------------------------
//
require_once("inc/classes/classHermes.inc.php");
$hermes = new hermes;

switch ($action) {
	case 'mail':
		if ($mode == 'Envoyer') {
			$hermes->send_mail($_POST);
			}
		$listeProfs = $Ecole->listeProfs();
		$listeTitus = $Ecole->listeProfsTitus();
		$listes = array('Tous'=>$listeProfs, 'Titulaires'=>$listeTitus);
		$smarty->assign('listes',$listes);
		$smarty->assign('nbPJ', range(0,9));
		$smarty->assign('NOREPLY', NOREPLY);
		$smarty->assign('action',$action);
		$smarty->assign('mode','Envoyer');
		$smarty->assign('corpsPage','envoiMail');
		break;
	case 'archives':
		echo "archive";
		$smarty->assign('corpsPage','archives');
		break;
}
//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime",round($Application->chrono()-$debut,6));
$smarty->display("index.tpl");

?>
