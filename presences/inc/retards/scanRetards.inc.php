<?php

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listePeriodesCours = $Ecole->lirePeriodesCours();
$periodeActuelle = $Ecole->periodeActuelle($listePeriodesCours);



$smarty->assign('listePeriodesCours', $listePeriodesCours);
$smarty->assign('periodeActuelle', $periodeActuelle);

$smarty->assign('BASEDIR', BASEDIR);
$smarty->assign('corpsPage', 'retards/scanRetards');
