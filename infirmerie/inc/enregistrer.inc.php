<?php
if (isset($matricule)) {
	switch ($mode) {
		case 'medical':
			$nb = $infirmerie->enregistrerMedical($_POST);
			$smarty->assign("message", array(
				'title'=>SAVE,
				'texte'=>"Enregistrement de: $nb fiche"),
				3000);
			break;
		case 'visite':
			$nb = $infirmerie->enregistrerVisite($_POST);
			$smarty->assign("message", array(
				'title'=>SAVE,
				'texte'=>"Enregistrement de: $nb visite"),
				3000);
			break;
		}
	$smarty->assign('medicEleve',$infirmerie->getMedicEleve($matricule));
	$smarty->assign('consultEleve',$infirmerie->getVisitesEleve($matricule));
	$smarty->assign('classe',$classe);
	$action = 'ficheEleve';
	$mode = 'wtf';
	$smarty->assign('corpsPage', 'ficheEleve');
}
?>