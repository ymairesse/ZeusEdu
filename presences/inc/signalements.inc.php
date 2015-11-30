<?php

// par défaut, action et mode reprennent leurs valeurs actuelles; on re-changera éventuellement plus tard.
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$smarty->assign('matricule',$matricule);

// enregistrement des informations d'absences
if ($etape == 'enregistrer'){
	$nb = $Presences->saveAbsences($_POST,$matricule);
	$smarty->assign('message', array(
			'title'=>SAVE,
			'texte'=>sprintf(NBSAVE,$nb),
			'urgence'=>'success'));
	// on repasse toutes les infos pour ré-affichage
	$smarty->assign('post',$_POST);
	}

$classe = isset($_POST['classe'])?$_POST['classe']:Null;

// si un élève est déclaré, on aura certainement besoin des détails
if ($matricule != Null) {
    $eleve = new Eleve($matricule);
    $classe = $eleve->groupe();
    $smarty->assign('eleve',$eleve->getDetailsEleve());
	}

// informations pour les grilles d'absences
$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes',$listePeriodes);

// date et heure actuelles pour l'enregistrement
$dateNow = Application::dateNow();
$smarty->assign('dateNow',$dateNow);
$smarty->assign('heure',date('H:i'));
$smarty->assign('periodeActuelle', $Presences->periodeActuelle($listePeriodes));

// informations pour le sélecteur classe/élève
$listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
$smarty->assign('listeEleves',$listeEleves);

// liste des absences existantes pour le jour d'aujourd'hui (par défaut) ou pour les dates figurant dans le $_POST après enregistrement
if ($matricule != Null) {
	if (isset($_POST['dates'])) {
		// on dispose d'une liste de dates provenant du formulaire $post => on peut reconstituer la liste des absences
		$smarty->assign('listeDates',$_POST['dates']);
		$listePresences = $Presences->listePresencesEleveMultiDates($_POST['dates'], $matricule);
		}
		else {
			// on utilise la date d'aujourd'hui, par défaut
			$smarty->assign('date',$dateNow);
			$listePresences = $Presences->listePresencesElevesDate($dateNow,$matricule);
			}

	$prevNext = $Ecole->prevNext($matricule, $listeEleves);
	$smarty->assign('prevNext',$prevNext);

	$smarty->assign('listePresences', $listePresences);
		$smarty->assign('corpsPage','signalement');
	}

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('classe',$classe);
$smarty->assign('selecteur','selectClasseEleve');
