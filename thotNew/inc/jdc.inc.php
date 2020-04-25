<?php

switch ($mode) {
    case 'coursGrp':
        $smarty->assign('type', 'coursGrp');
        require_once 'inc/jdc/jdcCoursGrp.php';
        break;

    case 'subjectif':
        $smarty->assign('type', 'subjectif');
        require_once 'inc/jdc/subjectifEleve.php';
        break;

    case 'jdcAny':
        $smarty->assign('type', 'jdcAny');
        require_once 'inc/jdc/jdcAny.php';
        break;
    }
