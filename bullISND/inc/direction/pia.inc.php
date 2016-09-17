<?php

$smarty->assign('listeClasses', $Ecole->listeClasses());
if (isset($classe)) {
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    $smarty->assign('listeEleves', $listeEleves);
}

$smarty->assign('corpsPage','direction/printPia');
