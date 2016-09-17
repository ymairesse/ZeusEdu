<?php

if ($etape == 'enregistrer') {
    $resultat = $Bulletin->enregistrerEprExternes($_POST);
    $tableErreurs = $resultat['erreurs'];
    $smarty->assign('tableErreurs', $tableErreurs);
    $smarty->assign('message', array(
            'title' => 'Enregistrement',
            'texte' => $resultat['nb'].' enregistrements modifiées',
            'urgence' => 'success', )
            );
}
if (isset($coursGrp)) {
    $listeEleves = $Ecole->listeElevesCours($coursGrp);
    $listeCotes = $Bulletin->listeCotesEprExterne($coursGrp);
    $listeSituationsBulletin = $Bulletin->listeSituationsCours($listeEleves, $coursGrp, NBPERIODES);
    $smarty->assign('listeSituations', $listeSituationsBulletin);
    $smarty->assign('NBPERIODES', NBPERIODES);
    $smarty->assign('listeEleves', $listeEleves);
    $smarty->assign('listeCotes', $listeCotes);
    $smarty->assign('etape', 'enregistrer');

    $smarty->assign('intituleCours', $Bulletin->intituleCours($coursGrp));
    $smarty->assign('listeClasses', $Bulletin->classesDansCours($coursGrp));
    $smarty->assign('corpsPage', 'gestEprExternes');
}

$listeCoursGrp = (isset($niveau)) ? $Bulletin->listeEprExterne($niveau) : null;
$smarty->assign('listeCoursGrp', $listeCoursGrp);
$smarty->assign('listeNiveaux', Ecole::listeNiveaux());
$smarty->assign('selecteur', 'selectNiveauEprExterne');
