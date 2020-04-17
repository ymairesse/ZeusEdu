<?php

if (in_array($userStatus, array('educ', 'admin', 'direction'))) {
    $listeClasses = $Ecole->listeGroupes();
    }
    else {
    $listeClasses = $Ecole->listeClassesProf($acronyme);
}

if (!in_array($classe, $listeClasses))
    $classe = Null;
    else setcookie('classe', $classe, $unAn, '/', null, false, true);

$smarty->assign('classe', $classe);  // pour le sélecteur
$smarty->assign('listeClasses', $listeClasses);

$smarty->assign('editable', true);
$smarty->assign('selecteur', 'selecteurs/selectClassePOST');

if ($classe != Null) {
    $lblDestinataire =  $Jdc->getLabel('classe', $classe);
    $smarty->assign('lblDestinataire', $lblDestinataire);
    $smarty->assign('corpsPage', 'jdc');
    }
