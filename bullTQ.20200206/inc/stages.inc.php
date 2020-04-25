<?php

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;

// liste des classes dont l'utilisateur courant est titulaire
$listeClasses = $BullTQ->tituTQ($acronyme);
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('selecteur', 'selecteurs/selectClasse');

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

if ($classe != null) {
    $listeProfs = $BullTQ->listeProfsSection('TQ');
    $listeEleves = $Ecole->listeEleves($classe, 'classe');
    $smarty->assign('listeProfs', $listeProfs);
    $smarty->assign('listeEleves', $listeEleves);
    $smarty->assign('corpsPage', 'stages/profsStages');
}
