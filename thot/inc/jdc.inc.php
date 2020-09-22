<?php


// categories de JDC existants (matières vues, devoir,...)
$categories = $Jdc->categoriesTravaux();
$smarty->assign('categories', $categories);

switch ($mode) {
    case 'coursGrp':
        $listeCoursGrp = $Ecole->listeCoursProf($acronyme, true);
        $smarty->assign('type', 'coursGrp');
        $smarty->assign('listeCoursGrp', $listeCoursGrp);
        $smarty->assign('corpsPage', 'jdc/indexJDC');
        break;

    case 'jdcAny':
        require_once 'inc/jdc/jdcAny.inc.php';
        break;

    case 'subjectif':
        $smarty->assign('type', 'subjectif');
        require_once 'inc/jdc/subjectifEleve.inc.php';
        break;

    default:
        // wtf
        break;
    }
