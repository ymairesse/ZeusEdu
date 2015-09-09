<?php
 if (isset($matricule)) {
	switch ($mode) {
		case 'medical':
			$smarty->assign('medicEleve',$infirmerie->getMedicEleve($matricule));
			$smarty->assign('action',$action);
			$smarty->assign('mode',$mode);
			$smarty->assign('corpsPage','modifMedical');
			break;
		case 'visite':
			// modifier les données d'une visite à l'infirmerie
			$smarty->assign('listeProfs', $Ecole->listeProfs());
			if ($consultID) { // c'est une modification d'une visite existante
				$smarty->assign('consultID',$consultID);
				$smarty->assign('visites',$infirmerie->getVisitesEleve($matricule, $consultID));
				}
				else { // c'est une nouvelle visite
					$smarty->assign('visites',Null);
					}
			$smarty->assign('action',$action);
			$smarty->assign('mode',$mode);
			$smarty->assign('corpsPage','modifVisite');
			break;
		case 'infoMedicale':
			$infoMedicale = isset($_POST['infoMedicale'])?$_POST['infoMedicale']:'';
			if ($etape == 'enregistrer') {
				$nb = $infirmerie->saveInfoMedic($matricule,$infoMedicale);
				$smarty->assign('message',array(
					'title'=>SAVE,
					'texte'=>"$nb information(s) enregistrée(s)",
					'urgence'=>'success'
					));
				$smarty->assign('medicEleve',$infirmerie->getMedicEleve($matricule));
				$smarty->assign('consultEleve',$infirmerie->getVisitesEleve($matricule));
				$smarty->assign('selecteur','selectClasseEleve');
				$smarty->assign('corpsPage','ficheEleve');
				}
				else {
					$smarty->assign('infoMedicale',$infoMedicale);
					$smarty->assign('corpsPage','modifInfoMedicale');
					}
			break;
		}
 }
?>
