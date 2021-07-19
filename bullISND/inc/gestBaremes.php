<?php

$unAn = time() + 365 * 24 * 3600;

$coursGrp = Application::postOrCookie('coursGrp', $unAn);
$smarty->assign('coursGrp', $coursGrp);

$listeCours = $Ecole->listeCoursProf($acronyme, false);
$smarty->assign('listeCours', $listeCours);

// quelles sont les classes des élèves qui fréquentent le cours?
if (isset($coursGrp)) {
    $classesDansCours = implode(', ', $Bulletin->classesDansCours($coursGrp));
    $smarty->assign('listeClasses', $classesDansCours);
}

$smarty->assign('bulletin', PERIODEENCOURS);
$smarty->assign('nbPeriodes', NBPERIODES);
$smarty->assign('NOMSPERIODES', explode(',', NOMSPERIODES));
$smarty->assign('listePeriodes', range(1, NBPERIODES));
$smarty->assign('periodes', explode(',', NOMSPERIODES));

$smarty->assign('selecteur', 'selecteurs/selectCours');
// on revient avec un cours à traiter...
$listeCoursProf = array_keys($listeCours);

if (($coursGrp != null) && in_array($coursGrp, $listeCoursProf)) {
    $listePonderations = $Bulletin->getPonderations($coursGrp)[$coursGrp];
    if ($listePonderations == null) {
        $listePonderations = $Bulletin->ponderationsVides(NBPERIODES, $coursGrp);
    }
    $listeEleves = $Ecole->listeElevesCours($coursGrp);
    $intituleCours = $Bulletin->intituleCours($coursGrp);

    $smarty->assign('ponderations', $listePonderations);
    $smarty->assign('intituleCours', $intituleCours);
    $smarty->assign('listeEleves', $listeEleves);
    $smarty->assign('corpsPage', 'ponderation/showPonderations');
}
