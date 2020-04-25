<?php

$module = $Application->getModule(1);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

$listeCategories = $Jdc->getListeCategoriesJDC();
$smarty->assign('listeCategories', $listeCategories);

$smarty->assign('corpsPage', 'jdc/modeleSemaine');
