<?php

if (in_array($userStatus, array('educ', 'admin', 'direction'))) {
    $listeClasses = $Ecole->listeClasses();
    }
    else {
    $listeClasses = $Ecole->listeClassesProf($acronyme);
}
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$listeEleves = ($classe != null) ? $Ecole->listeEleves($classe, 'groupe') : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

$smarty->assign('matricule', $matricule);
$smarty->assign('classe', $classe);
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('mode', $mode);
$smarty->assign('etape', Null);

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
