<?php

require_once '../config.inc.php';
include INSTALL_DIR.'/inc/entetes.inc.php';

// ----------------------------------------------------------------------------
//

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

$identite = $user->identite();
$acronyme = $user->getAcronyme();
$smarty->assign('identite', $identite);

$photo = $user->photoExiste();
$smarty->assign('photo', $photo);
$smarty->assign('logins', $Application->lastAccess(0, 40, $acronyme));
$smarty->assign('corpsPage', 'fichePerso');

//
// ----------------------------------------------------------------------------

$smarty->assign('executionTime', round($chrono->stop(), 6));
$smarty->display('index.tpl');
