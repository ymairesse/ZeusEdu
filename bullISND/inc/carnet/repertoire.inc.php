<?php

$listeCours = $user->listeCoursProf(Null, false);
$smarty->assign('listeCours', $listeCours);



$smarty->assign('corpsPage', 'carnet/repertoire');
