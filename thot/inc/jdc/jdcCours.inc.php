<?php

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;



if (!(in_array($coursGrp, array_keys($listeCours))))
    $coursGrp = Null;
    else setcookie('coursGrp', $coursGrp, $unAn, '/', null, false, true);

// pour le sélecteur
$smarty->assign('coursGrp', $coursGrp);

$smarty->assign('listeCours', $listeCours);

$smarty->assign('editable', true);
$smarty->assign('selecteur', 'selecteurs/selectCoursPOST');




























if ($coursGrp != Null) {
    $lblDestinataire =  $Jdc->getLabel('coursGrp', $coursGrp, $listeCours);
    $smarty->assign('lblDestinataire', $lblDestinataire);
    $smarty->assign('jdcInfo', 'Pour voir votre JDC par cours');
    $smarty->assign('corpsPage', 'jdc/jdcCours');
    }
