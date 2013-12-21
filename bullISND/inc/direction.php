<?php

$classe = isset($_REQUEST['classe'])?$_REQUEST['classe']:Null;
$matricule = isset($_REQUEST['matricule'])?$_REQUEST['matricule']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;

$smarty->assign('classe',$classe);
$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

switch ($mode) {
	case 'competences':
		// rapport de compétences...
		$listeNiveaux = $Ecole->listeNiveaux();
		$smarty->assign("listeNiveaux", $listeNiveaux);
		if (isset($niveau)) {
			$smarty->assign("niveau", $niveau);
			$listeCoursComp = $Bulletin->listeCoursNiveaux($niveau);
			$smarty->assign("listeCoursComp", $listeCoursComp);
			}
		if ($etape == 'enregistrer') {
			$nbResultats = $Bulletin->enregistrerCompetences($_POST);
			$smarty->assign("message", array(
						'title'=>"Enregistrement",
						'texte'=>"$nbResultats compétence(s) modifiée(s)"));
			}

		$listeCompetences = $Bulletin->listeCompetencesListeCours($cours);
		$smarty->assign("listeCompetences", $listeCompetences);
		$smarty->assign("selecteur", "selectNiveauCours");
		$smarty->assign("corpsPage", "adminCompetences");
		break;

	case 'padEleve':
		$listeClasses = $Ecole->listeGroupes(array('G','TT','GT'));
		$smarty->assign('listeClasses',$listeClasses);
		if (isset($classe)) {
			$listeEleves = $Ecole->listeEleves($classe,'groupe');
			$smarty->assign('listeElevesClasse', $listeEleves);
			}

		if (isset($matricule) && ($matricule != '')) {
			// si un matricule est donné, on aura sans doute besoin des données de l'élève
			$eleve = new Eleve($matricule);
			require_once(INSTALL_DIR."/inc/classes/classPad.inc.php");
			$padEleve = new padEleve($matricule, $acronyme);

		if (isset($etape) && ($etape == 'enregistrer')) {
			$nb = $padEleve->savePadEleve($_POST);
			$smarty->assign("message", array(
					'title'=>"Enregistrement",
					'texte'=>"Note enregistrée"));
			}
		$smarty->assign("padEleve", $padEleve);
		$smarty->assign('listeEleves',$listeEleves);
		// recherche des infos personnelles de l'élève
		$smarty->assign("eleve", $eleve->getDetailsEleve());
		// recherche des infos concernant le passé scolaire
		$smarty->assign("ecoles", $eleve->ecoleOrigine());
		$anneeEnCours = substr($classe,0,1);
		$smarty->assign('anneeEnCours', $anneeEnCours);

		// recherche des cotes de situation et délibé éventuelle pour toutes les périodes de l'année en cours
		$listeCoursActuelle = $Bulletin->listeFullCoursGrpActuel($matricule);
		$listeCoursActuelle = $listeCoursActuelle[$matricule];
		
		$syntheseAnneeEnCours = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);
		// tableau de synthèse de toutes les cotes de situation pour toutes les années scolaires
		$syntheseToutesAnnees = $Bulletin->syntheseToutesAnnees($matricule);

		$smarty->assign('listeCoursActuelle', $listeCoursActuelle);
		$smarty->assign('syntheseToutesAnnees', $syntheseToutesAnnees);
		$smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));
		$smarty->assign('mentions', $Bulletin->listeMentions($matricule, Null, Null));

		$prevNext = $Bulletin->prevNext($matricule,$listeEleves);
		$titulaires = $eleve->titulaires($matricule);
		$smarty->assign('matricule',$matricule);
		$smarty->assign('titulaires', $titulaires);
	
		$smarty->assign('prevNext', $prevNext);
		$smarty->assign('etape','enregistrer');
		$smarty->assign('selecteur', 'selectClasseEleve');			
		$smarty->assign('corpsPage', 'ficheEleve');
		}
		$smarty->assign('selecteur', 'selectClasseEleve');
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		break;
	}


?>