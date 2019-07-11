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


    // liste des coursGrp de chaque élève, sans coursGrp virtuel
    $listeCoursGrpListeEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin, true);
    // liste des cours (sans groupe) dans la classe
    $listeCoursListeEleves = $Bulletin->listeCoursSansGrp($listeCoursGrpListeEleves);
    // liste des coursGrp dans la classe (y compris prof, libelle, statut,...), sans coursGrp virtuel
    $listeCoursGrp = $Ecole->listeCoursGrpClasse($classe, false);
    // statuts des cours en fonction de leur cadre légal (pour les cours non comptabilisés en echec etc...)
    $statutsCadres = $Bulletin->getStatutsCadres();

    $listeCours = $Ecole->listeCoursClassePourDelibe($classe);

    $listeSituations = $Bulletin->listeSituationsDelibe($listeEleves, array_keys($listeCoursGrp), $bulletin);

    $listeDecisions = $Bulletin->listeDecisions($listeEleves);

    $delibe = $Bulletin->echecMoyennesDecisions($listeSituations, $statutsCadres);

    $listeEBS = $Ecole->getEBS($classe, 'groupe');

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
    $smarty->assign('listeDecisions', $listeDecisions);
    $smarty->assign('listeEBS', $listeEBS);
    
    $smarty->assign('corpsPage', 'delibe/feuilleDelibes');
}
