<?php
$selectProf = isset($_POST['selectProf'])?$_POST['selectProf']:Null;
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;

switch ($mode) {
	case 'parDate':
		$smarty->assign('action', 'listeAbsences');
		$smarty->assign('mode','parDate');
		$smarty->assign('etape','dateChoisie');
		$smarty->assign('selecteur', 'selectDate');
		$date = isset($_POST['date'])?$_POST['date']:strftime("%d/%m/%Y");
		$smarty->assign('date',$date);
		if ($etape == 'dateChoisie') {
			$listeParDate = $Presences->listeParDate($date);
			$listePeriodes = $Presences->lirePeriodesCours();
			$smarty->assign("listePeriodes",$listePeriodes);
			$smarty->assign("listeAbsences", $listeParDate);
			$smarty->assign("corpsPage", "listeParDate");
		}
		break;
	case 'parEleve':
		$classe = isset($_POST['classe'])?$_POST['classe']:Null;
		$smarty->assign('classe',$classe);
		$listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
		$smarty->assign('listeEleves',$listeEleves);
		$listeClasses = $Ecole->listeGroupes();
		$smarty->assign("listeClasses", $listeClasses);
		$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
		$smarty->assign('matricule',$matricule);
		
		switch ($etape) {
			case 'showEleve':
				$prevNext = $Ecole->prevNext($matricule, $listeEleves);
				$smarty->assign('prevNext', $prevNext);
				$listeAbsences = $Presences->absencesEleve($matricule);
				$smarty->assign('listeAbsences',$listeAbsences);
				$Eleve = new Eleve($matricule);
				$detailsEleve = $Eleve->getDetailsEleve();
				$nomEleve = $detailsEleve['prenom']." ".$detailsEleve['nom'];
				$smarty->assign('nomEleve',$nomEleve);
				$listePeriodes = $Presences->lirePeriodesCours();
				$smarty->assign('listePeriodes',$listePeriodes);
				$smarty->assign('corpsPage','absencesEleve');

				break;
			default:
				$smarty->assign('etape','showEleve');
				}
		$smarty->assign('action', $action);
		$smarty->assign('mode', $mode);
		$smarty->assign('selecteur','selectClasseEleve');
		break;
	case 'enregistrer':
		if ($coursGrp)
			$listeEleves = $Ecole->listeElevesCours($coursGrp,'alpha');
		$nb = $Presences->enregistrerAbsences($_POST, $listeEleves);
		$smarty->assign("message", array(
					'title'=> SAVE,
					'texte'=>sprintf(NBSAVE,$nb)
					));
		// break;	pas de break
	default:
		$listePeriodes = $Presences->lirePeriodesCours();
		$smarty->assign("listePeriodes",$listePeriodes);
		$smarty->assign("lesPeriodes", range(1, count($listePeriodes)));
		
		$freePeriode = isset($_POST['freePeriode'])?$_POST['freePeriode']:Null;
		// retrouver la période actuelle à partir de l'heure ou accepter l'heure si heure libre souhaitée
		if ($freePeriode == Null)
			$periode = $Presences->periodeActuelle($listePeriodes);
			else $periode = isset($_POST['periode'])?$_POST['periode']:Null;
			
		$freeDate = isset($_POST['freeDate'])?$_POST['freeDate']:Null;
		// retrouver la date de travail à partir de la date du jour ou accepter la date postés si date libre souhaitée
		if ($freeDate == Null) 
			$date = strftime("%d/%m/%Y");
			else $date = isset($_POST['date'])?$_POST['date']:Null;
		
		$jourSemaine = strftime('%A',$Application->dateFR2Time($date));
			
		if ($selectProf) {
			$smarty->assign("selectProf", $selectProf);
			$listeCoursGrp = $Ecole->listeCoursProf($selectProf);
				if ($coursGrp) {
					if (!(isset($listeEleves))) {
						// si on a enregistré, $listeEleves est déjà connu
						$listeEleves = $Ecole->listeElevesCours($coursGrp,'alpha');
						}
					// diviser la liste en deux sous-listes dont la première est éventuellement plus longue d'une unité
					$listeDouble = array_chunk($listeEleves, 2, true);
					$nbLignes = range(0,count($listeDouble)-1);
					
					$smarty->assign('listeDouble', $listeDouble);
					$smarty->assign('nbLignes',range(0,count($listeDouble)-1));
					$smarty->assign('nbEleves',count($listeEleves));
					$smarty->assign('corpsPage', 'feuilleAbsences');
				}
			}
			else $listeCoursGrp = Null;
		$smarty->assign("listeProfs", $Ecole->listeProfs(true));
		$smarty->assign("date",$date);
		$smarty->assign("listeCoursGrp", $listeCoursGrp);
		$smarty->assign('freeDate', $freeDate);
		$smarty->assign("freePeriode",$freePeriode);
		$smarty->assign("periode",$periode);
		$smarty->assign("jourSemaine",$jourSemaine);
		$smarty->assign("selecteur", "selectHeureProfCours");
		if ($coursGrp) {
			$listeAbsences = $Presences->lireAbsences($date, $coursGrp);
			$smarty->assign("coursGrp", $coursGrp);
		}
		$listeAbsences = isset($listeAbsences)?$listeAbsences:Null;
		$smarty->assign("listeAbsences", $listeAbsences);
		break;
}	

?>