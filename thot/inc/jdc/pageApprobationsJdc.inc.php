<?php

// liste des approbations en attente pour l'utilisateur courant
$approbations = $Jdc->getApprobations($listeCours, $titulaire);
// appréciations des élèves sur les notes au JDC
$appreciations = $Jdc->listeAppreciations(array_keys($approbations));


$smarty->assign('approbations', $approbations);
$smarty->assign('appreciations', $appreciations);
$smarty->assign('corpsPage', 'jdc/listeApprobations');
