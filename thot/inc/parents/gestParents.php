<?php

$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;

if ($classe != Null) {
    $listeParents = $Thot->getMailsParentsClasse($classe);
}
else $listeParents = Null;
$smarty->assign('listeParents', $listeParents);

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);


$smarty->assign('classe', $classe);
$smarty->assign('selecteur', 'selecteurs/selectClassePOST');
$smarty->assign('corpsPage', 'parents/gestParents');
