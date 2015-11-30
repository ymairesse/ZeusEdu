<?php
$selectProf = isset($_POST['selectProf'])?$_POST['selectProf']:Null;
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$date = isset($_POST['date'])?$_POST['date']:Null;

$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$matricule2 = isset($_POST['matricule2'])?$_POST['matricule2']:Null;
// on prend la valeur de $matricule (le sélecteur d'élèves de la classe sélectionnée) ou de $matricule2 (la liste automatique)
$matricule = ($matricule!='')?$matricule:$matricule2;
$smarty->assign('matricule',$matricule);

if ($matricule2 != Null) {
	// récuperer la classe de l'élève si le matricule provient de la liste autocompletée
	$detailsEleve = $Ecole->nomPrenomClasse($matricule2);
	$classe = $detailsEleve['classe'];
	}

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes',$listePeriodes);

switch ($mode) {
	case 'parDate':
		$date = isset($_POST['date'])?$_POST['date']:strftime("%d/%m/%Y");
		$smarty->assign('date',$date);
		$statutsAbs = array(
				// 'liste1'=> array('signale','justifie','sortie'),
				'liste1'=> array('signale','sortie','renvoi','suivi','ecarte'),
				'liste2'=>array('absent')
				);
		$smarty->assign('statutsAbs',$statutsAbs);
		$listesParDate = $Presences->listePresencesDate($date, $statutsAbs);

		$smarty->assign('liste1',$listesParDate['liste1']);
		$smarty->assign('liste2',$listesParDate['liste2']);
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('selecteur','selectDate');
		$smarty->assign('corpsPage', 'listeParDate');
		break;
	case 'parEleve':
		$smarty->assign('classe',$classe);
		$listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
		$smarty->assign('listeEleves',$listeEleves);
		$listeClasses = $Ecole->listeGroupes();
		$smarty->assign('listeClasses', $listeClasses);
		$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
		$matricule2 = isset($_POST['matricule2'])?$_POST['matricule2']:Null;
		// on prend la valeur de $matricule (le sélecteur d'élèves de la classe sélectionnée) ou de $matricule2 (la liste automatique)
		$matricule = ($matricule!='')?$matricule:$matricule2;
		$smarty->assign('matricule',$matricule);

		if ($etape == 'showEleve') {
			$prevNext = $Ecole->prevNext($matricule, $listeEleves);
			$smarty->assign('prevNext', $prevNext);
			$listePresences = $Presences->listePresencesEleve($matricule);
			$smarty->assign('listePresences',$listePresences);
			$Eleve = new Eleve($matricule);
			$detailsEleve = $Eleve->getDetailsEleve();
			$smarty->assign('detailsEleve',$detailsEleve);
			$smarty->assign('corpsPage','presencesEleve');
			}
		$smarty->assign('etape','showEleve');
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('selecteur','selectClasseEleve');
		break;
	case 'parClasse':
		$listeClasses = $Ecole->listeClasses();
		$smarty->assign('listeClasses',$listeClasses);
		$smarty->assign('classe',$classe);
		$smarty->assign('date',$date);

		if (($classe != Null) && ($date != Null)) {
			$listeEleves = $Ecole->listeEleves($classe,'groupe');
			$smarty->assign('listeEleves',$listeEleves);
			$listePresences = $Presences->listePresencesElevesDate($date,$listeEleves);
			$smarty->assign('listePresences',$listePresences);
			$smarty->assign('corpsPage','presencesClasse');
			}

		$smarty->assign('action', $action);
		$smarty->assign('mode', $mode);

		$smarty->assign('selecteur','selectClasseDate');
		break;
	}

?>
