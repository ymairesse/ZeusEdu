<?php

$listeCategories = $Jdc->getListeCategoriesJDC();

$debut = Application::postOrCookie('debut', $unAn);
if ($debut == Null)
    $debut = date('d/m/Y');

$fin = Application::postOrCookie('fin', $unAn);
if ($fin == Null)
    $fin = date('d/m/Y');
$smarty->assign('debut', $debut);
$smarty->assign('fin', $fin);

$listeNiveaux = Ecole::listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);

$smarty->assign('listeCategories', $listeCategories);

$smarty->assign('corpsPage', 'jdc/printJdcProfs');
