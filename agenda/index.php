<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");

// ----------------------------------------------------------------------------
//

$smarty->assign('corpsPage','agenda');

//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime", round($chrono->stop(),6));
$smarty->display ("index.tpl");
?>
