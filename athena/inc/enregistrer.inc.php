<?php
if (isset($matricule)) {
	switch ($mode) {
		case 'medical':
			$nb = $infirmerie->enregistrerMedical($_POST);
			$message = array(
				'title'=>SAVE,
				'texte'=>sprintf('Enregistrement de: %d fiche',$nb),
				'urgence'=>'success'
				);
			$smarty->assign('message',$message);
			break;
		case 'visite':
			$nb = $infirmerie->enregistrerVisite($_POST);
			$message = array(
				'title'=>SAVE,
				'texte'=>sprintf('Enregistrement de: %d visite',$nb),
				'urgence'=>'success'
				);
			$smarty->assign("message", $message);
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
