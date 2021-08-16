<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';

// quel est l'utilisateur actif
$acronyme = $user->acronyme();

$module = $Application->getModule(1);


// ----------------------------------------------------------------------------
//

switch ($action) {
    case 'synthese':
        $smarty->assign('corpsPage', 'syntheseInf');
        break;
    default:
        $smarty->assign('listeClasses', $Ecole->listeGroupes());
        $smarty->assign('corpsPage', 'visite');
        break;
}

//
// ----------------------------------------------------------------------------
$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('executionTime', round($chrono->stop(),6));

$smarty->display ('index.tpl');
