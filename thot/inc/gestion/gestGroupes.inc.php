<?php

$module = $Application->getModule(1);

$listeMyGroups = $Thot->listeGroupes4User($acronyme, 'proprio');
$smarty->assign('listeMyGroups', $listeMyGroups);

$smarty->assign('corpsPage', 'gestion/gestGroupes');
