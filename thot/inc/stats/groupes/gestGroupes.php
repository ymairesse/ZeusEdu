<?php

// require_once INSTALL_DIR
//
$listeMesGroupes = $Thot->getListeProprioGroupes($acronyme);

$smarty->assign('listeMesGroupes', $listeMesGroupes);

$smarty->assign('corpsPage','groupes/gestGroupes');
