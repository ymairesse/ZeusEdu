<?php

$section = 'TQ';

$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$cours = isset($_POST['cours'])?$_POST['cours']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;

$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODETQ;

switch ($mode) {

	case 'imagesCours':
		$listeImages = $BullTQ->imagesPngBranches(200);
		$smarty->assign("listeImages", $listeImages);
		$smarty->assign("corpsPage", "imagesCours");
		break;

	case 'initialiser':
		if ($userStatus != 'admin') die('get out of here');
		$listeEleves = $Ecole->getEleves4section($section);
		$smarty->assign('listeEleves', $listeEleves);
		$smarty->assign('corpsPage', 'admin/initBulletin');
		break;

	case 'competences':
		if ($userStatus != 'admin') die('get out of here');
		$listeNiveaux = $BullTQ->listeNiveaux4section($section);
		$smarty->assign('listeNiveaux', $listeNiveaux);
		if (isset($niveau)) {
			$smarty->assign('niveau', $niveau);
			$listeCoursComp = $BullTQ->listeCoursNiveaux($niveau);
			$smarty->assign('listeCoursComp', $listeCoursComp);
		}
		if ($etape == 'enregistrer') {
			$nbResultats = $BullTQ->enregistrerCompetences($_POST);
			$smarty->assign("message", array(
						'title'=>"Enregistrement",
						'texte'=>"$nbResultats compétence(s) modifiée(s)"));
			}
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('cours',$cours);
		$listeCompetences = $BullTQ->listeCompetencesListeCours($cours);
		$smarty->assign('listeCompetences', $listeCompetences);
		$smarty->assign('corpsPage', 'admin/adminCompetences');
		// $smarty->assign('selecteur', 'selecteurs/selectNiveauCours');
		break;

	case 'typologie':
		if ($niveau != Null) {
			if ($etape == 'enregistrer') {
				$nbResultats = $BullTQ->enregistrerTypes($_POST)/2;
				$smarty->assign('message', array(
						'title'=>"Enregistrement",
						'texte'=>"$nbResultats types(s) modifié(s)",
						'urgence'=>'warning'));
				}
			$listeCours = $BullTQ->listeCoursNiveaux($niveau);
			$listeCoursTypes = $BullTQ->listeTypes($listeCours);
			$smarty->assign('etape','enregistrer');
			$smarty->assign('listeCoursTypes',$listeCoursTypes);
			$smarty->assign('corpsPage','editTypesCours');
			}
		$listeNiveaux = $BullTQ->listeNiveaux4section($section);
		$smarty->assign('listeNiveaux', $listeNiveaux);

		$smarty->assign('niveau',$niveau);
		$smarty->assign('selecteur','selecteurs/selectNiveau');
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		break;

	case 'titulaires':
		if (isset($niveau)) {
			$smarty->assign('listeProfs',$Ecole->listeProfs());
			$listeAcronymes = isset($_POST['listeAcronymes'])?$_POST['listeAcronymes']:Null;
			switch ($etape) {
				case 'supprimer':
					$nb = $Ecole->supprTitulariat($niveau,$listeAcronymes);
					$smarty->assign('message', array(
								'title'=>'Suppression',
								'texte'=>"$nb modification(s) enregistrée(s).")
								);
					break;
				case 'ajouter':
					$nb = $Ecole->addTitulariat($niveau,$listeAcronymes,'TQ');
					$smarty->assign('message', array(
								'title'=>'Ajouts',
								'texte'=>"$nb modification(s) enregistrée(s).")
								);
					break;
				}
			$listeTitus = $Ecole->titusDeGroupe($niveau);
			$smarty->assign('listeTitus',$listeTitus);
			}

		$smarty->assign('listeNiveaux',$Ecole->listeGroupes(array('TQ')));
		$smarty->assign('selecteur','selecteurs/selectNiveau');
		$smarty->assign('corpsPage','choixTitu');
		$smarty->assign('niveau',$niveau);
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		break;

	case 'stages':
		$smarty->assign('classe', $classe);
		require_once 'inc/stages.inc.php';
		break;

	case 'config':
        $listeConfig = $Application->lireParametres('bullTQ');
        $smarty->assign('listeConfig', $listeConfig);
        $smarty->assign('corpsPage', 'admin/paramBulletin');
        break;

	default:
		break;
	}

?>
