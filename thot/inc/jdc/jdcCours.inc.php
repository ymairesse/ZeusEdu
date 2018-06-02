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

    $homeDir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;
    // ce répertoire existe-t-il déjà? Sinon, on le crée...
    if (!(is_Dir($homeDir)))
        $resultat = mkdir($homeDir, 0770, true);

    require_once INSTALL_DIR.'/inc/classes/class.Treeview.php';
    $tree = new Treeview(INSTALL_DIR.$ds.'upload'.$ds.$acronyme);

    $smarty->assign('tree', $tree);
    $lblDestinataire =  $Jdc->getLabel('cours', $coursGrp, $listeCours);
    $smarty->assign('lblDestinataire', $lblDestinataire);
    $smarty->assign('mode', $mode);
    $smarty->assign('jdcInfo', 'Pour voir votre JDC par cours');
    $smarty->assign('corpsPage', 'jdc');
    }
