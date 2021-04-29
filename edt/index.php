<?php

require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");

// ----------------------------------------------------------------------------
//

switch ($action) {
    case 'compilation':
        require_once 'inc/compilation.inc.php';
        break;
    case 'absencesProfs':
        require_once 'inc/absencesProfs.php';
        break;
    case 'test':
        require_once 'inc/test.php';
        break;
    case 'sendICal':
        require_once 'inc/sendICal.php';
        break;
    default:
        $module = $Application->getModule(1);
        $ds = DIRECTORY_SEPARATOR;

        if (file_exists (INSTALL_DIR.$ds.$module.$ds.'index.html'))
            $link = BASEDIR.$module.$ds.'index.html';
            else $link = BASEDIR.$module.$ds.'installEDT.html';

        $smarty->assign('link', $link);
        $smarty->assign('corpsPage','main');
        break;
}

//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime", round($chrono->stop(),6));
$smarty->display ("index.tpl");
