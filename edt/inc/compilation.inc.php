<?php

$module = $Application->getModule(1);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

// liste des périodes de cours dans l'école
$listePeriodes = $Edt->getPeriodesCours(true, true);

$smarty->assign('listePeriodes', $listePeriodes);

$smarty->assign('corpsPage', 'compilation');
