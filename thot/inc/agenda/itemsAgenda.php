<?php

$module = $Application->getModule(1);

$ds = DIRECTORY_SEPARATOR;

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.Agenda.php';
$Agenda = new Agenda();

$usedCategories = $Agenda->getUsedCategories();
$listeCategories = $Agenda->getCategoriesAgenda();

$smarty->assign('listeCategories', $listeCategories);
$smarty->assign('usedCategories', $usedCategories);

$smarty->assign('corpsPage', 'agenda/itemsAgenda');
