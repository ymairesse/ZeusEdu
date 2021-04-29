<?php


require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeProfs = $Ecole->listeProfs(true);

$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('corpsPage', 'test');
