<?php

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;

if ($classe != Null) {
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
}
else $listeEleves = Null;

$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

$smarty->assign('classe', $classe);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('matricule', $matricule);
$smarty->assign('selecteur', 'selectClasseEleve');

if (isset($matricule)) {

    $detailsEleve = Eleve::staticGetDetailsEleve($matricule);
    $smarty->assign('eleve', $detailsEleve);
    $smarty->assign('photo', Ecole::photo($matricule));
    $listeProfs = $Ecole->listeProfs();
    $smarty->assign('listeProfs', $listeProfs);

    $nomProf = $User->getNom();
    $smarty->assign('nomProf', implode(' ', $nomProf));

    $smarty->assign('acronyme', $acronyme);
    $smarty->assign('date', date("H:i:s"));

    $smarty->assign('corpsPage', 'eleves/demandeSuivi');
}
