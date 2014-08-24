<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");
// ----------------------------------------------------------------------------
//

$page = isset($_REQUEST['page'])?$_REQUEST['page']:Null;
$cible = isset($_REQUEST['cible'])?$_REQUEST['cible']:Null;

$smarty->assign('corpsPage',$page);
$smarty->assign('cible',$cible);

//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime", round($chrono->stop(),6));
$smarty->display ("index.tpl");
?>
