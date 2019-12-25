<?php

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);

$smarty->assign('mode', $mode);

$smarty->assign('corpsPage', 'absences/signalements');
