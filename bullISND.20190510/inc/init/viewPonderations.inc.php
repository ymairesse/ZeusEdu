<?php

$unAn = time() + 365 * 24 * 3600;
$niveau = Application::postOrCookie('niveau', $unAn);
$smarty->assign('niveau', $niveau);

$listeNiveaux = $Ecole->listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);

$ponderations = ($niveau != Null) ? $Bulletin->getPonderationsNiveau($niveau) : Null;
$listeCoursNiveau = ($niveau != Null) ? $Ecole->listeCoursNiveau($niveau) : Null;

$smarty->assign('ponderations', $ponderations);
$smarty->assign('listeCours', $listeCoursNiveau);
$smarty->assign('listePeriodes', range(1, NBPERIODES));
$arrayPeriodes = explode(',', NOMSPERIODES);
$smarty->assign('NOMSPERIODES', $arrayPeriodes);

$smarty->assign('corpsPage', 'admin/voirPonderations');
