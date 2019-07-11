<?php

$smarty->assign('PERIODESDELIBES', explode(',', PERIODESDELIBES));
$smarty->assign('PERIODEENCOURS', PERIODEENCOURS);

$listeCoursGrpProf = $user->listeCoursProf(Null, true);

// liste de tous les élèves avec leurs cours
$listeCoursGrpEleves = $Ecole->listeElevesDeListeCoursGrp($listeCoursGrpProf);
// liste de tous les élèves dont le bulletin contient une situation pour la période en cours
$listeSituationsOK = $Bulletin->listeSituationsOK(array_keys($listeCoursGrpProf), PERIODEENCOURS);
// on retire de la liste des élèves tout ceux qui sont OK
foreach ($listeCoursGrpEleves as $coursGrp => $listeEleves) {
    foreach ($listeSituationsOK as $coursGrpOK => $dataEleves) {
        foreach ($dataEleves as $matricule => $wtf) {
            // on supprime tous les élèves qui figurent dans la table OK
            unset($listeCoursGrpEleves[$coursGrpOK][$matricule]);
        }
    }
    // s'il n'y a plus d'élément dans la liste, on la supprime
    if (count($listeCoursGrpEleves[$coursGrp]) == 0) {
        unset($listeCoursGrpEleves[$coursGrp]);
    }
}
$smarty->assign('listeSituationsVides',$listeCoursGrpEleves);

$listeDelibeVide = $Bulletin->listeSitDelibeVides(array_keys($listeCoursGrpProf), PERIODEENCOURS);
$smarty->assign('listeDelibeVide', $listeDelibeVide);

$listeEchecNonCommentes = $Bulletin->listeEchecNonCommentes(array_keys($listeCoursGrpProf), PERIODEENCOURS);
$smarty->assign('listeEchecNonCommentes', $listeEchecNonCommentes);

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/classFlashInfo.inc.php';
$FlashInfo = new FlashInfo();

$listeFlashInfos = $FlashInfo->listeFlashInfos($module);

$userStatus = $User->userStatus($module);
$smarty->assign('userStatus', $userStatus);
$smarty->assign('listeFlashInfos', $listeFlashInfos);

$smarty->assign('corpsPage', 'news/news');
