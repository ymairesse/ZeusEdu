<?php

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

$debut = Application::postOrCookie('debut', $unAn);
if ($debut == Null)
	$debut = date('d/m/Y');
// $debut = isset($_POST['debut'])?$_POST['debut']:date('d/m/Y');
$fin = Application::postOrCookie('fin', $unAn);
if ($fin == Null)
	$fin = date('d/m/Y');
// $fin = isset($_POST['fin'])?$_POST['fin']:date('d/m/Y');
$niveau = Application::postOrCookie('niveau', $unAn);

$classe = Application::postOrCookie('classe', $unAn);

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

$listeEleves = Null;

if ($niveau != Null) {
	$listeClasses = $Ecole->listeClassesNiveau($niveau, 'groupe');
	$smarty->assign('listeClasses', $listeClasses);
	}

if ($classe != Null) {
	$listeEleves = $Ecole->listeEleves($classe, 'groupe');
	$smarty->assign('listeEleves', $listeEleves);
	}

if ($matricule != Null) {
	$listeEleves = array($matricule => Eleve::staticGetDetailsEleve($matricule));
	$smarty->assign('listeEleves', $listeEleves);
}

$listeNiveaux = Ecole::listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);

$listeTypesFaits = $Ades->listeTypesFaits();
$smarty->assign('listeTypesFaits', $listeTypesFaits);

switch ($mode) {
	case 'showFiches':
		$smarty->assign('corpsPage', 'eleve/ficheDisciplineEcran');
		break;

	case 'statistiques':
		$smarty->assign('corpsPage','eleve/statistiques');
		break;
	}
