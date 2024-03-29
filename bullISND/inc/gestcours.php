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
		$smarty->assign('corpsPage','editMatiere');
		break;

	case 'editCours':
		if ($etape == 'enregistrer') {
			$groupe = isset($_POST['groupe']) ? $_POST['groupe'] : Null;
			$profs = isset($_POST['profs']) ? $_POST['profs'] : Null;
			$virtuel = isset($_POST['virtuel']) ? 1 : 0;
			$linkedCoursGrp = isset($_POST['linkedCoursGrp']) ? $_POST['linkedCoursGrp'] : Null;

			if ($profs && $groupe) {
				$coursGrp = $cours.'-'.$groupe;
				$nbInsert = 0;
				$nbInsert = $Ecole->ajouterProfsCoursGrp($profs, $coursGrp, $virtuel, $linkedCoursGrp);
				// si le cours est virtuel, attribuer les élèves des cours liés
				if ($virtuel == 1){
					$Ecole->attribuerElevesVirtuels($coursGrp, $linkedCoursGrp);
				}
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
			// Application::afficher($listeMatieres, true);
			$smarty->assign('listeMatieres', $listeMatieres);
			}
		if (isset($cours)) {
			$listeCoursGrp4Eleves = $Ecole->getListeCoursGrp4elevesCours($cours);
			$listeCoursGrp4Profs = $Ecole->getListeCoursGrp4profsCours($cours);
			// pour ce cours, on a donc la liste des coursGrp suivants
			$listeCoursGrp4cours = array_merge($listeCoursGrp4Eleves, $listeCoursGrp4Profs);

			$listeLinkedCoursGrp = $Ecole->listeLinkedCoursGroup($listeCoursGrp4cours);
			$listeVirtualCoursGrp = $Ecole->listeVirtualCoursGrp($listeCoursGrp4cours);
			$listeProfsCoursGrp = $Ecole->listeProfsCoursGrp4cours($listeCoursGrp4cours);

			$listeElevesCoursGrp = $Ecole->listeElevesCoursGrp4cours($listeCoursGrp4cours);

			$smarty->assign('listeCoursGrp', $listeCoursGrp4cours);
			$smarty->assign('listeLinkedCoursGrp', $listeLinkedCoursGrp);
			$smarty->assign('listeVirtualCoursGrp', $listeVirtualCoursGrp);
			$smarty->assign('listeProfsCoursGrp', $listeProfsCoursGrp);
			$smarty->assign('listeElevesCoursGrp', $listeElevesCoursGrp);

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
