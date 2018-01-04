<?php

$titulariats = $user->listeTitulariats();
// $smarty->assign('listeClasses', implode(',', array_keys($titulariats)));

$listeClasses = $titulariats;
if (count($listeClasses) == 1) {
    $classe = current($listeClasses);
}
else $classe = Null;

if ($classe != Null) {
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
}
else $listeEleves = Null;

$listeCharges = $Jdc->getChargesJDC($classe);

$smarty->assign('listeClasses', $titulariats);
$smarty->assign('classe', $classe);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeCharges', $listeCharges);

$smarty->assign('selecteur', 'selecteurs/selectClassePOST');
$smarty->assign('corpsPage', 'jdc/choixEleveJDC');
