<?php

$smarty->assign('action','delibes');
$smarty->assign('mode','synthese');
$smarty->assign('etape','showCotes');
// sélecteur incluant la période '0' pour les élèves de 2e
$smarty->assign('selecteur', 'selectBulletin0Classe');
if (($etape == 'showCotes') && ($classe)) {
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    $listeCoursGrpListeEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin, true);

    $listeSituations100 = $Bulletin->getSituations100($bulletin, $listeEleves);
    $moyennesSynthese = $Bulletin->getMoyennes($listeSituations100);

    $listeCours = $Ecole->listeCoursClassePourDelibe($classe);

    $smarty->assign('listeSituations100', $listeSituations100);
    $smarty->assign('moyennes', $moyennesSynthese);
    $smarty->assign('listeCours', $listeCours);
    $smarty->assign('listeCoursGrpListeEleves',$listeCoursGrpListeEleves);
    $smarty->assign('listeEleves', $listeEleves);
    $smarty->assign('corpsPage','grillePeriode');
    }
