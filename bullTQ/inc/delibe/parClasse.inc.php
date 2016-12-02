<?php

if (isset($classe) && (isset($bulletin) && ($bulletin != null))) {
    $listeSituations = $BullTQ->listeSituationsClasse($classe, $bulletin);
    $smarty->assign('listeSituations', $listeSituations);

    $listeCoursEleves = $Ecole->listeCoursListeEleves($listeEleves);
    $smarty->assign('listeCoursEleves', $listeCoursEleves);

    $listeCours = $BullTQ->listeCoursClasse($classe);
    $smarty->assign('listeCours', $listeCours);

    $smarty->assign('corpsPage', 'syntheseClasse');
}
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

$smarty->assign('selecteur', 'selecteurs/selectPeriodeClasse');
