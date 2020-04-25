<?php

// détermination des classes accessibles à l'utlisateur courant, selon son statut
if (in_array($userStatus, array('educ', 'admin', 'direction'))) {
    $listeClasses = $Ecole->listeClasses();
    }
    else {
    $listeClasses = $Ecole->listeClassesProf($acronyme);
}
$smarty->assign('listeClasses', $listeClasses);

$unAn = time() + 365 * 24 * 3600;
// une classe a-t-elle été visitée récemment?
$classe = Application::postOrCookie('classe', $unAn);
// si la classe est accessible à l'utilisateur courant,
// voir si l'on a un matricule récemment visité (peut-être dans cette classe)
if (in_array($classe, $listeClasses)) {
    $matricule = Application::postOrCookie('matricule', $unAn);
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    // si le matricule trouvé n'appartient pas à la classe, on le néglige
    if (!in_array($matricule, array_keys($listeEleves)))
        $matricule = Null;
    }
    else {
        $matricule = Null;
        $classe = Null;
    }

$smarty->assign('classe', $classe);
$smarty->assign('matricule', $matricule);

$listeEleves = ($classe != null) ? $Ecole->listeEleves($classe, 'groupe') : null;
$smarty->assign('listeEleves', $listeEleves);

$categories = $Jdc->categoriesTravaux();
$smarty->assign('categories', $categories);

$smarty->assign('editable', false);
$smarty->assign('selecteur', 'selecteurs/selectClasseElevePOST');

if ($matricule != Null) {
    require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
    $detailsEleve = Eleve::staticGetDetailsEleve($matricule);
    $lblDestinataire = $Jdc->getLabel('eleve', $matricule, $detailsEleve);
    $smarty->assign('jdcInfo', 'Pour consulter le JDC d\'un élève à sélectionner ci-dessus (Vue subjective)');
    $smarty->assign('lblDestinataire', $lblDestinataire);
    $smarty->assign('corpsPage', 'jdc/jdcSubjectif');
}
