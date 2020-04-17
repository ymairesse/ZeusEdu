<?php

$listeNiveaux = $Ecole->listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);

$smarty->assign('corpsPage', 'jdc/jdcCible');
