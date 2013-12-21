<?php
$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$debut = isset($_POST['debut'])?$_POST['debut']:date('d/m/Y');
$fin = isset($_POST['fin'])?$_POST['fin']:date('d/m/Y');

// mise en ordre éventuelle des dates de début et de fin
$dateDebut = strptime($debut,'%d/%m/%Y');
$dateFin = strptime($fin,'%d/%m/%Y');
$timestamp1 = mktime(0, 0, 0, $dateDebut['tm_mon']+1, $dateDebut['tm_mday'], $dateDebut['tm_year']+1900);
$timestamp2 = mktime(0, 0, 0, $dateFin['tm_mon']+1, $dateFin['tm_mday'], $dateFin['tm_year']+1900);
if ($timestamp1 > $timestamp2) {
	$swap = $debut;
	$debut = $fin;
	$fin = $swap;
	}

$smarty->assign('niveau',$niveau);
$smarty->assign('classe',$classe);
$smarty->assign('matricule',$matricule);
$smarty->assign('debut', $debut);
$smarty->assign('fin', $fin);

if (isset($niveau)) {
	$sections = array();
	$listeClasses = $Ecole->listeClassesNiveau($niveau,'groupe',$sections);
	$smarty->assign('listeClasses', $listeClasses);
	}

if (isset($classe)) {
	$listeEleves = $Ecole->listeEleves($classe,'groupe');
	$smarty->assign('listeEleves', $listeEleves);
	}
	
if ($mode == 'showFiches') {
	// élève isolé
	if (isset($matricule) && $matricule != '') 
		$listeEleves = $matricule;
		// une seule classe du niveau
		else if (isset($classe) && $classe != '')
				$listeEleves = $Ecole->listeEleves($classe,'groupe');
				// tout le niveau
				else $listeEleves = $Ecole->listeElevesNiveaux($niveau);
	// pour chaque type de faits, voir quel champ doit être affiché dans le contexte "tableau"
	$listeChamps = $Ades->champsInContexte('tableau');
	$listeFaits = $Ades->fichesDisciplinaires($listeEleves, $debut, $fin);
	$smarty->assign('listeFaits', $listeFaits);
	}

$smarty->assign('action',$action);
$smarty->assign('mode','showFiches');


$listeNiveaux = Ecole::listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);
$smarty->assign('selecteur', 'selectSynthese');
if (isset($listeFaits)) {
	$smarty->assign('listeTypesFaits', $Ades->getTypesFaits());
	$smarty->assign('listeChamps', $listeChamps);
	$smarty->assign('listeTitres', $Ades->titreChamps());
	$smarty->assign('listeFaits', $listeFaits);
	$smarty->assign('corpsPage', 'synthese');
	}
?>