<?php
// prise de présence par élève isolé
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$matricule2 = isset($_POST['matricule2'])?$_POST['matricule2']:Null;
// on prend la valeur de $matricule (le sélecteur d'élèves de la classe sélectionnée) ou de $matricule2 (la liste automatique)
$matricule = ($matricule!='')?$matricule:$matricule2;
$smarty->assign('matricule',$matricule);

$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$smarty->assign('classe',$classe);

$listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
$smarty->assign('listeEleves',$listeEleves);

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);

if ($etape == 'enregistrer') {
	if ($matricule) {
		$listeEleves = array($matricule=>$matricule);
		$nb = $Presences->savePresences($_POST, $listeEleves, $listePeriodes);
		$smarty->assign('message', array(
			'title'=> SAVE,
			'texte'=>sprintf(NBSAVE,$nb)
			));
			}
	}
	if (isset($date) && ($matricule != '')) {
		$listePresences = $Presences->listePresencesElevesDate($date,$matricule);
		$smarty->assign('listePresences',$listePresences);
		$detailsEleve = $Ecole->detailsDeListeEleves($matricule);
		$smarty->assign('detailsEleve', $detailsEleve);
		$smarty->assign('identite',$user->identite());
		$smarty->assign('etape','enregistrer');
		$smarty->assign('corpsPage','feuillePresencesEleve');
		}
		
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);
$smarty->assign('selecteur','selectDateClasseEleve');
?>
