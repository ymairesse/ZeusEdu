<?php
$selectProf = isset($_POST['selectProf'])?$_POST['selectProf']:Null;
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;

switch ($mode) {
	case 'parDate':
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
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
		$matricule2 = isset($_POST['matricule2'])?$_POST['matricule2']:Null;
		// on prend la valeur de $matricule (le sélecteur d'élèves de la classe sélectionnée) ou de $matricule2 (la liste automatique)
		$matricule = ($matricule!='')?$matricule:$matricule2;
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
	}	

?>