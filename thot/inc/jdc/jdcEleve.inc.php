<?php

if (in_array($userStatus, array('educ', 'admin', 'direction'))) {
    $listeClasses = $Ecole->listeClasses();
    }
    elseif ($mode == 'titu')
    $listeClasses = $Ecole->listeTitulariats($acronyme);
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

$editable = ($type == 'eleve') ? true : false;
$smarty->assign('editable', $editable);
$smarty->assign('selecteur', 'selecteurs/selectClasseElevePOST');

if ($matricule != Null) {
    require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
    $detailsEleve = Eleve::staticGetDetailsEleve($matricule);
    $lblDestinataire = $Jdc->getLabel('eleve', $matricule, $detailsEleve);
    $smarty->assign('lblDestinataire', $lblDestinataire);
    $smarty->assign('corpsPage', 'jdc');
}
