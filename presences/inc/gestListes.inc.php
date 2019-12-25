<?php

// $selectProf = isset($_POST['selectProf']) ? $_POST['selectProf'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$date = isset($_POST['date']) ? $_POST['date'] : null;

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$smarty->assign('matricule', $matricule);

if ($matricule != null) {
    // récuperer la classe de l'élève si le matricule provient de la liste autocompletée
    $detailsEleve = $Ecole->nomPrenomClasse($matricule);
    $classe = $detailsEleve['classe'];
}

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes', $listePeriodes);

// liste des statuts d'absences possibles
$statutsAbs = $Presences->listeJustificationsAbsences();
$smarty->assign('statutsAbs', $statutsAbs);

switch ($mode) {
    case 'parDate':
        $date = isset($_POST['date']) ? $_POST['date'] : strftime('%d/%m/%Y');
        $smarty->assign('date', $date);
        $smarty->assign('corpsPage', 'listeParDate');
        break;

    case 'parEleve':
        $smarty->assign('classe', $classe);
        $listeEleves = isset($classe) ? $Ecole->listeEleves($classe, 'groupe') : null;
        $smarty->assign('listeEleves', $listeEleves);
        $listeClasses = $Ecole->listeGroupes();
        $smarty->assign('listeClasses', $listeClasses);
        $matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
        $smarty->assign('matricule', $matricule);

        if ($etape == 'showEleve') {
            $prevNext = $Ecole->prevNext($matricule, $listeEleves);
            $smarty->assign('prevNext', $prevNext);
            $listePresences = $Presences->listePresencesEleve($matricule);
            $smarty->assign('listePresences', $listePresences);
            $Eleve = new Eleve($matricule);
            $detailsEleve = $Eleve->getDetailsEleve();
            $smarty->assign('detailsEleve', $detailsEleve);
            $smarty->assign('corpsPage', 'listes/presencesEleve');
        }
        $smarty->assign('etape', 'showEleve');
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('selecteur', 'selectClasseEleve');
        break;

    case 'parClasse':
        $listeClasses = $Ecole->listeClasses();
        $smarty->assign('listeClasses', $listeClasses);
        $smarty->assign('classe', $classe);
        $smarty->assign('date', $date);

        if (($classe != null) && ($date != null)) {
            $listeEleves = $Ecole->listeEleves($classe, 'groupe');
            $smarty->assign('listeEleves', $listeEleves);

            $listePresences = $Presences->listePresencesElevesDate($date, $listeEleves);
            $smarty->assign('listePresences', $listePresences);

            $smarty->assign('corpsPage', 'listes/presencesClasse');
        }

        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);

        $smarty->assign('selecteur', 'selectClasseDate');
        break;

    }
