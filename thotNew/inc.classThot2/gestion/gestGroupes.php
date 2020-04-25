<?php

$module = $Application->getModule(1);

$listeMyGroups = $Thot->getListeGroupes4User($acronyme);

$smarty->assign('listeMyGroups', $listeMyGroups);

$smarty->assign('corpsPage', 'gestion/gestGroupes');
