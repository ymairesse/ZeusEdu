<?php
$unAn = time() + 365*24*3600;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;

if (isset($_POST['classe'])) {
	$classe = $_POST['classe'];
	setcookie('classe',$classe,$unAn, null, null, false, true);
	}
	else $classe = $_COOKIE['classe'];
$smarty->assign('classe', $classe);

if (isset($_POST['matricule'])) {
	$matricule = $_POST['matricule'];
	setcookie('matricule',$matricule,$unAn, null, null, false, true);
	}
	else $matricule = $_COOKIE['matricule'];
$smarty->assign('matricule', $matricule);

$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$annee = ($classe != Null)?SUBSTR($classe,0,1):Null;

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $user->listeTitulariats();
$listeClasses = $Ecole->listeGroupes($sections=array('G','TT', 'S'));

$smarty->assign('listeTitus', $listeTitus);
$smarty->assign('listeClasses', $listeClasses);

$smarty->assign('annee', $annee);
$smarty->assign('bulletin', $bulletin);
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('action', 'delibes');

switch ($mode) {
	case 'individuel':
		$listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
		$smarty->assign('listeEleves', $listeEleves);
		$smarty->assign('bulletin', $bulletin);
		$smarty->assign('selecteur','selectClasseEleve');
		$smarty->assign('action','delibes');
		$smarty->assign('mode','individuel');
		switch ($etape) {
			case 'enregistrer':
				$nb = $Bulletin->enregistrerMentions($_POST);
				$smarty->assign('message', array(
									'title'=>'Enregistrement',
									'texte'=>"$nb mention(s) enregistrée(s)")
									);
				// pas de break;
			case 'showEleve':
				$listePeriodes = explode(',',str_replace(' ','',PERIODESDELIBES));
				$listeCoursEleve = current($Bulletin->listeCoursGrpEleves($matricule, $bulletin));
				$listeSituations = current($Bulletin->listeSituationsCours($matricule, array_keys($listeCoursEleve), null, true));
				// s'il s'agit du dernier bulletin de l'année, on traite l'épreuve externe
				if ($bulletin == NBPERIODES)
					$listeSituations = $Bulletin->eleveSitDelibeExternes($matricule, $listeSituations);
				$moyenneSituations = $Bulletin->moyennesSituations($listeSituations, $listePeriodes);
				$mentionsJuinDec = $Bulletin->calculeMentionsDecJuin($moyenneSituations);
				$listeMentions = $Bulletin->listeMentions($matricule,Null,$annee);
				
				$prevNext = $Bulletin->prevNext($matricule,$listeEleves);
				$remarques = $Bulletin->listeCommentairesTousCours($matricule, $listePeriodes);
				$estTitulaire = in_array($classe,$user->listeTitulariats());
				$smarty->assign('estTitulaire',$estTitulaire);
				$smarty->assign('listePeriodes',$listePeriodes);
				$smarty->assign('listeCours',$listeCoursEleve);
				$smarty->assign('listeSituations',$listeSituations);
				$smarty->assign('listeRemarques', $remarques);
				$smarty->assign('prevNext',$prevNext);
				$smarty->assign('eleve',$Ecole->nomPrenomClasse($matricule));

				$smarty->assign('mentions',$mentionsJuinDec);
				$smarty->assign ('delibe',$moyenneSituations);
				$smarty->assign ('mentionsAttribuees',$listeMentions);
				$smarty->assign('corpsPage','delibeIndividuel');
				break;
			default:
				// wtf
				break;
			}

		break;	
	case 'synthese':
		$smarty->assign('action','delibes');
		$smarty->assign('mode','synthese');
		$smarty->assign('etape','showCotes');
		// sélecteur incluant la période '0' pour les élèves de 2e
		$smarty->assign('selecteur', 'selectBulletin0Classe');
		if (($etape == 'showCotes') && ($classe)) {
			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			$listeCoursGrpListeEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);
			$listeSituations100 = $Bulletin->getSituations100($bulletin, $listeEleves);
			$listeCours = $Ecole->listeCoursClassePourDelibe($classe);
			
			// $smarty->assign('classe',$classe);
			$smarty->assign('listeSituations100', $listeSituations100);
			$smarty->assign('listeCours', $listeCours);
			$smarty->assign('listeCoursGrpListeEleves',$listeCoursGrpListeEleves);
			$smarty->assign('listeEleves', $listeEleves);
			$smarty->assign('corpsPage','grillePeriode');
			}
		break;
	case 'parClasse':
		$smarty->assign('action','delibes');
		$smarty->assign('mode','parClasse');
		$smarty->assign('etape','showCotes');
		$smarty->assign('selecteur', 'selectBulletinClasse');

		if (($etape == 'showCotes') && ($classe != Null)) {

			$titusClasse = $Ecole->titusDeGroupe($classe);

			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			if (in_array($bulletin, explode(',', str_replace(' ','',PERIODESDELIBES))))
				$listeMentions = $Bulletin->listeMentions($listeEleves,$bulletin,$annee);
				else $listeMentions = Null;
			$listeCoursGrpListeEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);
			$listeCoursListeEleves = $Bulletin->listeCoursSansGrp($listeCoursGrpListeEleves);
			$listeCoursGrp = $Ecole->listeCoursGrpClasse($classe);
			$listeCours = $Ecole->listeCoursClassePourDelibe($classe);

			$listeSituations = $Bulletin->listeSituationsDelibe($listeEleves, array_keys($listeCoursGrp), $bulletin);
			// À LA DERNIÈRE PÉRIODE DE L'ANNÉE, ON TIENT COMPTE DES ÉPREUVES EXTERNES ÉVENTUELLES
			if ($bulletin == NBPERIODES)
				$listeSituations = $Bulletin->listeSitDelibeExternes($listeSituations, $listeEleves, $listeCoursGrp);
			$delibe = $Bulletin->echecMoyennesDecisions($listeSituations);
			$smarty->assign('delibe',$delibe);
			$smarty->assign('listeEleves', $listeEleves);
			$smarty->assign('listeCoursListeEleves',$listeCoursListeEleves);
			$smarty->assign('listeCoursGrpListeEleves',$listeCoursGrpListeEleves);
			$smarty->assign('listeSituations', $listeSituations);
			$smarty->assign('selectClasse',$classe);
			$smarty->assign('titusClasse',$titusClasse);
			$smarty->assign('listeCours',$listeCours);
			$smarty->assign('listeMentions',$listeMentions);
			$smarty->assign('corpsPage','feuilleDelibes');
			}
		break;
	
	default: 'missing mode';
	}
?>
