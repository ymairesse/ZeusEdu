<?php

$unAn = time() + 365 * 24 * 3600;

if (isset($_POST['tri'])) {
    $tri = $_POST['tri'];
    setcookie('tri', $tri, $unAn, null, null, false, true);
} elseif (isset($_COOKIE['tri'])) {
        $tri = $_COOKIE['tri'];
    } else {
                $tri = null;
            }
$smarty->assign('tri', $tri);

// la liste de tous les cours du prof
$listeCoursProf = $user->listeCoursProf();
// on ne retient que les cours qui se trouvent aussi dans la table des épreuves externes
$listeCours = $Bulletin->listeCoursEprExterne($listeCoursProf, ANNEESCOLAIRE);
$smarty->assign('listeCours', $listeCours);

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
$etape = isset($_POST['etape']) ? $_POST['etape'] : null;
$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('etape', $etape);

$smarty->assign('COTEABS', COTEABS);

if ($coursGrp) {
    if ($etape == 'enregistrer') {
        $resultat = $Bulletin->enregistrerEprExternes($_POST, ANNEESCOLAIRE);
        $tableErreurs = $resultat['erreurs'];
        if ($tableErreurs == null) {
            $smarty->assign('message', array(
                    'title' => SAVE,
                    'texte' => $resultat['nb'].' enregistrements modifiées',
                    'urgence' => 'success', )
                    );
        } else {
            $smarty->assign('tableErreurs', $resultat['erreurs']);
            $smarty->assign('message', array(
                    'title' => 'Erreur',
                    'texte' => 'Les cotes contiennent une ou plusieurs erreurs. Veuillez corriger.',
                    'urgence' => 'danger', )
                    );
        }
    }
    $listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
    $listeCotes = $Bulletin->listeCotesEprExterne($coursGrp, ANNEESCOLAIRE);
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

// par défaut

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);
$smarty->assign('selecteur', 'selecteurs/selectCours');
$smarty->assign('action', 'gestEprExternes');
