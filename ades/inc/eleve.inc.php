<?php

// récupérer l'onglet précédemment actif
$onglet = isset($_POST['onglet']) ? $_POST['onglet'] : 0;
$smarty->assign('onglet', $onglet);

// priorité au $_GET
$matricule = isset($_GET['matricule']) ? $_GET['matricule'] : Null;
if ($matricule == Null)
	$matricule = Application::postOrCookie('matricule', $unAn);
$smarty->assign('matricule',$matricule);

$classe = Application::postOrCookie('classe', $unAn);

$listeClasses = $Ecole->listeGroupes();

switch ($mode) {
	case 'trombinoscope':
		$smarty->assign('lesGroupes', $listeClasses);
		$smarty->assign('classe', $classe);
		$smarty->assign('selecteur', 'selecteurs/selectClasse');
		$smarty->assign('corpsPage', 'eleve/pageEleve');
		break;

	default:
		if ($classe != Null) {
			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
		}
		else $listeEleves = Null;

		$smarty->assign('listeEleves', $listeEleves);
		$smarty->assign('listeClasses', $listeClasses);
		$smarty->assign('classe', $classe);
		$smarty->assign('selecteur', 'selecteurs/selectClasseEleve');
		$smarty->assign('corpsPage', 'eleve/pageEleve');
		break;
	}
