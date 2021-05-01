<?php

// liste des élèves affectés à  l'utilisateur courant
$listeEleves = $BullTQ->listeStagesSuivis($acronyme);
$detailsEleves = $Ecole->detailsDeListeEleves($listeEleves);

$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('detailsEleves', $detailsEleves);
$smarty->assign('corpsPage', 'stages/evalStages');
