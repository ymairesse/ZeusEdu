<?php

$unAn = time() + 365 * 24 * 3600;
$degre = Application::postOrCookie('degre', $unAn);

$smarty->assign('degre', $degre);
$listeDegres = explode (',', ANNEEDEGRE);
$smarty->assign('listeDegres', $listeDegres);

// liste des périodes possibles
$listePeriodes = range(0, max($nbPeriodes));

$smarty->assign('corpsPage', 'direction/recapDegre');
