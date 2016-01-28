<?php
$smarty->assign('action',$action);
$smarty->assign('mode', $mode);

$cours = isset($_POST['cours'])?$_POST['cours']:Null;
$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;

$smarty->assign('niveau',$niveau);
$smarty->assign('listeNiveaux', $Ecole::listeNiveaux());

switch ($mode) {
	case 'matieres':
		if ($etape == 'enregistrer') {
			$nb_cours = $Ecole->enregistrerMatiere($_POST);
			$smarty->assign("message",
				array(
					'title'=>SAVE,
					'texte'=>sprintf(NBSAVE,$nb_cours[0]),
					'urgence'=>'info')
				);
			$cours = $nb_cours[1];
		}
		$smarty->assign('cours', $cours);
		// le cours est-il orphelin? Auquel cas il peut être modifié
		$smarty->assign('fullEditable', in_array($cours, $Ecole->listOrphanCours()));

		$smarty->assign('detailsCours', $Ecole->detailsCours($cours));
		$smarty->assign('listeFormes', $Ecole->listeFormes());
		$smarty->assign('listeSections',$Ecole->listeSections());
		$smarty->assign('listeNiveaux', $Ecole->listeNiveaux());
		$listeMatieres = isset($niveau)?$Ecole->listeCours($niveau):Null;
		$smarty->assign('listeMatieres', $listeMatieres);
		$smarty->assign('listeCadresStatuts', $Ecole->listeCadresStatuts());
		$smarty->assign('selecteur', 'selectNiveauMatiere');
		$smarty->assign('corpsPage','editMatiere');
		break;
	
	case 'deleteCours':
		echo "delete";
		$nb = $Bulletin->deleteOrphanCours($cours);
		$smarty->assign('message',
				array(
					'title'=>'Suppression',
					'texte'=>"$nb cours supprimé(s)",
					'urgence'=>'info')
					);
		$cours = Null;
		$smarty->assign('mode','editCours');
		// break;  pas de break, on continue sur l'édition
		
	case 'editCours':
		if ($etape == 'enregistrer') {
			$groupe = isset($_POST['groupe'])?$_POST['groupe']:Null;
			$profs = isset($_POST['profs'])?$_POST['profs']:Null;
			if ($profs && $groupe) {
				$coursGrp = $cours.'-'.$groupe;
				$nbInsert = 0;
				$nbInsert = $Ecole->ajouterProfsCoursGrp($profs, $coursGrp);
				$smarty->assign("message",
								array(
									'title'=>SAVE,
									'texte'=>sprintf(NBSAVE,$nbInsert),
									'urgence'=>'success'
									)
								);
					}
			}
		$smarty->assign('listeProfs', $Ecole->listeProfs());
		if (isset($niveau)) {
			$listeMatieres = $Ecole->listeCours($niveau);
			$smarty->assign('listeMatieres', $listeMatieres);
			}
		if (isset($cours)) {
			$listeCoursGrp = $Ecole->listeCoursGrpDeCours($cours);
			$smarty->assign('listeCoursGrp', $listeCoursGrp);
			$smarty->assign('cours', $cours);
			$smarty->assign('corpsPage','tableauMatieres');
			}
		$smarty->assign('selecteur', 'selectNiveauMatiere');
		break;
	default:
		$smarty->assign('listeNiveaux', $Ecole::listeNiveaux());
		$smarty->assign('selecteur', 'selectNiveauMatiere');

		break;	

	}

?>


