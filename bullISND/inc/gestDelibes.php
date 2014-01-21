<?php
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$matricule = isset($_REQUEST['matricule'])?$_REQUEST['matricule']:Null;
$classe = isset($_REQUEST['classe'])?$_REQUEST['classe']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$annee = ($classe != Null)?SUBSTR($classe,0,1):Null;

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $user->listeTitulariats();
$listeClasses = $Ecole->listeGroupes($sections=array('G','TT'));

$smarty->assign("listeTitus", $listeTitus);
$smarty->assign("listeClasses", $listeClasses);
$smarty->assign("matricule", $matricule);
$smarty->assign("classe", $classe);
$smarty->assign("annee", $annee);
$smarty->assign("bulletin", $bulletin);
$smarty->assign("nbBulletins", NBPERIODES);
$smarty->assign("action", "delibes");

switch ($mode) {
	case 'individuel':
		$listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
		$smarty->assign("listeEleves", $listeEleves);
		$smarty->assign("bulletin", $bulletin);
		$smarty->assign("classe", $classe);
		$smarty->assign("selecteur", "selectClasseEleve");
		$smarty->assign("action","delibes");
		$smarty->assign("mode","individuel");
		switch ($etape) {
			case 'enregistrer':
				$nb = $Bulletin->enregistrerMentions($_POST);
				$smarty->assign("message", array(
									'title'=>"Enregistrement",
									'texte'=>"$nb mention(s) enregistrée(s)")
									);
				// pas de break;
			case 'showEleve':
				$listePeriodes = explode(',',str_replace(' ','',PERIODESDELIBES));
				$listeCoursEleve = current($Bulletin->listeCoursGrpEleves($matricule, $bulletin));
				$listeSituations = current($Bulletin->listeSituationsCours($matricule, array_keys($listeCoursEleve), null, true));
				$moyenneSituations = $Bulletin->moyennesSituations ($listeSituations, $listePeriodes);
				$mentionsJuinDec = $Bulletin->calculeMentionsDecJuin($moyenneSituations);
				$listeMentions = $Bulletin->listeMentions($matricule,Null,$annee);
				
				$prevNext = $Bulletin->prevNext($matricule,$listeEleves);
				$remarques = $Bulletin->listeCommentairesTousCours($matricule, $listePeriodes);
				$estTitulaire = in_array($classe, $user->listeTitulariats());
				$smarty->assign("estTitulaire",$estTitulaire);
				$smarty->assign("listePeriodes", $listePeriodes);
				$smarty->assign("listeCours", $listeCoursEleve);
				$smarty->assign("listeSituations", $listeSituations);
				$smarty->assign("listeRemarques", $remarques);
				$smarty->assign("matricule", $matricule);
				$smarty->assign("prevNext", $prevNext);
				$smarty->assign("eleve", $Ecole->nomPrenomClasse($matricule));

				$smarty->assign("mentions", $mentionsJuinDec);
				$smarty->assign ("delibe", $moyenneSituations);
				$smarty->assign ("mentionsAttribuees", $listeMentions);
				$smarty->assign("corpsPage", "delibeIndividuel");
				break;
			default:
				// wtf
				break;
			}

		break;	
	case 'synthese':
		$smarty->assign("action","delibes");
		$smarty->assign("mode","synthese");
		$smarty->assign("etape","showCotes");
		// sélecteur incluant la période "0" pour les élèves de 2e
		$smarty->assign("selecteur", "selectBulletin0Classe");
		if (($etape == 'showCotes') && ($classe)) {
			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			$listeCoursGrpListeEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);
			$listeSituations100 = $Bulletin->getSituations100($bulletin, $listeEleves);
			$listeCoursClasse = $Ecole->listeCoursClassePourDelibe($classe);
			
			$smarty->assign("classe",$classe);
			$smarty->assign("listeSituations100", $listeSituations100);
			$smarty->assign("listeCours", $listeCoursClasse);
			$smarty->assign("listeCoursGrpListeEleves",$listeCoursGrpListeEleves);
			$smarty->assign("listeEleves", $listeEleves);
			$smarty->assign("corpsPage","grillePeriode");
			}
		break;
	case 'parClasse':
		$smarty->assign("action","delibes");
		$smarty->assign("mode","parClasse");
		$smarty->assign("etape","showCotes");
		$smarty->assign("laClasse", $classe);
		$smarty->assign("selecteur", "selectBulletinClasse");
		if (($etape == 'showCotes') && ($classe != Null)) {
			$titusClasse = $Ecole->titusDeGroupe($classe);
			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			if (in_array($bulletin, explode(',', str_replace(' ','',PERIODESDELIBES))))
				$listeMentions = $Bulletin->listeMentions($listeEleves,$bulletin,$annee);
				else $listeMentions = Null;
			$listeCoursGrpListeEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);
			$listeCoursGrp = $Ecole->listeCoursGrpClasse($classe);
			$listeCoursClasse = $Ecole->listeCoursClassePourDelibe($classe);
			$situationsActuelles = $Bulletin->listeSituationsClassePourDelibe($listeEleves, $bulletin);
			$delibe = $Bulletin->echecMoyennesDecisions($listeEleves, $listeCoursGrp, $bulletin);
			$smarty->assign("delibe",$delibe);
			$smarty->assign("listeEleves", $listeEleves);
			$smarty->assign("listeCoursGrpListeEleves",$listeCoursGrpListeEleves);
			$smarty->assign("listeSituations", $situationsActuelles);
			$smarty->assign("selectClasse", $classe);
			$smarty->assign("titusClasse", $titusClasse);
			$smarty->assign("listeCours", $listeCoursClasse);
			$smarty->assign("listeMentions",$listeMentions);
			$smarty->assign("corpsPage", "feuilleDelibes");
			}
		break;
	
	default: "missing mode";
	}
?>
