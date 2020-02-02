<?php

$table = isset($_REQUEST['table'])?$_REQUEST['table']:Null;

if ($table == Null) die('missing table');

$smarty->assign('table', $table);
$smarty->assign('entete', $Application->SQLtableFields2array($table));

$nbRows = $Application->nbRows4table($table);
$boutons = $Application->listeBoutons(1, $nbRows);

$tableau = $Application->SQLtable2array($table, 0, 20);
$smarty->assign('tableau', $tableau);

$smarty->assign('indice', 1);
$smarty->assign('boutons', $boutons);
$smarty->assign('class', 'tableauAdmin');
$smarty->assign('corpsPage', 'lookTable');
