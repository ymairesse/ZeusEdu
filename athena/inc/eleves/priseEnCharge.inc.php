<?php

require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
$Athena = new Athena();

$listeDemandes = $Athena->getDemandesSuivi();
$smarty->assign('listeDemandes', $listeDemandes);

$smarty->assign('corpsPage', 'eleves/listeDemandes');
