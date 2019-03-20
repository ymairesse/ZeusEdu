<?php

$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;

if ($classe != Null) {
    $listeParents = $Thot->getMailsParentsClasse($classe);
}
else $listeParents = Null;

$listeNonInscrits = $Thot->listeNonInscrits($classe);

$smarty->assign('listeParents', $listeParents);
$smarty->assign('listeNonInscrits', $listeNonInscrits);

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);


$smarty->assign('classe', $classe);
$smarty->assign('selecteur', 'selecteurs/selectClasseMailPOST');
$smarty->assign('corpsPage', 'parents/gestParents');
