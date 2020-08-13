<?php

$module = $Application->getModule(1);

$ds = DIRECTORY_SEPARATOR;

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

$usedCateogries = $Jdc->getUsedCategories();
$listeCategories = $Jdc->categoriesTravaux();

$smarty->assign('listeCategories', $listeCategories);
$smarty->assign('usedCategories', $usedCateogries);

$smarty->assign('corpsPage', 'jdc/itemsJdc');
