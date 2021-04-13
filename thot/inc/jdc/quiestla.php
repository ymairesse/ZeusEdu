<?php

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$listeCoursGrp = $User->listeCoursProf(Null, true);


$listeClasses = $Ecole->listeClasses();


$smarty->assign('listeCoursGrp', $listeCoursGrp);
$smarty->assign('listeClasses', $listeClasses);

$smarty->assign('corpsPage', 'jdc/quiestla');
