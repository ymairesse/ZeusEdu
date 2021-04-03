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
    case 'sendICal':
        require_once 'inc/sendICal.php';
        break;
    default:
        $module = $Application->getModule(1);
        $smarty->assign('link', BASEDIR.$module);
        $smarty->assign('corpsPage','main');
        break;
}

//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime", round($chrono->stop(),6));
$smarty->display ("index.tpl");
