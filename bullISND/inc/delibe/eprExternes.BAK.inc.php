<?php

// fonctionnalité réservée aux titulaires de classes (professeur principal)
// Objectif: présenter au titulaire la liste des points obtenus par ses élèves
// tant en épreuve externe qu'en épreuve interne pour chaque matière

if (isset($_POST['classe'])) {
    $classe = $_POST['classe'];
    setcookie('classe', $classe, $unAn, null, null, false, true);
} else {
    $classe = isset($_COOKIE['classe']) ? $_COOKIE['classe'] : null;
}
$smarty->assign('classe', $classe);

$listeTitulariats = $user->listeTitulariats();

if (count($listeTitulariats) > 1) {
    $smarty->assign('listeClasses', $listeTitulariats);
    $smarty->assign('selecteur', 'selectClasse');
} else {
    $classe = array_values($listeTitulariats)[0];
}

if ($classe != null) {
    // liste des cours pour l'épreuve externe dans cette classe
    $coursGrpExternes = $Bulletin->listeCoursGrpEprExterne($classe);

    // l'ensemble des coursGrp dans cette classe
    $coursGrp = array_keys($Ecole->listeCoursGrpClasse($classe));

    // il y a des épreuves externes parmi les cours dans cette classe
    if (!empty(array_intersect(array_keys($coursGrpExternes), $coursGrp))) {
        // liste des élèves de la classe
        $listeEleves = $Ecole->listeElevesClasse($classe);
        // liste des cours en épreuve externes
        $listeCoursGrp = array_keys($Bulletin->listeCoursGrpEprExterne($classe));

        $listeSituations = $Bulletin->listeSituationsFinales($listeEleves, $listeCoursGrp, NBPERIODES);

        $smarty->assign('listeCours', $coursGrpExternes);
        $smarty->assign('listeCotesExternes', $listeCotesExternes);
        $smarty->assign('listeSituationsInternes', $listeSituationsInternes);
        $smarty->assign('listeEleves', $listeEleves);
        $smarty->assign('classe', $classe);
        $smarty->assign('corpsPage', 'delibe/eprExterne');
    };
}
