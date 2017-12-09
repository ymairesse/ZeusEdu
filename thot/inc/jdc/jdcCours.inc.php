<?php

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;

$listeCours = $user->listeCoursProf();

if (!(in_array($coursGrp, array_keys($listeCours))))
    $coursGrp = Null;
    else setcookie('coursGrp', $coursGrp, $unAn, '/', null, false, true);

$smarty->assign('coursGrp', $coursGrp);  // pour le sélecteur
$smarty->assign('listeCours', $listeCours);

$smarty->assign('editable', true);
$smarty->assign('selecteur', 'selecteurs/selectCoursPOST');

if ($coursGrp != Null) {
    $lblDestinataire =  $Jdc->getLabel('cours', $coursGrp, $listeCours);
    $smarty->assign('lblDestinataire', $lblDestinataire);
    $smarty->assign('corpsPage', 'jdc');
    }
