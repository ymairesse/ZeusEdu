<?php

$listeClasses = $Bulletin->classesEprExterne(ANNEESCOLAIRE);
$smarty->assign('listeClasses', $listeClasses);

setlocale(LC_TIME, "fr_FR");

$signature = isset($_POST['signature']) ? $_POST['signature'] : null;

$mois = ucfirst(utf8_encode(strftime("%B")));
$smarty->assign('mois', $mois);

$listeMois = array( 1=>'Janvier', 2=>'Février', 3=>'Mars',      4=>'Avril',     5=>'Mai',       6=>'Juin',
                    7=>'Juillet', 8=>'Août',    9=>'Septembre', 10=>'Octobre',  11=>'Novembre', 12=>'Décembre');
$smarty->assign('listeMois', $listeMois);

$annee = strftime("%G");
$smarty->assign('annee', $annee);

$smarty->assign('signature', $signature);
$smarty->assign('DIRECTION', DIRECTION);

$smarty->assign('corpsPage','templates/direction/resultatsEprExterne');
