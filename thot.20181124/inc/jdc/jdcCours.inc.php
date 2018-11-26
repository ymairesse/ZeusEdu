<?php

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;

if (in_array($coursGrp, array_keys($listeCours)))
    setcookie('coursGrp', $coursGrp, $unAn, '/', null, false, true);
    else if ($coursGrp == 'synoptique')
        setcookie('coursGrp', 'synoptique', $unAn, '/', null, false, true);
        else $coursGrp = Null;

// pour le sélecteur
$smarty->assign('coursGrp', $coursGrp);

$smarty->assign('listeCours', $listeCours);

$smarty->assign('selecteur', 'selecteurs/selectCoursPOST');

if ($coursGrp == 'synoptique') {
    $smarty->assign('editable', false);
    $smarty->assign('lblDestinataire', 'Tous les cours');
    $smarty->assign('synoptique', true);
    $smarty->assign('jdcInfo', 'Pour voir tous les cours de votre JDC (en consultation seulement)');
    $smarty->assign('corpsPage', 'jdc/jdcCours');
    }
    else if ($coursGrp != Null) {
        $smarty->assign('editable', true);
        $lblDestinataire =  $Jdc->getLabel('coursGrp', $coursGrp, $listeCours);
        $smarty->assign('lblDestinataire', $lblDestinataire);
        $smarty->assign('synoptique', false);
        $smarty->assign('jdcInfo', 'Pour voir votre JDC par cours');
        $smarty->assign('corpsPage', 'jdc/jdcCours');
        }
