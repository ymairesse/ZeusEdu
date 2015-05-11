<?php
$unAn = time() + 365*24*3600;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;

if (isset($_POST['coursGrp'])) {
	$coursGrp = $_POST['coursGrp'];
	setcookie('coursGrp',$coursGrp,$unAn, null, null, false, true);
	}
	else $coursGrp = isset($_COOKIE['coursGrp'])?$_COOKIE['coursGrp']:Null;
$smarty->assign('coursGrp', $coursGrp);

if (isset($_POST['matricule'])) {
	$matricule = $_POST['matricule'];
	setcookie('matricule',$matricule,$unAn, null, null, false, true);
	}
	else $matricule = isset($_COOKIE['matricule'])?$_COOKIE['matricule']:Null;
$smarty->assign('matricule', $matricule);

$listeCours = $user->listeCoursProf("'G','S','TT'");

$smarty->assign('action',$action);
// on présente toujours le sélecteur de cours
$smarty->assign('coursGrp', $coursGrp);
// quelles sont les classes des élèves qui fréquentent le cours?
if (isset($coursGrp)) {
	$classesDansCours = implode(", ", $Bulletin->classesDansCours($coursGrp));
	$smarty->assign('listeClasses', $classesDansCours);
	}

switch ($mode) {
	case 'modifBareme':
		if ($coursGrp  && in_array($coursGrp, array_keys($user->listeCoursProf()))) {  // si $coursGrp pas défini, on ne fait rien
			switch ($etape) {
				case 'enregistrer':
					$nbInsert = $Bulletin->enregistrementPonderations($_POST);
					$ponderations = $Bulletin->getPonderations($coursGrp);
					$intituleCours = $Bulletin->intituleCours($coursGrp);
					$listeEleves = $Ecole->listeElevesCours($coursGrp);
					$smarty->assign('periodes', explode(',', NOMSPERIODES));					
					$smarty->assign('nbPeriodes', NBPERIODES);
					$smarty->assign('listeEleves', $listeEleves);
					$smarty->assign('ponderations', $ponderations);
					$smarty->assign('intituleCours', $intituleCours);
					$smarty->assign('mode','voir');
					$smarty->assign("message", array(
									'title'=>"Enregistrement",
									'texte'=>"$nbInsert pondération(s) modifiée(s)",
									'urgence'=>'success')
									);
					$smarty->assign('selecteur', 'selectCours');					
					$smarty->assign('corpsPage', 'showPonderations');
					break;
				default:
					if (!($Bulletin->legitimeModifBareme ($coursGrp, $listeCours, $matricule)))
						die("Vous ne donnez pas ce cours ou l'eleve ne suit pas ce cours...");
					$ponderations = $Bulletin->getPonderations($coursGrp);
					if ($matricule != 'all') {
						$nomEleve = $Ecole->nomPrenomClasse($matricule);
						$smarty->assign("nomEleve", $nomEleve);
						}
					$admin = $_SESSION[APPLICATION]->getUserStatus($module);
					$intituleCours = $Bulletin->intituleCours($coursGrp);
					$smarty->assign('periodes', explode(',', NOMSPERIODES));					
					$smarty->assign('admin',$admin);
					$smarty->assign('ponderations', $ponderations);
					$smarty->assign('nbPeriodes', NBPERIODES);
					$smarty->assign('bulletin', PERIODEENCOURS);
					$smarty->assign('action',$action);
					$smarty->assign('mode', $mode);
					$smarty->assign('etape', 'enregistrer');
					$smarty->assign('intituleCours', $intituleCours);
					$smarty->assign('corpsPage', 'formBaremes');
					break;
				}
			}
		break;
	case 'ajoutBaremeParticulier':
		if (!($Bulletin->legitimeModifBareme ($coursGrp, $listeCours, $matricule))) 
			die("Vous ne donnez pas ce cours ou l'eleve ne suit pas ce cours...");
		// ajouter un barème sur le modèle du barème général pour un élève particulier
		if ($Bulletin->ajouterPonderation($coursGrp, $matricule))
			$notice = "Pondération particulière ajoutée.";
			else $notice = "Une pondération particulière existe déjà pour cet élève.";

		$ponderations = $Bulletin->getPonderations($coursGrp);
		$listeEleves = $Ecole->listeElevesCours($coursGrp);
		$intituleCours = $Bulletin->intituleCours($coursGrp);
		$classesDansCours = implode(", ", $Bulletin->classesDansCours($coursGrp));
		$smarty->assign('nbPeriodes', NBPERIODES);
		$smarty->assign('ponderations', $ponderations);
		$smarty->assign('intituleCours', $intituleCours);
		$smarty->assign('listeEleves', $listeEleves);
		$smarty->assign('message', array(
				'title'=>'Pondérations',
				'texte'=>$notice )
				);
		$smarty->assign('corpsPage', 'showPonderations');
		break;
	case 'supprBaremeParticulier':
		// on vérifie que le barème n'a pas été modifié par rapport au barème de base
		// pour tous les élèves. S'il y a eu modification, on n'y touche pas
		if ($Bulletin->verifSupprPonderationPossible($coursGrp, $matricule)) {
			// vérification que l'utilisateur a le droit de modifier le barème
			if (!($Bulletin->legitimeModifBareme ($coursGrp, $listeCours, $matricule))) 
				die("Vous ne donnez pas ce cours ou l'eleve ne suit pas ce cours...");
			$nbSuppressions = $Bulletin->suppressionPonderation ($coursGrp, $matricule);
			$smarty->assign("message", array(
					'title'=>'Suppression',
					'texte'=>"$nbSuppressions pondérations supprimées")
					);
			}
			else $smarty->assign("message", array(
					'title'=>'Suppression',
					'texte'=>"Cette pondération a été modifiée. Impossible de la supprimer.<br>Veuillez la ramener à la même pondération que l'ensemble du groupe.")
					);
		$ponderations = $Bulletin->getPonderations($coursGrp);
		$listeEleves = $Ecole->listeElevesCours($coursGrp);
		$intituleCours = $Bulletin->intituleCours($coursGrp);
		$smarty->assign('selecteur', 'selectCours');
		$smarty->assign('nbPeriodes', NBPERIODES);
		$smarty->assign('ponderations', $ponderations);
		$smarty->assign('intituleCours', $intituleCours);
		$smarty->assign('listeEleves', $listeEleves);
		$smarty->assign('corpsPage', 'showPonderations');
		break;
		
	default:
		$smarty->assign('selecteur','selectCours');
		// on revient avec un cours à traiter...
		if ($coursGrp != Null) {
			$ponderations = $Bulletin->getPonderations($coursGrp);
			if ($ponderations == Null)
				$ponderations = $Bulletin->ponderationsVides(NBPERIODES, $coursGrp);
			$listeEleves = $Ecole->listeElevesCours($coursGrp);
			$intituleCours = $Bulletin->intituleCours($coursGrp);
			$smarty->assign('selecteur', 'selectCours');
			$smarty->assign('periodes', explode(',', NOMSPERIODES));					
			$smarty->assign('mode','voir');
			$smarty->assign('nbPeriodes', NBPERIODES);
			$smarty->assign('ponderations', $ponderations);
			$smarty->assign('intituleCours', $intituleCours);
			$smarty->assign('listeEleves', $listeEleves);
			$smarty->assign('corpsPage', 'showPonderations');
		}
		break;

	}
?>
