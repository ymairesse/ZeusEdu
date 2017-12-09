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
    $listeCoursEleve = $Ecole->listeCoursGrpEleves($matricule);
    Application::afficher($listeCoursEleve);
}
