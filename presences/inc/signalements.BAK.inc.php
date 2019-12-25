<?php

// par défaut, action et mode reprennent leurs valeurs actuelles; on re-changera éventuellement plus tard.
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$smarty->assign('matricule', $matricule);

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
// si un élève est déclaré, on aura certainement besoin des détails
if ($matricule != null) {
    $eleve = new Eleve($matricule);
    $classe = $eleve->groupe();
    $smarty->assign('eleve', $eleve->getDetailsEleve());
}

// informations pour les grilles d'absences
$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes', $listePeriodes);

// date et heure actuelles pour l'enregistrement
$dateNow = Application::dateNow();
$smarty->assign('dateNow', $dateNow);
$smarty->assign('heure', date('H:i'));
$smarty->assign('periodeActuelle', $Presences->periodeActuelle($listePeriodes));

// informations pour le sélecteur classe/élève
$listeEleves = isset($classe) ? $Ecole->listeEleves($classe, 'groupe') : null;
$smarty->assign('listeEleves', $listeEleves);

// tous les modes de justifications existants
$listeJustifications = $Presences->listeJustificationsAbsences();
$smarty->assign('listeJustifications', $listeJustifications);

$listeSpeed = $Presences->listeJustificationsAbsences(true, false, true);
$smarty->assign('listeSpeed', $listeSpeed);

// liste des absences existantes pour le jour d'aujourd'hui (par défaut) ou pour les dates figurant dans le $_POST après enregistrement
if ($matricule != null) {
    if (isset($_POST['dates'])) {
        // on dispose d'une liste de dates provenant du formulaire $post => on peut reconstituer la liste des absences
        $smarty->assign('listeDates', $_POST['dates']);
        $listePresences = $Presences->listePresencesEleveMultiDates($_POST['dates'], $matricule);
    } else {
        // on utilise la date d'aujourd'hui, par défaut
        $smarty->assign('date', $dateNow);
        $listePresences = $Presences->listePresencesElevesDate($dateNow, $matricule);
    }

    // liste des statuts d'absences possibles
    $statutsAbs = $Presences->listeJustificationsAbsences();
    $smarty->assign('statutsAbs', $statutsAbs);

    $prevNext = $Ecole->prevNext($matricule, $listeEleves);
    $smarty->assign('prevNext', $prevNext);

    $smarty->assign('listePresences', $listePresences);
    $smarty->assign('corpsPage', 'signalement');
}

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('classe', $classe);
$smarty->assign('selecteur', 'selectClasseEleve');
