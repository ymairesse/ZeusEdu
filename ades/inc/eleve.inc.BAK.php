<?php

// récupérer l'onglet précédemment actif
$onglet = isset($_POST['onglet']) ? $_POST['onglet'] : 0;
$smarty->assign('onglet', $onglet);

// priorité au $_GET
$matricule = isset($_GET['matricule']) ? $_GET['matricule'] : Null;
if ($matricule == Null)
	$matricule = Application::postOrCookie('matricule', $unAn);
$smarty->assign('matricule',$matricule);

$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : Null;

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

switch ($mode) {
	case 'trombinoscope':
		$smarty->assign('lesGroupes', $Ecole->listeGroupes());
		$smarty->assign('etape', 'showEleve');
		$smarty->assign('selecteur','selecteurs/selectClasse');
		if (($etape == 'showEleve') && isset($classe)) {
			$listeElevesClasse = $Ecole->listeEleves($classe,'groupe');
			$smarty->assign('classe',$classe);
			$smarty->assign('tableauEleves', $listeElevesClasse);
			$smarty->assign('corpsPage','trombinoscope');
		}
		$afficherEleve = (isset($matricule))?true:Null;
		break;

	case 'savePad':
		require_once(INSTALL_DIR."/inc/classes/classPad.inc.php");
		$padEleve = new padEleve($matricule,'ades');
		$nb = $padEleve->savePadEleve($_POST);
		$smarty->assign('message', array(
				'title'=>'Enregistrement',
				'texte'=>"$nb note enregistrée",
				'urgence'=>'success'));
		$smarty->assign('listeClasses', $Ecole->listeGroupes());
		if (isset($classe))
			$smarty->assign('listeEleves', $Ecole->listeEleves($classe));
		$mode = 'selection';
		$smarty->assign('selecteur','selecteurs/selectClasseEleve');
		$afficherEleve = true;
		break;

	case 'classeEleve':
		$smarty->assign('listeClasses', $Ecole->listeGroupes());
		$smarty->assign('selecteur','selecteurs/selectClasseEleve');
		if (isset($matricule) && ($matricule != '') && isset($classe) && ($classe != '')) {
			$afficherEleve = true;
			}
			else {
				// peuvent voir le mémo
				$autorise = array('educ','admin','direction');
				if (in_array($userStatus,$autorise)) {
					require_once (INSTALL_DIR."/inc/classes/classFlashInfo.inc.php");
					$flashInfo = new flashInfo();
					$appli = $Application->repertoireActuel();
					$flash = $flashInfo->listeFlashInfos($appli);
					$smarty->assign('flashInfos', $flash);
					$smarty->assign('corpsPage', 'news');
					}
				}
		break;
	}
