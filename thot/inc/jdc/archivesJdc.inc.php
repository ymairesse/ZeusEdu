<?php


$listeArchives = $Jdc->getAnneesArchivesJdc();
$smarty->assign('listeArchives', $listeArchives);

$listeCategories = $Jdc->getListeCategoriesJDC();
$smarty->assign('listeCategories', $listeCategories);

$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

$listeNiveaux = Ecole::listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);

$smarty->assign('corpsPage', 'jdc/archJdc');
