<?php

$smarty->assign('action', 'delibes');
$smarty->assign('mode', 'parClasse');
$smarty->assign('etape', 'showCotes');
$smarty->assign('selecteur', 'selectBulletinClasse');

if (($etape == 'showCotes') && ($classe != null)) {
    $titusClasse = $Ecole->titusDeGroupe($classe);

    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    if (in_array($bulletin, explode(',', str_replace(' ', '', PERIODESDELIBES)))) {
        $listeMentions = $Bulletin->listeMentions($listeEleves, $bulletin, $annee, ANNEESCOLAIRE);
    } else {
        $listeMentions = null;
    }
    $listeCoursGrpListeEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);

    $listeCoursListeEleves = $Bulletin->listeCoursSansGrp($listeCoursGrpListeEleves);
    $listeCoursGrp = $Ecole->listeCoursGrpClasse($classe);
    $listeCours = $Ecole->listeCoursClassePourDelibe($classe);

    $listeSituations = $Bulletin->listeSituationsDelibe($listeEleves, array_keys($listeCoursGrp), $bulletin);

    $delibe = $Bulletin->echecMoyennesDecisions($listeSituations);

    $smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
    $smarty->assign('delibe', $delibe);
    $smarty->assign('listeEleves', $listeEleves);
    $smarty->assign('listeCoursListeEleves', $listeCoursListeEleves);
    $smarty->assign('listeCoursGrpListeEleves', $listeCoursGrpListeEleves);
    $smarty->assign('listeSituations', $listeSituations);
    $smarty->assign('selectClasse', $classe);
    $smarty->assign('titusClasse', $titusClasse);
    $smarty->assign('listeCours', $listeCours);
    $smarty->assign('listeMentions', $listeMentions);
    $smarty->assign('corpsPage', 'delibe/feuilleDelibes');
}
