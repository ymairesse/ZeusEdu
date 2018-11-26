<?php

require_once (INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();

$stats = $thot->statsParents();
$smarty->assign('statsParents', $stats);

$smarty->assign('corpsPage', 'statsParents');
