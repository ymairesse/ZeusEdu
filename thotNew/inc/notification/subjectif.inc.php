<?php

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;

$listeClasses = $Ecole->listeClasses();
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('type', 'subjectif');
$smarty->assign('action', $action);
$smarty->assign('etape', $etape);
$smarty->assign('selecteur', 'selecteurs/selectClasseElevePOST');

if ($classe != Null) {
    $listeEleves = $Ecole->listeEleves($classe,'groupe');
    $smarty->assign('listeEleves', $listeEleves);
    }

if ($matricule != Null) {
    $smarty->assign('matricule', $matricule);
    $smarty->assign('classe', $classe);
    $niveau = substr($classe, 0, 1);
    $listeMatieresEleve = array_keys($Ecole->listeMatieresEleves($matricule));
    $listeCoursGrpEleve = array_keys($Ecole->listeCoursGrpEleves($matricule));
    $eleve = Eleve::staticGetDetailsEleve($matricule);

    $listeAnnonces = $Thot->listeLesAnnonces($matricule, $classe, $listeMatieresEleve, $listeCoursGrpEleve, $eleve['nom']);

    $listePJ = $Thot->getPJ4eleve($listeAnnonces, $matricule);

    $listeFlags = $Thot->listeFlagsAnnonces(array_keys($listeAnnonces), $matricule);

    $smarty->assign('eleve', $eleve);
    $smarty->assign('listeAnnonces', $listeAnnonces);
    $smarty->assign('listeCours', $listeCoursGrpEleve);
    $smarty->assign('listePJ', $listePJ);
    $smarty->assign('listeFlags', $listeFlags);

    $smarty->assign('corpsPage', 'notification/subjectifAnnonces');
}
